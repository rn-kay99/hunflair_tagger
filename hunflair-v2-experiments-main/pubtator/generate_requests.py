import argparse
import os
import requests

from pathlib import Path
from unidecode import unidecode


def submit_requests(input_dir: Path, session_no_file: Path, bioconcept: str):
    length_articles = 0
    num_files = 0

    with session_no_file.open("w", encoding='utf8') as session_no_writer:
        files = os.listdir(input_dir)
        for filename in files:
            # load text
            input_text = ''
            input_file = input_dir / filename
            with input_file.open("r", encoding='utf8') as file_input:
                for line in file_input:
                    line = unidecode(line)
                    input_text = input_text + line

            if len(input_text) > length_articles:
                length_articles = len(input_text)
            num_files = num_files + 1

            # submit request
            r = requests.post(
                f"https://www.ncbi.nlm.nih.gov/research/pubtator-api/annotations/annotate/submit/{bioconcept}",
                data=input_text.encode('utf-8'))
            if r.status_code != 200:
                print("[Error]: HTTP code " + str(r.status_code))
            else:
                session_id = r.text
                print("Thanks for your submission. The session number is : " + session_id + "\n")
                session_no_writer.write(session_id + "\t" + filename + "\n")

    # estimating process time
    time_waiting = num_files * 200 + 250
    time_loading = 200
    time_processing = length_articles / 800
    estimated_duration = time_waiting + time_loading + time_processing

    print("Estimated time to complete : " + str(int(estimated_duration)) + " seconds")


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dir", type=Path, required=True,
                        help="Path to folder containing the files that should be send to the PubTator API")
    parser.add_argument("--output_dir", type=Path, required=True,
                        help="Path to the output folder")
    parser.add_argument("--bioconcept", type=str, required=False, default="All",
                        help="Value of the PubTator bioconcept parameter")
    args = parser.parse_args()

    session_no_file = args.output_dir / "pubtator" / "session_ids.txt"
    input_dir = args.input_dir / "pubtator" / "text"

    print(args.bioconcept)
    submit_requests(input_dir, session_no_file, args.bioconcept)
