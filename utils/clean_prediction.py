"""
Example Usage:
python clean_prediction.py --pred_file models/biolinkbert/osiris_7776/pred.txt --output_file models/biolinkbert/osiris_7776/pred.txt
"""
import argparse

pred_entities = []
gold_entities = []
annotations = []

def process_text(text, entity, output_file):
    # fields = text.split('\t')
    fields = [text.split('\t') for text in text.split('\n') if text.strip()]
    
    for field in fields:
        if len(field) == 1:
            output_file.write(field[0])
            output_file.write("\n")
            continue

        variation = str(field[3]).strip()
        if variation != "":
            output_file.write("\t".join(field))
            output_file.write("\n")
    

def main(pred_file, output_file, entity):

    with open(pred_file, 'r') as input_file, open(output_file, 'w') as output_file:
        text = input_file.read()
        process_text(text, entity, output_file)
            
    

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--pred_file")
    parser.add_argument("--output_file")
    parser.add_argument("--entity")
    args = parser.parse_args()
    pred_file = args.pred_file
    output_file = args.output_file
    entity = args.entity

    main(pred_file, output_file, entity)