import argparse
from builtins import list
from collections import defaultdict
from pathlib import Path
from typing import List, Tuple

from datasets import DownloadMode

from utils import get_documents_from_bigbio


def sanitize_entity_annotations(entities: List[Tuple]) -> List[Tuple]:
    # Some corpora we use for evaluation (e.g. bc5cdr) have multiple entity instances for the same offset
    # and entity type. These instances often highlight composite mentions which can be mapped to multiple
    # identifiers in the database (during normalization). Here we merge these instances to one by building
    # the union of the database ids.

    position_to_entities = defaultdict(list)
    for entity in entities:
        print(entity)
        start, end, _, type, _ = entity
        position_to_entities[f"{type}-{start}-{end}"].append(entity)

    sanitized_entities = []
    for _, pos_entities in position_to_entities.items():
        all_db_ids = set(
            [
                db_id
                for entity in pos_entities
                for db_id in entity[4].split(",")
                if entity[4] is not None
            ]
        )

        all_db_ids = ",".join(all_db_ids)

        entity = tuple(list(pos_entities[0][0:4]) + [all_db_ids])
        sanitized_entities.append(entity)

    # if len(sanitized_entities) != len(entities):
    #     print(sanitized_entities)

    return sanitized_entities


def generate_goldstandard_files(
    data_set: str,
    exclude_splits: List[str],
    output_dir: Path,
    file_name: str = "goldstandard.txt",
    schema: str = "bigbio_kb",
):
    output_dir.mkdir(parents=True, exist_ok=True)
    annotation_output_file = output_dir / file_name
    text_output_file = output_dir / (file_name.replace(".txt", "") + "_text.txt")

    documents = get_documents_from_bigbio(
        data_set, schema, exclude_splits, DownloadMode.FORCE_REDOWNLOAD
    )
    ann_writer = annotation_output_file.open("w", encoding="utf8")
    text_writer = text_output_file.open("w", encoding="utf8")

    for doc_id, doc in documents.items():
        ann_writer.write(f"{doc_id}|t|{doc.title}\n")
        text_writer.write(f"{doc_id}|t|{doc.title}\n")
        if doc.abstract is not None:
            ann_writer.write(f"{doc_id}|a|{doc.abstract}\n")
            text_writer.write(f"{doc_id}|a|{doc.abstract}\n")

        entities = sanitize_entity_annotations(doc.annotations)
        for start, end, mention, type, db_ids in entities:
            line_values = [str(doc_id), str(start), str(end), mention, type, db_ids]
            try:
                ann_writer.write("\t".join(line_values) + "\n")
            except TypeError:
                print(f"TypeError in {line_values}. Skipping...")

        ann_writer.write("\n")
        text_writer.write("\n")

    ann_writer.flush()
    ann_writer.close()

    text_writer.flush()
    text_writer.close()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output_dir",
        type=Path,
        default="annotations/goldstandard",
        required=False,
        help="Path to the output directory",
    )

    args = parser.parse_args()

    evaluation_datasets = [
        # NER + NEN datasets
        # ("bc5cdr", ["train", "validation"]),
        # ("tmvar_v3", []),
        # ("bioid", []),
        # NER only data sets
        # ("bionlp_st_2013_cg", ["train", "validation"]),
        # ("pdr", []),
        # ("craft", []),
        ("medmentions", []),
    ]

    for dataset, exclude_splits in evaluation_datasets:
        generate_goldstandard_files(
            data_set=dataset,
            exclude_splits=exclude_splits,
            file_name=f"{dataset}.txt",
            output_dir=args.output_dir,
        )

        # Only use for PDR
        if dataset == "pdr":
            generate_goldstandard_files(
                data_set=dataset,
                exclude_splits=exclude_splits,
                output_dir=args.output_dir / dataset,
                file_name="goldstandard_annotator1.txt",
                schema="annotator1_source",
            )

            generate_goldstandard_files(
                data_set=dataset,
                exclude_splits=exclude_splits,
                output_dir=args.output_dir / dataset,
                file_name="goldstandard_annotator2.txt",
                schema="annotator2_source",
            )
