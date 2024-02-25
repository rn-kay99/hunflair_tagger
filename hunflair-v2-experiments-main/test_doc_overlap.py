import argparse
import copy
import os
import re
from collections import Counter
from pathlib import Path

import flair.datasets.biomedical
from torch.utils.data import ConcatDataset, Subset

import train_ner_gs_model


class OverlapTest:
    counter = 0
    mapping = {}

    def __init__(self):
        ...

    def file_to_sentences(cls, path):
        f = open(path, "r")
        sentences = []
        sentence = []
        # Simple state machine to skip the task prompt for multi-task learning
        # Sample prompts: [Tag genes] ..., [Tag diseases and genes] ...,
        if flair.datasets.biomedical.MULTI_TASK_LEARNING:
            continue_reading = 0
        else:
            continue_reading = 2
        for line in f:
            line = line.strip()
            if line == "-DOCSTART- X X O":
                continue
            elif not line and continue_reading == 2:
                sentences += ["".join(sentence).replace(" ", "")]
                sentence = []
                if flair.datasets.biomedical.MULTI_TASK_LEARNING:
                    continue_reading = 0
            else:
                token = line.split()[0]
                if token == "[" and continue_reading == 0:
                    continue_reading = 1
                elif token == "]" and continue_reading == 1:
                    continue_reading = 2
                elif continue_reading == 2:
                    sentence += line.split()[0]
        return sentences

    def get_class_name(cls, entity_type, dataset):
        return f"huner_{entity_type}_{dataset}"

    def expand_to_paths(cls, base_path, dataset_list):
        paths = []
        for dataset in dataset_list:
            directory = os.path.join(base_path, dataset)
            if not os.path.exists(directory):
                print(f"Directory {directory} does not exist")
                continue
            for conll_file in Path(directory).glob("*.conll"):
                paths.append(tuple([conll_file, dataset]))
        return paths

    def get_split(cls, string):
        if "train" in string:
            return "train"
        elif "test" in string:
            return "test"
        elif "dev" in string:
            return "dev"
        else:
            raise ValueError

    def overlap_conll_files(cls, train_files, test_files):
        mapping = {}
        for train_path in train_files:
            train_sentences = set(cls.file_to_sentences(train_path[0]))
            for test_path in test_files:
                test_sentences = set(cls.file_to_sentences(test_path[0]))
                intersect = train_sentences & test_sentences
                intersect = set(
                    [sentence for sentence in intersect if len(sentence) > 12]
                )
                mapping.setdefault((train_path[1], test_path[1]), set()).update(
                    intersect
                )
        return mapping

    def overlap_torch_classes(
        cls,
        test_corpora,
        train_corpora=None,
        entity_type="gene",
        base_path=None,
    ):
        type_map = {
            "gene": train_ner_gs_model.GENE_DATASETS,
            "disease": train_ner_gs_model.DISEASE_DATASETS,
            "chemical": train_ner_gs_model.CHEMICAL_DATASETS,
            "cellline": train_ner_gs_model.CELLLINE_DATASETS,
            "species": train_ner_gs_model.SPECIES_DATASETS,
        }
        dataset_classes = dict(type_map[entity_type])
        test_corpora = [
            cls.get_class_name(entity_type, test).upper() for test in test_corpora
        ]
        if train_corpora is not None:
            train_corpora = [
                cls.get_class_name(entity_type, train).upper()
                for train in train_corpora
            ]
        else:
            train_corpora = list(dataset_classes.keys())

        test_corpora = [
            dataset_classes[test](base_path=base_path) for test in test_corpora
        ]
        train_corpora = [
            dataset_classes[train](base_path=base_path) for train in train_corpora
        ]

        return cls.remove_corpora_overlap(
            test_corpora, train_corpora, entity_type, base_path
        )

    def remove_corpora_overlap(
        cls, test_corpora, train_corpora, entity_type, base_path
    ):
        cls.counter = 0
        cls.mapping = {}

        # Remove prefix from class names, e.g., huner_gene_bio_infer to bio_infer
        train_files = [corpus.__class__.__name__.lower() for corpus in train_corpora]
        test_files = [corpus.__class__.__name__.lower() for corpus in test_corpora]
        train_files = cls.expand_to_paths(base_path, train_files)
        test_files = cls.expand_to_paths(base_path, test_files)
        duplicates = cls.overlap_conll_files(train_files, test_files)
        cls.mapping = dict.fromkeys(
            set(
                [
                    duplicate
                    for duplicate_set in duplicates.values()
                    for duplicate in duplicate_set
                ]
            ),
            0,
        )
        for key, value in duplicates.items():
            print(f"{key[0]} {key[1]}: Detected {len(value)} duplicates")
        duplicates_number = sum([len(value) for value in duplicates.values()])
        duplicate_corpora = set(
            [key[0] for key, value in duplicates.items() if len(value) > 0]
        )
        new_train_corpora = []
        for train_corpus in train_corpora:
            # Remove prefix from class names, e.g., huner_gene_bio_infer to bio_infer
            corpus_name = train_corpus.__class__.__name__.lower()
            # corpus_name = train_corpus.__class__.__name__.lower().split(
            #     "_",
            #     train_ner_gs_model.get_split_number(
            #         train_corpus.__class__.__name__.lower()
            #     ),
            # )[-1]
            if corpus_name not in duplicate_corpora:
                new_train_corpora.append(train_corpus)
            else:
                new_train_corpus = cls.remove_corpus_overlap(train_corpus, duplicates)
                if new_train_corpora is not None:
                    new_train_corpora.append(new_train_corpus)
        print(f"All: Detected {duplicates_number} duplicates")
        print(f"All: Removed {cls.counter} duplicates")
        # assert duplicates_number <= cls.counter
        # Duplicates are a set, so counter can be larger than duplicates_number
        return new_train_corpora

    def remove_corpus_overlap(cls, train_corpus, duplicates):
        data_splits = ["_train", "_test", "_dev"]
        duplicates = {
            key: value
            for key, value in duplicates.items()
            if key[0] in train_corpus.__class__.__name__.lower()
        }
        for train_split, train_class in train_corpus.__dict__.items():
            if train_split not in data_splits:
                continue
            # Make sure that dataset is of type torch.utils.data.dataset.Subset
            if not isinstance(train_class, Subset):
                indices = [i for i in range(len(train_class))]
                train_class = Subset(train_class, indices)
            keep_indices = cls.remove_split_overlap(train_class, duplicates)
            train_class.indices = keep_indices
            train_corpus.__dict__[
                train_split
            ] = train_class  # You need to explicitly assign the new value to the dict
            # Needed if we made a new Subset
        return train_corpus

    def remove_split_overlap(cls, train_class, duplicates):
        duplicate_texts = set(
            [
                duplicate
                for duplicate_list in duplicates.values()
                for duplicate in duplicate_list
            ]
        )
        sentences = []
        keep_indices = []
        for i, train_sentence_dict in enumerate(train_class):
            text = "".join(
                [token.text for token in train_sentence_dict.tokens]
            ).replace(" ", "")
            # Simple state machine to skip the task prompt for multi-task learning
            # Sample prompts: [Tag genes] ..., [Tag diseases and genes] ...,
            if flair.datasets.biomedical.MULTI_TASK_LEARNING:
                match = re.search(r"\[.*\]", text)
                offset = match.end()
                text = text[offset:]
            if text not in duplicate_texts:
                sentences.append(train_sentence_dict)
                keep_indices.append(i)
            else:
                cls.counter += 1
                cls.mapping[text] += 1
        return keep_indices


if __name__ == "__main__":
    from flair.datasets import biomedical

    parser = argparse.ArgumentParser()
    parser.add_argument("--base_path", type=str)
    parser.add_argument("--entity_type", type=str)
    parser.add_argument("--trainfiles", nargs="+")
    parser.add_argument("--testfiles", nargs="+")
    args = parser.parse_args()

    # python test_doc_overlap.py --base_path /home/tmp/hunflair --entity_type gene --trainfiles gnormplus bioid
    # --testfiles nlm_gene fsu progene bio_infer jnlpba mirna cell_finder loctext iepa variome osiris
    # deca craft_v4 chebi gpro drugprot cpi bionlp_st_2013_pc bionlp_st_2013_ge bionlp2013_cg bionlp_st_2011_ge
    # bionlp_st_2011_id bionlp_st_2011_rel bionlp_st_2011_epi

    print("base path", args.base_path)
    print("train files", args.trainfiles)
    print("test files", args.testfiles)

    flair.datasets.biomedical.MULTI_TASK_LEARNING = True

    train_corpora = [
        getattr(biomedical, train_file.upper())(base_path=args.base_path)
        for train_file in args.trainfiles
    ]
    test_corpora = [
        getattr(biomedical, test_file.upper())(base_path=args.base_path)
        for test_file in args.testfiles
    ]

    overlap_test = OverlapTest()
    corpora = overlap_test.remove_corpora_overlap(
        test_corpora, train_corpora, args.entity_type, args.base_path
    )
