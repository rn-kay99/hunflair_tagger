import argparse
import inspect
import os
import random
from operator import itemgetter
from pathlib import Path
from typing import List, Optional, Union

import flair.datasets.biomedical
import numpy as np
import torch
from flair.data import MultiCorpus
from flair.datasets import biomedical
from flair.datasets.biomedical import BIGBIO_NER_CORPUS, GENETIC_VARIANT_NER_CORPUS, FINE_GRAINED_GENETIC_VARIANT_NER_CORPUS
from flair.datasets.sequence_labeling import ColumnCorpus
from flair.embeddings import (
    CharacterEmbeddings,
    FlairEmbeddings,
    PooledFlairEmbeddings,
    StackedEmbeddings,
    TokenEmbeddings,
    TransformerWordEmbeddings,
    WordEmbeddings,
)
from flair.models import SequenceTagger
from flair.trainers import ModelTrainer
from torch.utils.data import ConcatDataset

from SequenceTaggerAIONER import SequenceTaggerAIONER


def cellline_predicate(member):
    # Some links are down and filtered out here
    return "HUNER_CELL_LINE_" in str(member) and inspect.isclass(member)


def gene_predicate(member):
    return "HUNER_GENE_" in str(member) and inspect.isclass(member)


def chemical_predicate(member):
    return "HUNER_CHEMICAL_" in str(member) and inspect.isclass(member)


def disease_predicate(member):
    return "HUNER_DISEASE_" in str(member) and inspect.isclass(member)


def species_predicate(member):
    return "HUNER_SPECIES_" in str(member) and inspect.isclass(member)


def all_predicate(member):
    return "HUNER_ALL_" in str(member) and inspect.isclass(member)


CELLLINE_DATASETS = sorted(
    inspect.getmembers(biomedical, predicate=cellline_predicate), key=itemgetter(0)
)
CHEMICAL_DATASETS = sorted(
    inspect.getmembers(biomedical, predicate=chemical_predicate), key=itemgetter(0)
)
DISEASE_DATASETS = sorted(
    inspect.getmembers(biomedical, predicate=disease_predicate), key=itemgetter(0)
)
GENE_DATASETS = sorted(
    inspect.getmembers(biomedical, predicate=gene_predicate), key=itemgetter(0)
)
SPECIES_DATASETS = sorted(
    inspect.getmembers(biomedical, predicate=species_predicate), key=itemgetter(0)
)
ALL_DATASETS = sorted(
    inspect.getmembers(biomedical, predicate=all_predicate), key=itemgetter(0)
)


def train_on_dataset(
    corpus: Union[biomedical.HunerDataset, MultiCorpus],
    results_path: str,
    batch_size: int = 32,
    max_epochs: int = 16,
    train_with_test: bool = False,
    transformer_word_embedding: str = "",
    model_checkpoint: str = "",
    transformer_stacked: bool = False,
    learning_rate: float = 5.0e-6,
    checkpoint: bool = False,
    aioner: bool = False,
    transformers_use_crf: bool = False,
    single: bool = False,
):
    tag_dictionary = corpus.make_label_dictionary(label_type="ner")

    if transformer_word_embedding == "":
        embedding_types: List[TokenEmbeddings] = [
            WordEmbeddings("pubmed"),
            FlairEmbeddings("pubmed-forward"),
            FlairEmbeddings("pubmed-backward"),
        ]

        embeddings: StackedEmbeddings = StackedEmbeddings(embeddings=embedding_types)

        tagger: SequenceTagger = SequenceTagger(
            hidden_size=256,
            embeddings=embeddings,
            tag_dictionary=tag_dictionary,
            tag_format="BIO",
            tag_type="ner",
            use_crf=True,
            locked_dropout=0.5,
        )

        trainer: ModelTrainer = ModelTrainer(tagger, corpus)
        base_path = os.path.join(results_path, corpus.name.lower())

        trainer.train(
            base_path=base_path,
            train_with_dev=False,
            train_with_test=train_with_test,
            max_epochs=200,
            learning_rate=0.1,
            mini_batch_size=batch_size,
            embeddings_storage_mode="none",
            # checkpoint=checkpoint,
        )

    elif transformer_word_embedding != "" and transformer_stacked:
        import torch
        from torch.optim.lr_scheduler import OneCycleLR

        embedding_types: List[TokenEmbeddings] = [
            FlairEmbeddings("pubmed-forward"),
            FlairEmbeddings("pubmed-backward"),
            TransformerWordEmbeddings(
                layers="-1",
                subtoken_pooling="first",
                fine_tune=True,
                use_context=True,
                model_max_length=512,
            ),
        ]

        embeddings: StackedEmbeddings = StackedEmbeddings(embeddings=embedding_types)

        tagger: SequenceTagger = SequenceTagger(
            hidden_size=256,
            embeddings=embeddings,
            tag_dictionary=tag_dictionary,
            tag_format="BIO",
            tag_type="ner",
            use_crf=False,
            use_rnn=False,
            reproject_embeddings=False,
        )

        trainer: ModelTrainer = ModelTrainer(tagger, corpus)
        base_path = os.path.join(results_path, corpus.name.lower())

        trainer.train(
            base_path=base_path,
            train_with_dev=False,
            train_with_test=train_with_test,
            max_epochs=max_epochs,
            scheduler=OneCycleLR,
            learning_rate=learning_rate,
            mini_batch_size=batch_size,
            embeddings_storage_mode="none",
            optimizer=torch.optim.AdamW,
            checkpoint=checkpoint,
        )

    else:
        # try:

        embeddings: TransformerWordEmbeddings = TransformerWordEmbeddings(
            transformer_word_embedding,
            layers="-1",
            subtoken_pooling="first",
            fine_tune=True,
            use_context=True,
            model_max_length=512,
        )
        # except:
        #     embeddings: TransformerWordEmbeddings = TransformerWordEmbeddings(
        #         Path(transformer_word_embedding),
        #         layers="-1",
        #         subtoken_pooling="first",
        #         fine_tune=True,
        #         use_context=True,
        #         model_max_length=512,
        #     )

        if aioner:
            tagger: SequenceTagger = SequenceTaggerAIONER(
                hidden_size=256,
                embeddings=embeddings,
                tag_dictionary=tag_dictionary,
                tag_format="BIO",
                tag_type="ner",
                use_crf=transformers_use_crf,
                use_rnn=False,
                reproject_embeddings=False,
            )
        else:
            tagger = SequenceTagger(
                hidden_size=256,
                embeddings=embeddings,
                tag_dictionary=tag_dictionary,
                tag_format="BIO",
                tag_type="ner",
                use_crf=transformers_use_crf,
                use_rnn=False,
                reproject_embeddings=False,
            )

        trainer: ModelTrainer = ModelTrainer(tagger, corpus)
        # Load pre-trained checkpoint
        if model_checkpoint:
            trainer.model = SequenceTagger.load(
                os.path.join(model_checkpoint, "best-model.pt")
            )

        if single:
            base_path = os.path.join(results_path)
        else:
            base_path = os.path.join(results_path, corpus.name.lower())

        # Debug training
        main_evaluation_metric = ("micro avg", "f1-score")
        embeddings_storage_mode = "cpu"
        gold_label_dictionary_for_eval = None
        exclude_labels = []

        dev_eval_result = trainer.model.evaluate(
            trainer.corpus.dev,
            gold_label_type=trainer.model.label_type,
            embedding_storage_mode=embeddings_storage_mode,
            main_evaluation_metric=main_evaluation_metric,
            gold_label_dictionary=gold_label_dictionary_for_eval,
            exclude_labels=exclude_labels,
        )
        # result_line += f"\t{dev_eval_result.loss}\t{dev_eval_result.log_line}"
        import logging

        logger = logging.getLogger("flair")
        logger.info(
            f"DEV : loss {dev_eval_result.loss}"
            f" - {main_evaluation_metric[1]}"
            f" ({main_evaluation_metric[0]})"
            f"  {round(dev_eval_result.main_score, 4)}"
        )

        trainer.fine_tune(
            base_path=base_path,
            train_with_dev=False,
            train_with_test=train_with_test,
            learning_rate=learning_rate,
            mini_batch_size=batch_size,
            # checkpoint=checkpoint,
            max_epochs=max_epochs,
            use_final_model_for_eval=False,
        )


def is_deprecated(corpus: str, ignored_corpora: List[str]) -> bool:
    # FSU is revised by ProGene and BC2GM is revised by GNormPlus
    if corpus.endswith("FSU") and "progene" not in ignored_corpora:
        return True
    elif corpus.endswith("BC2GM") and "gnormplus" not in ignored_corpora:
        return True
    else:
        return False


def get_split_number(corpus_name: str) -> int:
    if "cell_line" in corpus_name.lower():
        return 3
    else:
        return 2


if __name__ == "__main__":
    from test_doc_overlap import OverlapTest
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--type",
        required=True,
        choices=[
            "all",
            "mtl",
            "cell_line",
            "chemical",
            "disease",
            "gene",
            "species",
            "single",
            "variation",
            "fine_grained_variation",
        ],
    )
    parser.add_argument("--path", required=True)
    parser.add_argument(
        "--train_corpora",
        nargs="*",
        default=[],
        help="Corpora to train on. Standard are all HunFlair datasets. Only use if you want to train on a subset of the corpora. Use either this or --train_corpora_exclude.",
    )
    parser.add_argument(
        "--train_corpora_exclude",
        nargs="*",
        default=[],
        help="Corpora to not train on. Standard are all HunFlair datasets. Only use if you want to train on a subset of the corpora. Use either this or --train_corpora.",
    )
    # Evaluation corpora (Default are the ones used in HunFlair 2.0)
    parser.add_argument(
        "--test_corpora",
        nargs="*",
        default=["bioid", "tmvar_v3", "cdr", "bionlp2013_cg", "craft_v4", "pdr"],
    )
    parser.add_argument("--train_with_test", action="store_true", default=False)
    parser.add_argument("--data_path", default=None)
    parser.add_argument("--transformer_word_embedding", default="")
    parser.add_argument("--model_checkpoint", default="")
    parser.add_argument("--transformer_stacked", action="store_true")
    parser.add_argument("--checkpoint", action="store_true")
    parser.add_argument("--batch_size", type=int, default=32)
    parser.add_argument("--max_epochs", type=int, default=16)
    parser.add_argument("--learning_rate", default=5.0e-6)
    parser.add_argument("--multi_task_learning", action="store_true")
    parser.add_argument(
        "--aioner",
        action="store_true",
        help="Use AIONER annotation style for multi-task learning, i.e., O-<entity_type> instead of only O tags.",
    )
    parser.add_argument(
        "--aioner_remove_duplicates",
        action="store_true",
        help="Remove single entity type AIONER datasets if already present in the multi-entity type versions of the AIONER datasets.",
        default=True,
    )
    parser.add_argument(
        "--transformers_use_crf",
        action="store_true",
        help="Use CRF instead of softmax for AIONER",
    )
    parser.add_argument(
        "--strict_overlap",
        action="store_true",
        help="For overlap testing of train and test sets cross corpus, also compare with corpora of other entity types",
        default=True,
    )
    parser.add_argument(
        "--ignore_negative_samples",
        action="store_true",
        help="Ignore sentences without any I or B tags.",
    )
    parser.add_argument(
        "--seed", default=1, type=int, help="random seed for initialization"
    )

    args = parser.parse_args()

    # Set seed
    torch.manual_seed(args.seed)
    # torch.cuda.manual_seed(args.seed)
    torch.cuda.manual_seed_all(args.seed)
    np.random.seed(args.seed)
    random.seed(args.seed)
    

    if args.type == "single":
        if len(args.train_corpora) != 1:
            raise NotImplementedError()

        train_corpus = args.train_corpora[0]
        corpus = BIGBIO_NER_CORPUS(train_corpus)
    elif args.type == "variation":
        if len(args.train_corpora) != 1:
            raise NotImplementedError()

        train_corpus = args.train_corpora[0]
        corpus = GENETIC_VARIANT_NER_CORPUS(train_corpus)
    elif args.type == "fine_grained_variation":
        if len(args.train_corpora) != 1:
            raise NotImplementedError()

        dataset_name = args.train_corpora[0]
        test_corpus = args.test_corpora[0]
        corpus = FINE_GRAINED_GENETIC_VARIANT_NER_CORPUS(dataset_name,args.data_path)
        
    else:
        if args.type == "all":
            datasets = ALL_DATASETS
            other_datasets = (
                CELLLINE_DATASETS
                + CHEMICAL_DATASETS
                + DISEASE_DATASETS
                + GENE_DATASETS
                + SPECIES_DATASETS
            )
            datasets_names = [
                d[0].lower().split("_", get_split_number(d[0]))[-1] for d in datasets
            ]
            for dataset in other_datasets:
                dataset_name = (
                    dataset[0].lower().split("_", get_split_number(dataset[0]))[-1]
                )
                if dataset_name not in datasets_names:
                    datasets.append(dataset)
                    datasets_names.append(dataset_name)
            # datasets = [
            #     ("HUNER_ALL_BIORED", biomedical.HUNER_ALL_BIORED),
            #     ("HUNER_GENE_TMVAR_V3", biomedical.HUNER_GENE_TMVAR_V3),
            # ]
        elif args.type == "mtl":
            datasets = (
                CELLLINE_DATASETS
                + CHEMICAL_DATASETS
                + DISEASE_DATASETS
                + GENE_DATASETS
                + SPECIES_DATASETS
            )
            if args.aioner:
                datasets += [("HUNER_ALL_BIORED", biomedical.HUNER_ALL_BIORED)]
                if args.aioner_remove_duplicates:
                    datasets.remove(("HUNER_GENE_BIORED", biomedical.HUNER_GENE_BIORED))
                    datasets.remove(
                        ("HUNER_CHEMICAL_BIORED", biomedical.HUNER_CHEMICAL_BIORED)
                    )
                    datasets.remove(
                        ("HUNER_DISEASE_BIORED", biomedical.HUNER_DISEASE_BIORED)
                    )
                    datasets.remove(
                        ("HUNER_CELL_LINE_BIORED", biomedical.HUNER_CELL_LINE_BIORED)
                    )
                    datasets.remove(
                        ("HUNER_SPECIES_BIORED", biomedical.HUNER_SPECIES_BIORED)
                    )
        elif args.type == "cell_line":
            datasets = CELLLINE_DATASETS
        elif args.type == "chemical":
            datasets = CHEMICAL_DATASETS
            # if args.bc5cdr_train:
            #     datasets.append(("HUNER_CHEMICAL_CDR", biomedical.HUNER_CHEMICAL_CDR))
        elif args.type == "disease":
            datasets = DISEASE_DATASETS
            # if args.bc5cdr_train:
            #     datasets.append(("HUNER_DISEASE_CDR", biomedical.HUNER_DISEASE_CDR))
        elif args.type == "gene":
            datasets = GENE_DATASETS
        elif args.type == "species":
            datasets = SPECIES_DATASETS
        else:
            raise ValueError

        # Set MULTI_TASK_LEARNING in biomedical.py
        if args.multi_task_learning:
            flair.datasets.biomedical.MULTI_TASK_LEARNING = True
        # if args.aioner:
        #     AIONER = True
        if args.ignore_negative_samples:
            flair.datasets.biomedical.IGNORE_NEGATIVE_SAMPLES = True

        test_corpora_strings = [i.lower() for i in args.test_corpora]
        # test_corpora.extend(["bioid", "bionlp2013_cg", "craft_v4", "pdr"])
        # test_corpora.extend(["bioid", "cdr", "bionlp2013_cg", "craft_v4", "pdr"])
        train_corpora = [i.lower() for i in args.train_corpora]
        train_corpora_exclude = [i.lower() for i in args.train_corpora_exclude]

        if args.strict_overlap:
            overlap_test_datasets = (
                CELLLINE_DATASETS
                + CHEMICAL_DATASETS
                + DISEASE_DATASETS
                + GENE_DATASETS
                + SPECIES_DATASETS
            )
        else:
            overlap_test_datasets = datasets
        test_corpora = [
            i(base_path=args.data_path)
            for name, i in overlap_test_datasets
            if name.lower().split("_", get_split_number(name))[-1]
            in test_corpora_strings
            and name.lower().split("_", get_split_number(name))[-1]
            != "pdr"  # TODO: remove when PDR URL is fixed
        ]
        corpora = [
            i(base_path=args.data_path)
            for name, i in datasets
            if name.lower().split("_", get_split_number(name))[-1]
            not in test_corpora_strings
            and (
                train_corpora == []
                or name.lower().split("_", get_split_number(name))[-1] in train_corpora
            )
            and name.lower().split("_", get_split_number(name))[-1]
            not in train_corpora_exclude
            and not is_deprecated(name, train_corpora_exclude)
        ]

        # Learning rates to try
        # 4e-6, 1e-5, 2e-5, 3e-5, 1e-4
        corpus = MultiCorpus(corpora, name=args.type)

        print("Corpora stats before overlap removal:")
        print(corpus.obtain_statistics())

        overlap_test = OverlapTest()
        corpora = overlap_test.remove_corpora_overlap(
            test_corpora, corpora, args.type, args.data_path
        )

        print(f"Training on {[i.name for i in corpora]}")
        corpus = MultiCorpus(corpora, name=args.type)

        print("Corpora stats after overlap removal:")
        print(corpus.obtain_statistics())

    train_on_dataset(
        corpus,
        results_path=args.path,
        max_epochs=args.max_epochs,
        batch_size=int(args.batch_size),
        train_with_test=args.train_with_test,
        transformer_word_embedding=args.transformer_word_embedding,
        model_checkpoint=args.model_checkpoint,
        transformer_stacked=args.transformer_stacked,
        learning_rate=float(args.learning_rate),
        checkpoint=args.checkpoint,
        aioner=args.aioner,
        transformers_use_crf=args.transformers_use_crf,
        single=args.type == "single",
    )
