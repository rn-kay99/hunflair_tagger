import argparse

from pathlib import Path

from utils import read_documents_from_pubtator


def combine_results(
        input_file_dir: Path,
        output_file: Path,
        write_text: bool
):
    with output_file.open("w", encoding="utf8") as writer:
        # Read annotations
        for file in sorted(input_file_dir.iterdir()):
            documents = read_documents_from_pubtator(file)
            for document in documents:
                if write_text:
                    writer.write(f"{document.id}|t|{document.title}\n")
                    doc_text = document.title

                    if document.abstract is not None and len(document.abstract):
                        writer.write(f"{document.id}|a|{document.abstract}\n")
                        doc_text += " " + document.abstract

                for annotation in document.annotations:
                    values = [str(document.id)] + list(annotation)[1:]
                    writer.write("\t".join([str(v) for v in values]) + "\n")

                writer.write("\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dir", type=Path, required=True,
                        help="Path to the input data set")
    parser.add_argument("--output_file", type=Path, required=True,
                        help="Path to the output file")
    parser.add_argument("--write_text", action="store_true", default=False,
                        help="Indicates whether to include the documents text in the output file")
    args = parser.parse_args()

    pubtator_dir = args.input_dir / "pubtator"
    input_dir = pubtator_dir / "files"

    combine_results(
        input_file_dir=input_dir,
        output_file=args.output_file,
        write_text=args.write_text
    )
