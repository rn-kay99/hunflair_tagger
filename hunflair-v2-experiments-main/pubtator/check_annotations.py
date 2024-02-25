import argparse

from datasets import load_dataset
from pathlib import Path
from typing import List

from utils import read_documents_from_pubtator


def check(data_set: str, prediction_dir: Path, exclude_splits: List[str]):
    # Read annotations
    id_to_annotations = {}
    for file in prediction_dir.iterdir():
        documents = read_documents_from_pubtator(file)
        for document in documents:
            if document.id not in id_to_annotations:
                id_to_annotations[document.id] = []

            id_to_annotations[document.id].extend(document.annotations)

    # Read text from original data set
    data = load_dataset(f"bigbio/{data_set}", name=f"{data_set}_bigbio_kb")
    num_correct_ann = 0
    num_not_found = 0
    ann_errors = 0
    text_id = 0

    for split in sorted(data.keys()):
        if split in exclude_splits:
            print(f"Excluding {split}")
            continue

        print(f"Inspecting split: {split}")

        for document in data[split]:
            if len(document["passages"]) == 1:
                text = document["passages"][0]["text"][0].replace("Δ", "*")

            elif len(document["passages"]) == 2:
                title = None
                abstract = None
                for passage in document["passages"]:
                    if passage["type"] == "title":
                        title = passage["text"][0]
                    elif passage["type"] == "abstract":
                        abstract = passage["text"][0]
                    else:
                        raise AssertionError()
                text = title + " " + abstract

            else:
                raise AssertionError()

            if text_id not in id_to_annotations:
                num_not_found += 1
            else:
                entities = id_to_annotations[text_id]
                for (pmid, start, end, mention, type, id) in entities:
                    text_mention = text[start:end].strip()
                    if text_mention != mention:
                        print(f"{pmid}: |{text_mention}| vs |{mention}|")
                        ann_errors += 1
                    else:
                        num_correct_ann += 1

            text_id += 1

    print("\n\n")
    print(f"Documents not found: {num_not_found}")
    print(f"Annotation errors: {ann_errors}")
    print(f"Correct annotations:{num_correct_ann}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--data_set", type=str, help="Name of the data set")
    parser.add_argument("--pred_dir", type=Path, help="Path to the folder containing the predictions of the data")
    parser.add_argument("--exclude_splits", type=str, nargs="*", help="Splits of the data set to be excluded",
                        default=[])
    args = parser.parse_args()

    prediction_dir = args.pred_dir / "pubtator" / "files"

    check(args.data_set, prediction_dir, args.exclude_splits)
