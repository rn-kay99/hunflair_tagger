import argparse
import os
import re
from pathlib import Path

from flair.data import Sentence
from flair.models import SequenceTagger
from flair.nn import Classifier
from flair.splitter import SciSpacySentenceSplitter
from flair.tokenization import SciSpacyTokenizer
from tqdm import tqdm

from predict import Predictor
from SequenceTaggerAIONER import SequenceTaggerAIONER


class HunFlairPredictor(Predictor):
    def __init__(
        self,
        data_set: str,
        model: str,
        output_file: Path,
        multi_task_learning: bool,
        entity_types: list,
        aioner: bool = False,
        test_only: bool = False,
        single: bool = False,
    ):
        if aioner:
            self.model = SequenceTaggerAIONER.load(model)
        elif single:
            self.model = SequenceTagger.load(model)
        else:
            self.model = Classifier.load(model)

        self.sentence_splitter = SciSpacySentenceSplitter()
        self.multi_task_learning = multi_task_learning
        self.entity_types = sorted(entity_types)
        self.aioner = aioner
        super().__init__(data_set, output_file, test_only)

    def _tag_documents(self):
        print("Tagging documents")

        # If multi-task learning is present, then add the task prompt
        offset = 0
        task_description = ""
        if self.multi_task_learning:
            task_description += "[Tag"
            for i, entity_type in enumerate(self.entity_types):
                if i == 0:
                    task_description += f" {entity_type}"
                elif i == len(self.entity_types) - 1:
                    task_description += f" and {entity_type}"
                else:
                    task_description += f", {entity_type}"
            task_description += "]"
            offset = len(task_description) + 1

        for document_id in tqdm(self.documents.keys(), total=len(self.documents)):
            if "title" in self.documents[document_id]:
                text = self.documents[document_id]["title"]
            if "abstract" in self.documents[document_id]:
                text += " "
                text += self.documents[document_id]["abstract"]
            if "fulltext" in self.documents[document_id]:
                text = self.documents[document_id]["fulltext"]

            sentences = self.sentence_splitter.split(text)
            for sentence in sentences:
                # If multi-task learning is present, then add the task prompt
                if self.multi_task_learning:
                    prompt_plus_text = task_description + " " + sentence.text
                    sentence = Sentence(
                        prompt_plus_text,
                        use_tokenizer=self.sentence_splitter.tokenizer,
                        start_position=sentence.start_position,
                    )
                self.model.predict(sentence)

                for annotation_layer in sentence.annotation_layers.keys():
                    for entity in sentence.get_spans(annotation_layer):
                        start_position = (
                            sentence.start_position + entity.start_position - offset
                        )
                        end_position = (
                            sentence.start_position + entity.end_position - offset
                        )
                        self.annotations[document_id] += [
                            (
                                str(start_position),
                                str(end_position),
                                entity.text,
                                entity.tag.lower(),
                                "",
                            )
                        ]


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_dataset", default="bionlp_st_2013_cg")
    parser.add_argument(
        "--model",
        # default="hunflair-gene",
        # default="/home/tmp/hunflair/gene_transformers_lr_1e-5/gene/final-model.pt",
        # default="/home/tmp/hunflair/disease_lstm/disease/best-model.pt",
        default="/home/tmp/hunflair/disease_transformers_lr_2e-5/disease/final-model.pt",
        # default="/home/tmp/hunflair/gene_lstm/gene/final-model.pt",
        # default="/home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt",
        # default="/home/tmp/hunflair/chemical_transformers_lr_2e-5/chemical/best-model.pt",
        # default="hunflair-paper-chemical",
        # default="/home/tmp/hunflair/aioner/mtl/best-model.pt",
    )
    parser.add_argument(
        "--output_file",
        # default="data/bionlp_st_2013_cg/hunflair_v2_disease_lstm.txt",
        default="data/bionlp_st_2013_cg/hunflair_v2_disease_transformers_lr_2e-5.txt",
        # default="data/bionlp_st_2013_cg/hunflair_v1_chemical_paper.txt",
        # default="data/bionlp_st_2013_cg/hunflair_v2_experiment_multi_task_learning_aioner_species.txt",
    )
    parser.add_argument("--multi_task_learning", action="store_true", default=False)
    parser.add_argument(
        "--entity_types",
        nargs="*",
        default=["diseases"],
    )
    parser.add_argument("--aioner", action="store_true", default=False)
    parser.add_argument("--predict_test_only", action="store_true", default=False)
    parser.add_argument("--single", action="store_true", default=False)
    args = parser.parse_args()

    output_file = Path(args.output_file)
    os.makedirs(str(output_file.parent), exist_ok=True)

    HunFlairPredictor(
        args.input_dataset,
        args.model,
        output_file,
        args.multi_task_learning,
        sorted(args.entity_types),
        args.aioner,
        args.predict_test_only,
        args.single,
    )
