"""
The code in this file is used to evaluate the predictions of the BiLSTM-CRF, BioLinkBERT and Fine-Grained-BioLinkBERT models.
Example call: python make_prediction.py --pred_file ../../test_my_modell_prediction/bilstm/osiris_7733/pred.txt --gold_file osiris/mod_osiris_test.txt > ../../test_my_modell_prediction/bilstm/osiris_7733/pred.log
The result includes precision, recall and F1 score.
"""
import argparse

pred_entities = []
gold_entities = []
annotations = []

def evaluate_with_duplicate(prediction, gold):
    prediction = [elem.strip() for elem in prediction]
    gold_copy = [elem.strip() for elem in gold]  # Kopie der Gold-Liste für Vergleich

    tp = 0
    fp = 0
    fn = 0

    for entity in prediction:
        if entity in gold_copy:
            tp += 1
            gold_copy.remove(entity)
        else:
            fp += 1

    fn += len(gold_copy)

    if len(prediction) > 0 or len(gold_copy) > 0:
        print("pred: ", prediction)
        print("gold: ", gold)
        print("tp: ", tp)
        print("fp: ", fp)
        print("fn: ", fn)
        print()

    return tp, fp, fn


def evaluate(prediction, gold):
    prediction = [elem.strip() for elem in prediction]
    gold = [elem.strip() for elem in gold]
    
    tp = len(set(prediction) & set(gold))
    fp = len(set(prediction) - set(gold))
    fn = len(set(gold) - set(prediction))

    if len(prediction) > 0 or len(gold) > 0:
        print("pred: ",prediction)
        print("gold: ",gold)
        print("tp: ", tp)
        print("fp: ", fp)
        print("fn: ", fn)
        print()
    return tp, fp, fn

def evaluate_all(predictions, golds):
    true_positive = 0
    false_positive = 0
    false_negative = 0

    for prediction, gold in zip(predictions, golds):
        tp, fp, fn = evaluate_with_duplicate(prediction, gold)
        true_positive += tp
        false_positive += fp
        false_negative += fn

    return true_positive, false_positive, false_negative

def process_line(line, type):
    global annotations
    fields = line.split('\t')
    
    if len(fields) == 1:
        if type == "pred":
            pred_entities.append(annotations)
        else:
            gold_entities.append(annotations)
        annotations = []

    if len(fields) == 6 and fields[3] != '':
        annotations.append(fields[3])
    

def main(pred_file, gold_file):
    global annotations

    with open(pred_file, 'r') as input_file:
        for line in input_file:
            # Überprüfen, ob die Zeile leer ist
            if not line.strip():
                continue
            # Verarbeite jede Zeile und schreibe in die Ausgabedatei
            process_line(line, "pred")
        if len(annotations) > 0:
            pred_entities.append(annotations)
            annotations = []
    
    with open(gold_file, 'r') as input_file:
        for line in input_file:
            # Überprüfen, ob die Zeile leer ist
            if not line.strip():
                continue
            # Verarbeite jede Zeile und schreibe in die Ausgabedatei
            process_line(line, "gold")
        if len(annotations) > 0:
            gold_entities.append(annotations)
            annotations = []

    tp, fp, fn = evaluate_all(pred_entities, gold_entities)
    print("******** total *********")
    print("tp: ", tp)
    print("fp: ", fp)
    print("fn: ", fn)
    print("******** result ********")
    precision = round(tp / (tp + fp), 4) if (tp + fp) > 0 else 0
    recall = round(tp / (tp + fn), 4) if (tp + fn) > 0 else 0
    f1_score = round(2 * (precision * recall) / (precision + recall), 4) if (precision + recall) > 0 else 0

    print("Precision:", precision)
    print("Recall:", recall)
    print("F1-Score:", f1_score)
    print("************************")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--pred_file")
    parser.add_argument("--gold_file")
    args = parser.parse_args()
    pred_file = args.pred_file
    gold_file = args.gold_file

    main(pred_file, gold_file)