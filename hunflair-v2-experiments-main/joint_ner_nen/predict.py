#!/usr/bin/env python3
"""
Run BiomedicalEntityLinker on evaluation datasets with NER annotations from HunFlair
"""
import argparse
import os
import time

import faiss
from bioc import pubtator
from flair.models.biomedical_entity_linking import BiomedicalEntityLinker


def parse_args():
    """Script"""

    parser = argparse.ArgumentParser(
        "Run BiomedicalEntityLinker on HunFlair NER predictions"
    )
    parser.add_argument(
        "--dir",
        type=str,
        required=True,
        help="Directory with all annotations",
    )
    parser.add_argument(
        "--ner",
        type=str,
        default="hunflair-transformers-aio",
        help="NER model (name of directory)",
    )
    parser.add_argument(
        "--batch_size",
        type=int,
        default=1000,
        help="Entity mentions to tag simultaneously",
    )
    return parser.parse_args()


def chunkize(sequence: list, n: int):
    """Split list into N chunks"""
    for i in range(0, len(sequence), n):
        yield sequence[i : i + n]


def load_documents(path: str):
    """
    Load annotation from documents in PubTator format.
    Filter by entity type
    """

    documents = {}
    with open(path) as fp:
        for line in fp:
            if "|t|" in line:
                did, title = line.strip().split("|t|", maxsplit=1)
                if did not in documents:
                    documents[did] = pubtator.PubTator(pmid=did, title=title)
            elif "|a|" in line:
                did, abstract = line.strip().split("|a|", maxsplit=1)
                documents[did].abstract = abstract
            else:
                did, start, end, text, et = line.strip().split("\t")

                a = pubtator.PubTatorAnn(
                    start=start, end=end, pmid=did, text=text, type=et, id=-1
                )
                documents[did].add_annotation(a)

    return documents


def main():
    """Script"""

    args = parse_args()

    # https://github.com/facebookresearch/faiss/issues/53#issuecomment-288351188
    # multi-thrading is SIGNIFICANTLY slower for batched queries
    # In [14]: faiss.omp_set_num_threads(1)
    # In [15]: t0 = time.time(); index.search(X[:20], 20); print time.time() - t0
    # 0.331252098083
    # In [22]: faiss.omp_set_num_threads(40)
    # In [23]: t0 = time.time(); index.search(X[:20], 20); print time.time() - t0
    # 5.00787210464
    faiss.omp_set_num_threads(1)

    ENTITY_TYPE_TO_CORPORA = {
        "disease": ["craft", "medmentions"],
        "species": ["craft", "bioid"],
        "gene": ["tmvar_v3"],
        "chemical": ["medmentions"],
    }

    CORPUS_TO_DOCUMENTS = {
        corpus: load_documents(path=os.path.join(args.dir, args.ner, f"{corpus}.txt"))
        for corpus in set(
            corpus
            for entity_type, corpora in ENTITY_TYPE_TO_CORPORA.items()
            for corpus in corpora
        )
    }

    for entity_type, corpora in ENTITY_TYPE_TO_CORPORA.items():

        print(f"Prediction for entity type: `{entity_type}`")

        linker = BiomedicalEntityLinker.load(
            model_name_or_path=entity_type, entity_type=entity_type
        )

        for corpus in corpora:

            if corpus not in CORPUS_TO_DOCUMENTS:
                continue

            documents = CORPUS_TO_DOCUMENTS[corpus]

            entity_mentions = [
                a
                for pmid, document in documents.items()
                for a in document.annotations
                if a.type.lower() == entity_type.lower()
            ]

            print(
                f"Start tagging {len(entity_mentions)} entity mentions in corpus `{corpus}` with batch size {args.batch_size}"
            )

            start = time.time()

            for chunk in chunkize(entity_mentions, args.batch_size):

                chunk_candidates = linker.candidate_generator.search(
                    entity_mentions=[a.text for a in chunk], top_k=1
                )

                assert len(chunk) == len(
                    chunk_candidates
                ), f"# of entity mentions ({len(chunk)}) != # of search results ({len(chunk_candidates)})!"

                for a, mention_candidates in zip(chunk, chunk_candidates):

                    top_candidate = mention_candidates[0]

                    a.id = top_candidate.concept_id

            print(
                f"Tagging {len(entity_mentions)} entity mentions took ~{round(time.time() - start, 2)} seconds"
            )

    for corpus, documents in CORPUS_TO_DOCUMENTS.items():
        path = os.path.join(args.dir, args.ner, f"{corpus}_ner_nen.txt")
        print(f"Save tagged corpus `{corpus}` to: `{path}`")
        with open(path, "w") as fp:
            pubtator.dump(documents.values(), fp)


if __name__ == "__main__":
    main()
