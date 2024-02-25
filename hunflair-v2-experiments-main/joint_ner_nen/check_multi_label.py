#!/usr/bin/env python3
"""
Stats about amount of annoations w/ multiple identifiers. It prints them out to a TSV file for inspection.
"""
import json
import os
from collections import Counter

import pandas as pd
from datasets import load_dataset

EVAL_CORPORA = ["bc5cdr", "bioid", "tmvar_v3"]

CORPUS_TO_DB_NAME = {"bc5cdr": "MESH", "bioid": "Cellosaurus", "tmvar_v3": "NCBI Gene"}


def main():
    """
    Script
    """

    stats = Counter()
    inspect = []

    for corpus in EVAL_CORPORA:
        ds = load_dataset(f"bigbio/{corpus}", name=f"{corpus}_bigbio_kb")
        db_name = CORPUS_TO_DB_NAME[corpus]
        for split in ds.keys():
            for example in ds[split]:
                for e in example["entities"]:
                    normalized = [n for n in e["normalized"] if n["db_name"] == db_name]
                    if len(normalized) > 1:
                        stats[corpus] += 1
                        inspect.append(
                            {
                                "corpus": corpus,
                                "text": "||".join(e["text"]),
                                "identifiers": ";".join(
                                    [n["db_id"] for n in normalized]
                                ),
                            }
                        )

    print(stats)
    with open(os.path.join(os.getcwd(), "nen", "multi_label_stats.json"), "w") as fp:
        json.dump(dict(stats), fp)
    pd.DataFrame(inspect).to_csv(
        os.path.join(os.getcwd(), "nen", "inspect_multi_label.tsv"),
        sep="\t",
        index=False,
    )


if __name__ == "__main__":
    main()
