import argparse
import matplotlib.pyplot as plt

from pathlib import Path
from typing import Callable, Tuple, List, Optional

from evaluate_annotation import copy_dict, partial_match_fixed
from utils import read_documents_from_pubtator
from venn import get_labels, venn3, venn4, venn2, venn5, venn6


def get_venn_func(num_tools: int ) -> Callable:
    if num_tools == 2:
        return venn2
    elif num_tools == 3:
        return venn3
    elif num_tools == 4:
        return venn4
    elif num_tools == 5:
        return venn5
    elif num_tools == 6:
        return venn6

    raise NotImplementedError()


def compute_tps_fps_fns(
    gold_file: Path,
    pred_file: Path,
    match_func: Callable[[Tuple, List], Optional[Tuple]],
    ignore_normalization_ids: bool = True,
    entity_type: Optional[str] = None
) -> Tuple[List, List, List]:

    gold_documents = read_documents_from_pubtator(gold_file)
    gold_annotations = {
        doc.id: [ann for ann in doc.annotations if not entity_type or ann[4] == entity_type]
        for doc in gold_documents
    }

    pred_documents = read_documents_from_pubtator(pred_file)
    pred_annotations = {
        doc.id: [ann for ann in doc.annotations if not entity_type or ann[4] == entity_type]
        for doc in pred_documents
    }

    tps = []
    fps = []
    fns = []

    copy_gold = copy_dict(gold_annotations, ignore_normalization_ids)
    for document_id, annotations in pred_annotations.items():
        for pred_entry in annotations:
            if ignore_normalization_ids:
                pred_entry = tuple(
                    [v for i, v in enumerate(pred_entry) if i < len(pred_entry) - 1]
                )
            # Documents may not contain any gold entity!
            if document_id in copy_gold:
                matched_gold = match_func(pred_entry, copy_gold[document_id])
            else:
                matched_gold = None

            if matched_gold:
                # Assert same document and same entity type!
                # assert (
                #     matched_gold[0] == pred_entry[0]
                #     and matched_gold[4] == pred_entry[4]
                # )

                copy_gold[document_id].remove(matched_gold)
                #metric.add_tp(pred_entry[4])
                tps.append(matched_gold)

            else:
                fps.append(pred_entry)
                #metric.add_fp(pred_entry[4])

    copy_pred = copy_dict(pred_annotations, ignore_normalization_ids)

    for document_id, annotations in gold_annotations.items():
        for gold_entry in annotations:
            if ignore_normalization_ids:
                gold_entry = tuple(
                    [v for i, v in enumerate(gold_entry) if i < len(gold_entry) - 1]
                )
            if document_id in copy_pred:
                matched_pred = match_func(gold_entry, copy_pred[document_id])
            else:
                matched_pred = None

            if not matched_pred:
                fns.append(gold_entry)
            else:
                # Assert same document and same entity type!
                # assert (
                #     matched_pred[0] == gold_entry[0]
                #     and matched_pred[4] == gold_entry[4]
                # )
                copy_pred[document_id].remove(matched_pred)

    return tps, fps, fns


def compute_overlaps(
        gold_file: Path,
        prediction_files: List[Path],
        output_file: Path,
        target: str,
        entity_type: Optional[str] = None
):
    all_tps = []
    all_fps = []
    all_fns = []
    names = []

    for pred_file in prediction_files:
        tps, fps, fns = compute_tps_fps_fns(gold_file, pred_file, partial_match_fixed(1), entity_type=entity_type)
        all_tps.append(tps)
        all_fps.append(fps)
        all_fns.append(fns)

        names.append(pred_file.parent.name)

    if target == "tp":
        venn_func = get_venn_func(len(all_tps))
        labels = get_labels(all_tps, fill=["number", "percent"])
    elif target == "fn":
        venn_func = get_venn_func(len(all_fns))
        labels = get_labels(all_fns, fill=["number", "percent"])
    else:
        raise NotImplementedError()

    fig, ax = venn_func(labels, names)
    fig.suptitle(gold_file.name, x=.5, y=.85, fontsize=16, fontweight="bold")
    fig.savefig(str(output_file))
    plt.clf()


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--gold_file", type=Path, required=True)
    parser.add_argument("--pred_files", type=Path, required=True, nargs="+")
    parser.add_argument("--output_file", type=Path, required=True)
    parser.add_argument("--target", type=str, choices=["tp", "fn"], required=True)
    parser.add_argument("--entity_type", type=str, required=False, default=None)
    args = parser.parse_args()

    compute_overlaps(
        gold_file=args.gold_file,
        prediction_files=args.pred_files,
        output_file=args.output_file,
        target=args.target,
        entity_type=args.entity_type
    )

    # compute_overlaps(
    #     gold_file=Path("annotations/goldstandard/bc5cdr.txt"),
    #     prediction_files=[
    #         Path("annotations/pubtator/bc5cdr.txt"),
    #         Path("annotations/bern/bc5cdr_bern_results.txt"),
    #         Path("annotations/hunflair-transformers-aio/bc5cdr.txt"),
    #         Path("annotations/hunflair-paper/bc5cdr.txt")
    #     ],
    #     output_file=Path("output.png"),
    #     entity_type=None
    # )
