import argparse
import os
import stanza

from collections import defaultdict
from pathlib import Path
from typing import Dict, List
from tqdm import tqdm

from utils import DEFAULT_TYPE_MAPPING

MODELS = [
    "bc5cdr",
    "bc4chemd",
    "bionlp13cg",
    "jnlpba",
    "linneaus",
    "ncbi_disease",
    "s800",
]

PIPELINES = ["craft", "genia"]
DATA_SETS = ["bc5cdr", "bioid", "craft", "bionlp_st_2013_cg", "pdr", "tmvar_v3"]


def read_documents(path: Path) -> Dict[str, Dict[str, str]]:
    """
    Reads documents from a file in the PubTator format.
    returns a dictionary of documents, where each document is a dictionary with a title and an abstract.
    """
    documents = {}

    with open(str(path), "r") as reader:
        for line in reader:
            line = line.strip()
            if not line or not "|" in line:
                continue
            document_id, text_type = line.split("|")[:2]

            if text_type not in ["t", "a"]:
                continue

            text = "|".join(line.split("|")[2:])

            if document_id not in documents:
                documents[document_id] = {}
            documents[document_id][text_type] = text

    return documents


def tag_documents(documents, nlp):
    annotations = defaultdict(list) # annotations are (start, end, text, type, -1)
    for document_id in tqdm(documents.keys(), total=len(documents)):
        text = documents[document_id]["t"]
        if "a" in documents[document_id]:
            text += " "
            text += documents[document_id]["a"]
        stanza_doc = nlp(text)
        for entity in stanza_doc.ents:
            annotations[document_id] += [
                (
                    str(entity.start_char),
                    str(entity.end_char),
                    entity.text,
                    entity.type,
                    "-1",
                )
            ]
    return annotations


def write_annotations(
    documents: Dict[str, Dict[str, str]],
    annotations: Dict[str, List],
    output_file: Path,
):
    """Writes annotations to a file in the PubTator format required by the evaluation script."""
    with open(str(output_file), "w") as writer:
        for document_id in tqdm(documents.keys(), total=len(documents)):
            title = documents[document_id]["t"]
            writer.write(f"{document_id}|t|{title}\n")
            if "a" in documents[document_id]:
                abstract = documents[document_id]["a"]
                writer.write(f"{document_id}|a|{abstract}\n")
            for entity in annotations[document_id]:
                start = entity[0]
                end = entity[1]
                mention = entity[2]
                entity_type = entity[3]
                db_id = entity[4]
                if entity_type.lower() not in DEFAULT_TYPE_MAPPING:
                    continue
                line_values = [
                    str(document_id),
                    start,
                    end,
                    mention,
                    DEFAULT_TYPE_MAPPING[entity_type.lower()],
                    db_id,
                ]
                writer.write("\t".join(line_values) + "\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--models", nargs="*", required=False, default=MODELS,
                        help="Models used for prediction (by default all)")
    parser.add_argument("--data_sets", nargs="*", required=False, default=DATA_SETS,
                        help="Data sets to be used (by default all)")
    parser.add_argument("--pipelines", nargs="*", required=False, default=PIPELINES,
                        help="Data sets to be used (by default all)")
    parser.add_argument("--output_dir", type=Path, required=False, default=Path("output_annotations"),
                        help="Path to the output directory")
    args = parser.parse_args()

    for pipeline in args.pipelines:
        for model in args.models:
            nlp = stanza.Pipeline(lang='en', package=pipeline, processors={"ner": model})
            for dataset_name in args.data_sets:
                output_file = Path(f"output_annotations/stanza_{pipeline}_{model}/{dataset_name}.txt")

                documents = read_documents(Path(f"annotations/goldstandard/{dataset_name}.txt"))
                annotations = tag_documents(documents, nlp)

                os.makedirs(str(output_file.parent), exist_ok=True)
                write_annotations(documents, annotations, output_file)
