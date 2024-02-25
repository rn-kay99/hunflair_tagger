#!/usr/bin/evim python3
"""
Map MedMentions UMLS and CRAFT MONDO to CTD (Diseases/Chemicals)
"""

import argparse
import copy
import json
import os
from typing import List, Tuple

import obonet
from bioc import pubtator

UMLS_ENTITY_TYPES = {
    "T103": "Chemical",
    "T120": "Chemical",
    "T104": "Chemical",
    "T197": "Chemical",
    "T109": "Chemical",
    "T047": "Disease",
    "T050": "Disease",
    "T017": "Disease",
    "T033": "Disease",
    "T038": "Disease",
}


def parse_args():
    """
    Parse arguments
    """
    parser = argparse.ArgumentParser(
        description="Map MedMentions UMLS and CRAFT MONDO to CTD (Diseases/Chemicals)"
    )
    parser.add_argument(
        "--dir",
        required=True,
        type=str,
        help="Directory where all data is stored (see README.md)",
    )
    return parser.parse_args()


# NOTE: see Table 1 here for description: https://www.ncbi.nlm.nih.gov/books/NBK9685/#ch03.sec3.3.4
MRCONSO_COLUMNS = [
    "CUI",
    "LAT",
    "TS",
    "LUI",
    "STT",
    "SUI",
    "ISPREF",
    "AUI",
    "SAUI",
    "SCUI",
    "SDUI",
    "SAB",
    "TTY",
    "CODE",
    "STR",
    "SRL",
    "CVF",
]

CTD_DISEASES_COLUMNS = [
    "symbol",
    "identifier",
    "alternative_identifiers",
    "definition",
    "parent_identifiers",
    "tree_numbers",
    "parent_tree_numbers",
    "synonyms",
    "slim_mappings",
]

CTD_CHEMICALS_COLUMNS = [
    "symbol",
    "identifier",
    "casrn",
    "definition",
    "parent_identifiers",
    "tree_numbers",
    "parent_tree_numbers",
    "synonyms",
]


def parse_mrconso(path: str) -> Tuple[dict, dict]:
    """
    Parse main file UMLS file `MRCONSO.RRF`.

    Extract:
        - `cui -> synstet`: mapping from CUI to all associated names
        - `source db` -> `cui -> source_db_ids` : mappings from CUI to identifiers in original dbs (e.g. MeSH)
    """

    print(f"Load UMLS data from `{path}`")

    cui_to_names: dict = {}
    xrefs: dict = {}

    xref_code_columns = ["SAUI", "SCUI", "SDUI", "CODE"]

    with open(path) as infile:
        for line in infile:
            values = line.strip("\n").split("|")
            row = dict(zip(MRCONSO_COLUMNS, values))
            cui = row["CUI"]
            lang = row["LAT"]
            xref_db = row["SAB"]
            xref_codes = set(row[f] for f in xref_code_columns if row[f] != "")

            if xref_db == "MSH":
                xref_db = "MESH"

            if lang == "ENG":
                if cui not in xrefs:
                    xrefs[cui] = set()

                xrefs[cui].update([f"{xref_db}:{c}" for c in xref_codes])

    xrefs = {k: list(v) for k, v in xrefs.items()}

    return cui_to_names, xrefs


def parse_ctd_chemicals(path: str):
    """
    Extract identifiers from CTD_chemicals.tsv
    """

    print(f"Load CTD Chemicals data from `{path}`...")

    identifiers = set()

    with open(path) as fp:
        for line in fp:
            if line.startswith("#"):
                continue
            values = line.strip().split("\t")
            row = dict(zip(CTD_CHEMICALS_COLUMNS, values))
            identifiers.add(row["identifier"])
            identifiers.update(
                [
                    i
                    for i in row.get("alternative_identifiers", "").split("|")
                    if i != ""
                ]
            )

    return identifiers


def parse_ctd_diseases(path: str):
    """
    Extract identifiers from CTD_diseases.tsv
    """

    print(f"Load CTD Diseases data from `{path}`...")

    identifiers = set()

    with open(path) as fp:
        for line in fp:
            if line.startswith("#"):
                continue
            values = line.strip().split("\t")
            row = dict(zip(CTD_CHEMICALS_COLUMNS, values))
            identifiers.add(row["identifier"])
            identifiers.update(
                [
                    i
                    for i in row.get("alternative_identifiers", "").split("|")
                    if i != ""
                ]
            )

    return identifiers


def medmentions_get_ctd_annotations(
    annotations: List[pubtator.PubTatorAnn],
    xrefs: dict,
    ctd: dict,
) -> List[pubtator.PubTatorAnn]:
    """
    map to CTD
    """

    annotations = [a for a in annotations if a.type in UMLS_ENTITY_TYPES]

    ctd_annotations = []
    for a in annotations:
        cuis = a.id.replace("UMLS:", "")
        cuis = cuis.split(",")
        ids = [
            cand
            for cui in cuis
            for cand in xrefs[cui]
            if (cand in ctd["chemical"] or cand in ctd["disease"])
        ]
        if len(ids) > 0:
            a.type = UMLS_ENTITY_TYPES[a.type]
            a.id = ";".join([i for i in ids if i in ctd[a.type.lower()]])
            ctd_annotations.append(a)

    return ctd_annotations


def parse_mondo(path: str) -> dict:
    """
    Read xrefs from MONDO
    """
    mondo = obonet.read_obo(path)
    mondo_to_ctd = {}
    for identifier, data in mondo.nodes(data=True):
        xrefs = [x for x in data.get("xref", []) if x.startswith(("MESH:", "OMIM:"))]
        if len(xrefs) > 0:
            mondo_to_ctd[identifier] = xrefs

    return mondo_to_ctd


def get_medmentions_mapped_to_ctd(
    documents: List[pubtator.PubTator], xrefs: dict, ctd: dict
) -> List[pubtator.PubTator]:
    """
    Documents only if **all** annotations are in CTD
    """

    mapped_documents = []

    for document in documents:
        ctd_annotations = medmentions_get_ctd_annotations(
            annotations=copy.deepcopy(document.annotations),
            xrefs=xrefs,
            ctd=ctd,
        )

        # if len(ctd_annotations) == 0:
        #     continue

        document.annotations = ctd_annotations
        mapped_documents.append(document)

    print(f"Total documents:  {len(documents)}")
    print(f"Total mapped documents:  {len(mapped_documents)}")

    return mapped_documents


def get_craft_mapped_to_ctd(documents: List[pubtator.PubTator], xrefs: dict, ctd: dict):
    """
    Map annotations to CTD
    """

    with_disease_annotations = 0
    num_mapped_documents = 0
    mapped_documents = []

    for document in documents:

        disease_annotations = [a for a in document.annotations if a.type == "MONDO"]

        other_annotations = [
            a for a in document.annotations if a not in disease_annotations
        ]

        for a in disease_annotations:
            a.id = a.id.split("MONDO:", maxsplit=1)[1]

        with_disease_annotations += 1

        mapped_annotations = []
        for idx, a in enumerate(disease_annotations):
            if xrefs.get(a.id) is not None:
                ids = [i for i in xrefs[a.id] if i in ctd["disease"]]
                if len(ids) > 0:
                    if idx == 0:
                        num_mapped_documents += 1
                    a.type = "Disease"
                    a.id = ";".join(ids)
                    mapped_annotations.append(a)

        document.annotations = sorted(
            mapped_annotations + other_annotations, key=lambda x: x.start
        )
        mapped_documents.append(document)

    print(f"Total documents:  {len(documents)}")
    print(f"Documents with disease annotations:  {with_disease_annotations}")
    print(f"Documents with disease annotations mapped to CTD: {num_mapped_documents}")

    return mapped_documents


def main():
    """
    Script
    """

    print("*" * 80)
    print("Map MedMentions and CRAFT annotations to CTD")
    print("*" * 80)

    args = parse_args()

    DIR = args.dir
    UMLS = os.path.join(args.dir, "2017AA-full", "2017AA", "META", "MRCONSO.RRF")
    CTD_CHEMICALS = os.path.join(args.dir, "CTD_chemicals.tsv")
    CTD_DISEASES = os.path.join(args.dir, "CTD_diseases.tsv")
    MONDO = os.path.join(args.dir, "mondo.obo")

    ctd_chemicals = parse_ctd_chemicals(CTD_CHEMICALS)
    ctd_diseases = parse_ctd_diseases(CTD_DISEASES)
    ctd = {"chemical": ctd_chemicals, "disease": ctd_diseases}

    print("-" * 80)
    print("Map CRAFT to CTD")
    print("-" * 80)
    mondo = parse_mondo(MONDO)

    craft_path = os.path.join(os.getcwd(), "annotations", "goldstandard", "craft.txt")
    with open(craft_path) as fp:
        craft = pubtator.load(fp)

    mapped_craft_path = os.path.join(
        os.getcwd(), "annotations", "goldstandard", "craft_mapped_to_ctd.txt"
    )
    mapped_craft = get_craft_mapped_to_ctd(documents=craft, xrefs=mondo, ctd=ctd)
    with open(mapped_craft_path, "w") as fp:
        pubtator.dump(mapped_craft, fp)

    print("-" * 80)
    print("Map MedMentions to CTD")
    print("-" * 80)
    xrefs_cache = os.path.join(DIR, "umls_xrefs.json")
    if not os.path.exists(xrefs_cache):
        _, xrefs = parse_mrconso(UMLS)
        with open(xrefs_cache, "w") as fp:
            json.dump(xrefs, fp, indent=1)

    with open(xrefs_cache) as fp:
        print("Load pre-computed UMLS cross-reference data")
        xrefs = json.load(fp)

    medmentions_path = os.path.join(
        os.getcwd(), "annotations", "goldstandard", "medmentions.txt"
    )
    with open(medmentions_path) as fp:
        medmentions = pubtator.load(fp)

    mapped_medmentions_path = os.path.join(
        os.getcwd(), "annotations", "goldstandard", "medmentions_mapped_to_ctd.txt"
    )
    mapped_medmentions = get_medmentions_mapped_to_ctd(
        documents=medmentions, xrefs=xrefs, ctd=ctd
    )
    with open(mapped_medmentions_path, "w") as fp:
        pubtator.dump(mapped_medmentions, fp)


if __name__ == "__main__":
    main()
