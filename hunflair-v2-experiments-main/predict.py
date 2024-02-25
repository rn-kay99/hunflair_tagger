from abc import ABC, abstractmethod
from collections import defaultdict
from pathlib import Path
from typing import Dict, List, cast

from datasets import IterableDatasetDict, load_dataset
from tqdm import tqdm


class Predictor(ABC):
    def __init__(self, data_set: str, output_file: Path, test_only: bool = False):
        self.documents: Dict[int, Dict[str, str]] = {}
        self.annotations: Dict[str, List] = defaultdict(list)
        self.data_set = data_set
        self.output_file = output_file
        self.test_only = test_only
        self._read_documents()
        self._tag_documents()
        self._write_annotations()

    def _read_documents(self):
        # Handle special cases
        if self.data_set == "medmentions":
            schema = f"{self.data_set}_st21pv_bigbio_kb"  # MedMentions uses a different schema
        else:
            schema = f"{self.data_set}_bigbio_kb"

        data = cast(
            IterableDatasetDict,
            load_dataset(f"bigbio/{self.data_set}", name=schema),
        )

        doc_id = 0
        for split in sorted(data.keys()):
            if self.test_only and split != "test":
                continue

            print(f"Reading documents for {split}")
            for doc in data[split]:
                self.documents[doc_id] = {}
                if len(doc["passages"]) == 1:
                    self.documents[doc_id]["title"] = (
                        doc["passages"][0]["text"][0].replace("\n", " ").strip()
                    )
                elif len(doc["passages"]) == 2:
                    for passage in doc["passages"]:
                        if passage["type"] == "title":
                            self.documents[doc_id]["title"] = (
                                passage["text"][0].replace("\n", " ").strip()
                            )
                        elif passage["type"] == "abstract":
                            self.documents[doc_id]["abstract"] = (
                                passage["text"][0].replace("\n", " ").strip()
                            )
                        else:
                            raise AssertionError()
                else:
                    # Used for nlmchem dataset
                    for passage in doc["passages"]:
                        if "fulltext" not in self.documents[doc_id]:
                            self.documents[doc_id]["fulltext"] = (
                                passage["text"][0].replace("\n", " ").strip()
                            )
                        else:
                            self.documents[doc_id]["fulltext"] += (
                                " " + passage["text"][0].replace("\n", " ").strip()
                            )
                    # TODO: Check this case for nlmchem dataset where assert is raised
                    # raise AssertionError()
                doc_id += 1

    @abstractmethod
    def _tag_documents(self):
        ...

    def _write_annotations(self):
        """Writes annotations to a file in the PubTator format
        required by the evaluation script."""
        with open(str(self.output_file), "w") as writer:
            print(f"Writing annotations to file {str(self.output_file)}")
            doc_id = 0
            for document_id in tqdm(self.documents.keys(), total=len(self.documents)):
                if "title" in self.documents[document_id]:
                    title = self.documents[document_id]["title"]
                    writer.write(f"{doc_id}|t|{title}\n")
                if "abstract" in self.documents[document_id]:
                    abstract = (
                        self.documents[document_id]["abstract"]
                        .replace("\n", " ")
                        .strip()
                    )
                    writer.write(f"{document_id}|a|{abstract}\n")
                if "fulltext" in self.documents[document_id]:
                    fulltext = (
                        self.documents[document_id]["fulltext"]
                        .replace("\n", " ")
                        .strip()
                    )
                    writer.write(f"{document_id}|f|{fulltext}\n")
                for entity in self.annotations[document_id]:
                    start = entity[0]
                    end = entity[1]
                    mention = entity[2]
                    entity_type = entity[3]
                    db_id = entity[4]
                    line_values = [
                        str(doc_id),
                        start,
                        end,
                        mention,
                        entity_type,
                        db_id,
                    ]
                    writer.write("\t".join(line_values) + "\n")
                doc_id += 1
