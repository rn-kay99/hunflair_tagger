"""
This Python script implements a function to merge fine-grained entities represented by tab-separated annotations.
The merging is achieved by combining consecutive annotations with identical starting positions. 
The algorithm checks whether the starting position of the current annotation matches or directly follows the ending position of the previous one, and then combines them into a single annotation.

Example Usage:
python merge_fine_grained_entities.py --input_file ../../test_my_modell_prediction/fine_grained_biolinkbert/variation_biored_3_4095/pred.txt --output_file ../../test_my_modell_prediction/fine_grained_biolinkbert/variation_biored_3_4095/merged_pred.txt
"""

import argparse

def process_text(line, output_file):
    fields = [line.split('\t') for line in line.split('\n') if line.strip()]
    current_annotation = []

    with open(output_file, 'w') as file:
        for field in fields:

            if len(field) == 1:
                if len(current_annotation) > 0:
                    current_annotation[4] = "geneticvariant"
                    file.write("\t".join(current_annotation))
                    file.write("\n")
                current_annotation = []
                file.write(field[0])
                file.write("\n")
                continue

            start, end, variation = int(field[1]), int(field[2]), str(field[3])
            if len(current_annotation) > 0:
                if start == int(current_annotation[2]):
                    current_annotation[2] = str(end)
                    current_annotation[3] = current_annotation[3] + variation
                elif start == int(current_annotation[2]) + 1:
                    current_annotation[2] = str(end)
                    current_annotation[3] = current_annotation[3] + " " + variation
                else:
                    current_annotation[4] = "geneticvariant"
                    file.write("\t".join(current_annotation))
                    file.write("\n")
                    current_annotation = field
            else:
                current_annotation = field

def main(input_file, output_file):
    
    with open(input_file, 'r') as file:
        text = file.read()
        process_text(text, output_file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input_file")
    parser.add_argument("--output_file")
    args = parser.parse_args()
    input_file = args.input_file
    output_file = args.output_file

    main(input_file, output_file)