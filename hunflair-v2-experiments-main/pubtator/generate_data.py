import argparse

from pathlib import Path
from typing import List

from utils import get_documents_from_bigbio


def generate_pubtator_files(
        data_set: str,
        output_dir: Path,
        instances_per_file: int,
        exclude_splits: List[str]
):
    text_output_dir = output_dir / "text"
    text_output_dir.mkdir(parents=True, exist_ok=True)

    output_file_id = 0
    output_writer = None
    text_id = 0

    documents = get_documents_from_bigbio(data_set, exclude_splits=exclude_splits)
    for doc_id, document in documents.items():
        if output_writer is None:
            output_file = Path(text_output_dir / f"input_{output_file_id}.txt")
            output_writer = output_file.open("w", encoding="utf8")

        title = document.title if document.title is not None else ""
        abstract = document.abstract if document.abstract is not None else ""

        # Substitute delta characters - otherwise some documents will not be processed
        title = title.replace("Δ", "*").replace("‐", "-")
        abstract = abstract.replace("Δ", "*").replace("‐", "-")

        if not abstract:
            abstract = "Here follows the abstract"

        output_writer.write(f"{doc_id}|t|{title}\n{doc_id}|a|{abstract}\n\n")

        text_id += 1
        if text_id % instances_per_file == 0:
            output_writer.close()
            output_writer = None
            output_file_id += 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--data_set", type=str, required=True,
                        help="Name of the bigbio data set (without bigbio/)")
    parser.add_argument("--output_dir", type=Path, required=True,
                        help="Path to the output directory")
    parser.add_argument("--docs_per_file", type=int, required=True,
                        help="Number of documents per output file")
    parser.add_argument("--exclude_splits", type=str, nargs="*", default=[],
                        help="Splits of the data set to be excluded")
    args = parser.parse_args()

    # Automatically create an pubtator sub-directory
    output_dir = args.output_dir / "pubtator"
    output_dir.mkdir(parents=True, exist_ok=True)

    generate_pubtator_files(
        data_set=args.data_set,
        output_dir=output_dir,
        instances_per_file=args.docs_per_file,
        exclude_splits=args.exclude_splits
    )
