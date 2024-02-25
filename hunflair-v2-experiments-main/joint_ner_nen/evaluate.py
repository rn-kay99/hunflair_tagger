#!/usr/bin/env python3
"""
Evaluate NEN performance given gold and prediction files in PubTator format
"""

import os
from typing import List, Union

import pandas as pd
from bioc import pubtator

ENTITY_TYPES = ["disease", "chemical", "species", "gene"]
CORPUS_TO_ENTITY_TYPES = {"bc5cdr": ["chemical", "disease"]}
DISEASE = "disease"
CHEMICAL = "chemical"
SPECIES = "species"
GENE = "gene"


def multi_label_match(y_pred: set, y_true: set) -> int:
    """
    As gold mentions can have multiple identifiers.
    We use a **relaxed** version of a match,
    i.e. we consider the prediction correct
    if any of the predicted identifier is equal to any of the gold ones.
    """

    return int(any(yp in y_true for yp in y_pred))


def relaxed_true_positives(y_pred: dict, y_true: dict):
    """
    Compute TP count with relaxed matching,
    i.e. pred is TP if any of its identifiers is in the gold set
    """
    tps = []
    for (start, end), yt in y_true.items():
        yp = y_pred.get((start, end), set())
        if multi_label_match(y_pred=yp, y_true=yt):
            tps.append((start, end, yt))
    return tps


class EvaluationMetrics:
    """
    Micro and macro precision, recall and F1

    Heavily inspired from:
        https://github.com/nicola-decao/efficient-autoregressive-EL/blob/master/src/utils.py
    """

    def __init__(
        self,
        mention_level: bool = True,
    ):
        self.mention_level = mention_level
        self.micro_p_n = 0.0
        self.micro_p_d = 0.0
        self.micro_r_n = 0.0
        self.micro_r_d = 0.0
        self.macro_p_n = 0.0
        self.macro_r_n = 0.0
        self.macro_d = 0

    def update(self, y_true: Union[dict, set], y_pred: Union[dict, set]):
        """
        Update counts for metrics
        """
        if self.mention_level:
            assert isinstance(
                y_true, dict
            ), "Mention-level metrics expect a dictionary in the form `{offset : identifiers}`"
            assert isinstance(
                y_pred, dict
            ), "Mention-level metrics expect a dictionary in the form `{offset : identifiers}`"
            tps = relaxed_true_positives(y_true=y_true, y_pred=y_pred)
        else:
            assert isinstance(
                y_true, set
            ), "Document-level metrics expect a set of identifiers"
            assert isinstance(
                y_pred, set
            ), "Document-level metrics expect a set of identifiers"
            tps = y_true.intersection(y_pred)

        # # MICRO-PRECISION
        self.micro_p_n += len(tps)
        self.micro_p_d += len(y_pred)

        # # MICRO-RECALL
        self.micro_r_n += len(tps)
        self.micro_r_d += len(y_true)

        # # MACRO-PRECISION
        self.macro_p_n += (len(tps) / len(y_pred)) if len(y_pred) > 0 else 0
        # # MACRO-RECALL
        self.macro_r_n += len(tps) / len(y_true)
        self.macro_d += 1

    def compute(self) -> dict:
        """
        Finilize metrics
        """
        # (self.n / self.d) if self.d > 0 else self.d
        micro_p = (self.micro_p_n / self.micro_p_d) if self.micro_p_d > 0 else 0
        micro_r = (self.micro_r_n / self.micro_r_d) if self.micro_r_d > 0 else 0
        macro_p = (self.macro_p_n / self.macro_d) if self.macro_d > 0 else 0
        macro_r = (self.macro_r_n / self.macro_d) if self.macro_d > 0 else 0

        metrics = {
            "micro_p": micro_p,
            "micro_r": micro_r,
            "micro_f1": (
                (2 * micro_p * micro_r / (micro_p + micro_r))
                if (micro_p + micro_r) > 0
                else (micro_p + micro_r)
            ),
            "macro_p": macro_p,
            "macro_r": macro_r,
            "macro_f1": (
                (2 * macro_p * macro_r / (macro_p + macro_r))
                if (macro_p + macro_r) > 0
                else (macro_p + macro_r)
            ),
        }

        return {k: round(v, 4) for k, v in metrics.items()}


def evaluate(gold: dict, preds: dict, mention_level: bool = True) -> pd.DataFrame:
    """
    Compute micro- and macro-precision, recall and f1.
    """

    results: dict = {}
    data = []

    for method, pred in preds.items():
        for corpus, entity_type_pmid in gold.items():
            for entity_type, pmid_entities in entity_type_pmid.items():
                setting = (method, corpus, entity_type)
                if setting not in results:
                    results[setting] = EvaluationMetrics(mention_level=mention_level)

                for pmid, y_true in pmid_entities.items():
                    try:
                        y_pred = pred[corpus][entity_type][pmid]
                    except KeyError:
                        y_pred = {}

                    if not mention_level:
                        y_pred = set(i for offset, ids in y_pred.items() for i in ids)
                        y_true = set(i for offset, ids in y_true.items() for i in ids)

                    results[setting].update(y_true=y_true, y_pred=y_pred)

                row = {"method": method, "corpus": corpus, "entity_type": entity_type}
                row.update(results[setting].compute())
                data.append(row)

    return pd.DataFrame(data)


def clean_identifiers(ids: str) -> List:
    """
    Homogenize identifiers
    """

    return (
        ids.replace("NCBI Gene:", "")
        .replace("NCBI taxon:", "")
        .replace("NCBITaxon:", "")
        .upper()
        .split(";")
    )


def load_pubtator(path: str, entity_types: List[str]) -> dict:
    """
    Load annotations from PubTator into nested dict:
        - pmid:
            - entity_type:
                - offset:
                    - identifiers
    """

    annotations: dict = {}

    with open(path) as fp:
        documents = pubtator.load(fp)
        for d in documents:
            for a in d.annotations:
                if a.type == "NCBITaxon":
                    a.type = "species"

                entity_type = a.type.lower()

                if entity_type not in entity_types:
                    continue

                if entity_type not in annotations:
                    annotations[entity_type] = {}

                if a.pmid not in annotations[entity_type]:
                    annotations[entity_type][a.pmid] = {}

                identifiers = clean_identifiers(a.id)

                annotations[entity_type][a.pmid][(a.start, a.end)] = identifiers

    return annotations


def load_bern(path: str, entity_types: List[str]) -> dict:
    """
    Load annotations from BERN into nested dict:
        - pmid:
            - entity_type:
                - offset:
                    - identifiers
    """

    annotations: dict = {}

    with open(path) as fp:
        for line in fp:
            line = line.strip()

            if line == "":
                continue

            elements = line.split("\t")

            if len(elements) == 6:
                pmid, start, end, _, entity_type, ids = elements
            elif len(elements) == 5:
                pmid, start, end, _, entity_type = elements
                ids = "-1"

            if entity_type not in entity_types:
                continue

            if entity_type not in annotations:
                annotations[entity_type] = {}

            if pmid not in annotations[entity_type]:
                annotations[entity_type][pmid] = {}

            identifiers = clean_identifiers(ids)

            annotations[entity_type][pmid][(int(start), int(end))] = identifiers

    return annotations


def condense(df: pd.DataFrame, metric: str = "micro_f1") -> pd.DataFrame:
    """Extract most representative metric"""

    table: dict = {}
    for r in df.to_dict("records"):
        setting = "-".join((r["corpus"], r["entity_type"]))
        if setting not in table:
            table[setting] = {}
        table[setting][r["method"]] = r[metric]

    return pd.DataFrame(
        [{"corpus": setting} | results for setting, results in table.items()]
    )


def main():
    """
    Script
    """

    CORPORA = {
        "craft": [DISEASE, SPECIES],
        "medmentions": [DISEASE, CHEMICAL],
        "tmvar_v3": [GENE],
        "bioid": [SPECIES],
    }
    CORPORA_MAPPED_TO_CTD = ["craft", "medmentions"]
    MODELS = ["bern", "hunflair-transformers-aio", "pubtator"]
    # MODELS = ["bern", "pubtator"]

    print("*" * 80)
    print("Evaluate cross-corpus joint NER and NEN")
    print("*" * 80)

    print("-" * 80)
    print("Load gold annotations")
    print("-" * 80)

    gold_dir = os.path.join(os.getcwd(), "annotations", "goldstandard")
    gold = {}
    for corpus, entity_types in CORPORA.items():
        name = (
            corpus if corpus not in CORPORA_MAPPED_TO_CTD else f"{corpus}_mapped_to_ctd"
        )
        path = os.path.join(gold_dir, f"{name}.txt")
        print(f"Load gold annotations for corpus {corpus}: {path}")
        gold[corpus] = load_pubtator(path, entity_types=entity_types)

    print("-" * 80)
    print("Load predicted annotations")
    print("-" * 80)

    preds = {}
    for model in MODELS:
        model_dir = os.path.join(os.getcwd(), "annotations", model)
        preds[model] = {}

        if model == "bern":
            load_fn = load_bern
        else:
            load_fn = load_pubtator

        for corpus, entity_types in CORPORA.items():
            name = f"{corpus}_ner_nen" if model.startswith("hunflair") else corpus
            path = os.path.join(os.getcwd(), model_dir, f"{name}.txt")
            print(f"Load model `{model}` annotations for corpus {corpus}: {path}")
            preds[model][corpus] = load_fn(path, entity_types=entity_types)

    print("-" * 80)
    print("Mention-level:")
    print("-" * 80)
    mention_level_df = evaluate(gold=gold, preds=preds, mention_level=True)
    print(mention_level_df)
    print("-" * 80)
    print(condense(mention_level_df))

    # print("-" * 80)
    # print("Document-level:")
    # print("-" * 80)
    # document_level_df = evaluate(gold=gold, preds=preds, mention_level=False)
    # print(document_level_df)
    # print("-" * 80)
    # print(condense(document_level_df))


if __name__ == "__main__":
    main()
