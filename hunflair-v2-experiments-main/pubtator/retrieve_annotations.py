import argparse
import re
import requests

from pathlib import Path


def convert_to_pubtator(input_file: Path, output_file: Path, original_file: Path):
    title_uni = {}
    abstact_uni = {}
    with original_file.open("r", encoding='utf8') as orig_input:
        title = ""
        abstract = ""
        for line in orig_input:
            line = line.rstrip()
            p_title = re.compile('^([0-9]+)\|t\|(.*)$')
            p_abstract = re.compile('^([0-9]+)\|a\|(.*)$')
            if p_title.search(line):
                m = p_title.match(line)
                pmid = m.group(1)
                title = m.group(2)
                title_uni[pmid] = title
            elif p_abstract.search(line):
                m = p_abstract.match(line)
                pmid = m.group(1)
                abstract = m.group(2)
                abstact_uni[pmid] = abstract

    with output_file.open("w", encoding='utf8') as output_writer:
        with input_file.open("r", encoding='utf8') as file_input:
            for line in file_input:
                line = line.rstrip()
                p_title = re.compile('^([0-9]+)\|t\|(.*)$')
                p_abstract = re.compile('^([0-9]+)\|a\|(.*)$')
                p_annotation = re.compile('^([0-9]+)	([0-9]+)	([0-9]+)	([^\t]+)	([^\t]+)(.*)')
                if p_title.search(line):  # title
                    m = p_title.match(line)
                    pmid = m.group(1)
                    output_writer.write(pmid + "|t|" + title_uni[pmid] + "\n")
                elif p_abstract.search(line):  # abstract
                    m = p_abstract.match(line)
                    pmid = m.group(1)
                    output_writer.write(pmid + "|a|" + abstact_uni[pmid] + "\n")
                elif p_annotation.search(line):  # annotation
                    m = p_annotation.match(line)
                    pmid = m.group(1)
                    start = m.group(2)
                    last = m.group(3)
                    mention = m.group(4)
                    type = m.group(5)
                    id = m.group(6)
                    tiabs = title_uni[pmid] + " " + abstact_uni[pmid]
                    mention = tiabs[int(start):int(last)]

                    while mention.startswith(" "):
                        if mention.startswith(" "):
                            mention = mention[1:]
                            start = str(int(start) + 1)
                    while mention.endswith(" "):
                        if mention.endswith(" "):
                            mention = mention[:-1]
                            last = str(int(last) - 1)

                    output_writer.write(pmid + "\t" + start + "\t" + last + "\t" + mention + "\t" + type + id + "\n")
                else:
                    output_writer.write(line + "\n")


def get_annotation_result(input_dir: Path, output_dir: Path):
    # Load session numbers
    session_no_file = output_dir / "session_ids.txt"
    input_text_dir = input_dir / "text"

    ann_output_dir = output_dir / "files"
    ann_output_dir.mkdir(parents=True, exist_ok=True)

    tmp_dir = output_dir / "tmp"
    tmp_dir.mkdir(parents=True, exist_ok=True)

    num_finished = 0
    num_documents = 0

    with session_no_file.open("r", encoding="utf-8") as file_input:
        for line in file_input:
            num_documents += 1

            pattern = re.compile('^([^\t]+)	(.+)$')
            if pattern.search(line):  # title
                m = pattern.match(line)
                session_no = m.group(1)
                filename = m.group(2)

                output_file = ann_output_dir / filename
                if output_file.exists():
                    print(str(output_file) + " - finished")
                    num_finished += 1
                else:
                    #
                    # retrieve result
                    #
                    r = requests.get(
                        "https://www.ncbi.nlm.nih.gov/research/pubtator-api/annotations/annotate/retrieve/" + session_no)
                    code = r.status_code
                    if code == 200:
                        tmp_file = tmp_dir / filename
                        with tmp_file.open("w", encoding="utf8") as writer:
                            response = r.text
                            writer.write(response + "\n")

                        input_file = input_text_dir / filename
                        output_file = ann_output_dir / filename
                        convert_to_pubtator(tmp_file, output_file, input_file)

                        print(session_no + " : Result is retrieved.")
                        num_finished += 1
                    else:
                        print(session_no + " : Result is not ready. please wait.")

    print(f"\n\nFinished {num_finished} out of {num_documents}")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dir", type=Path, required=True,
                        help="Path to data set folder (which contains a pubtator sub-directory)")
    parser.add_argument("--output_dir", type=Path, required=True,
                        help="Path to the data set output folder")
    args = parser.parse_args()

    input_dir = args.input_dir / "pubtator"
    output_dir = args.output_dir / "pubtator"

    get_annotation_result(input_dir, output_dir)
