import argparse
import itertools

from copy import deepcopy
from pathlib import Path
from typing import List

from utils import read_documents_from_pubtator, DEFAULT_TYPE_MAPPING


def merge_annotations(
    prediction_files: List[Path],
    output_file: Path[Path]
):
    predictions = [
        { doc.id: doc for doc in read_documents_from_pubtator(pred_file, DEFAULT_TYPE_MAPPING) }
        for pred_file in prediction_files
    ]

    all_ids = sorted(set(
        itertools.chain.from_iterable([list(prediction.keys()) for prediction in predictions])
    ))

    documents = []
    for document_id in all_ids:
        doc_copy = deepcopy(predictions[0][document_id])
        for prediction in predictions[1:]:
            doc_copy.annotations.extend(prediction[document_id].annotations)

        documents.append(doc_copy)

    with output_file.open("w") as writer:
        for document in documents:
            if document.title:
                writer.write(f"{document.id}|t|{document.title}\n")
            if document.abstract:
                writer.write(f"{document.id}|a|{document.abstract}\n")

            for entity in document.annotations:
                line_values = [str(value) for value in entity]
                writer.write("\t".join(line_values) + "\n")

            writer.write("\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--pred_files", type=Path, required=True, nargs="+")
    parser.add_argument("--output_file", type=Path, required=True)
    args = parser.parse_args()

    merge_annotations(
        prediction_files=args.pred_files,
        output_file=args.output_file
    )
