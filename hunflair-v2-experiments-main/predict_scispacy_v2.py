import argparse
import os
import spacy

from pathlib import Path
from spacy.language import Language
from typing import Dict
from tqdm import tqdm

from predict import Predictor

TYPE_MAPPINGS = {
    "en_ner_bionlp13cg_md": {
        "gene_or_gene_product": "gene",
        "organism": "species",
        "cancer": "disease",
        "simple_chemical": "chemical",
        "amino_acid": "chemical",
    },
    "en_ner_bc5cdr_md": {"chemical": "chemical", "disease": "disease"},
    "en_ner_jnlpba_md": {
        "rna": "gene",
        "dna": "gene",
        "protein": "gene",
        "cell_line": "cell_line",
    },
    "en_ner_craft_md": {
        "chebi": "chemical",
        "ggp": "gene",
        "taxon": "species",
    },
}

DATASETS = ["bc5cdr", "bioid", "craft", "bionlp_st_2013_cg", "pdr", "tmvar_v3"]
MODELS = ["en_ner_bionlp13cg_md", "en_ner_bc5cdr_md", "en_ner_jnlpba_md", "en_ner_craft_md"]


class SciSpacyPredictor(Predictor):
    def __init__(
        self, data_set: str, model: Language, type_mapping: Dict, output_file: Path, test_only: bool
    ):
        self.model = model
        self.type_mapping = type_mapping
        super().__init__(data_set, output_file, test_only)

    def _tag_documents(self):
        print("Tagging documents")
        for document_id in tqdm(self.documents.keys(), total=len(self.documents)):
            text = self.documents[document_id]["title"]
            if "abstract" in self.documents[document_id]:
                text += " "
                text += self.documents[document_id]["abstract"]
            spacy_doc = self.model(text)

            for entity in spacy_doc.ents:
                entity_type = entity.label_.lower()
                if entity_type not in self.type_mapping:
                    # print(entity_type)
                    continue

                # Sometimes scispacy includes whitespaces  at the end of the predictions
                # we benevolently ignore this whitespaces
                if not entity.text.endswith(" "):
                    self.annotations[document_id] += [
                        (
                            str(entity.start_char),
                            str(entity.end_char),
                            entity.text,
                            self.type_mapping[entity_type],
                            "-1",
                        )
                    ]
                else:
                    pos_last_ws = -1
                    while entity.text[pos_last_ws] == " ":
                        pos_last_ws -= 1

                    self.annotations[document_id] += [
                        (
                            str(entity.start_char),
                            str(entity.end_char+pos_last_ws),
                            entity.text[:pos_last_ws],
                            self.type_mapping[entity_type],
                            "-1",
                        )
                    ]


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--models",
        nargs="*",
        required=False,
        default=MODELS,
        help="Models used for prediction (by default all)",
    )
    parser.add_argument(
        "--data_sets",
        nargs="*",
        required=False,
        default=DATASETS,
        help="Data sets to be used (by default all)",
    )
    parser.add_argument(
        "--output_dir",
        type=Path,
        required=False,
        default=Path("output_annotations"),
        help="Path to the output directory",
    )
    args = parser.parse_args()

    for model in args.models:
        spacy_model = spacy.load(model)
        for dataset in args.data_sets:
            output_file = Path(f"output_annotations/scispacy_{model}/{dataset}.tsv")
            os.makedirs(str(output_file.parent), exist_ok=True)

            type_mapping = TYPE_MAPPINGS[model]
            test_only = dataset in ["bc5cdr", "bionlp_st_2013_cg"]

            SciSpacyPredictor(dataset, spacy_model, type_mapping, output_file, test_only)
