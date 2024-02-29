import re
import json
from itertools import groupby
import sys

def find_indices_and_append(start_index, genetic_variant, part, article, entity_data, label):
    if part:
        part_start_index = start_index + genetic_variant.find(part)
        part_end_index = part_start_index + len(part)
        print(f"{label}({article[part_start_index:part_end_index]})")
        entity_data.append(f"{label}({part_start_index},{part_end_index})")

def parse_genetic_variants(file_name, output_file):
    TEXT = r'([a-zA-Z()\s*]+)'
    SEP = r'([\,\:\;\(\)])'
    REF = r'(?:([cgrm])(\.))'
    P_REF = r'(?:([p])(\.))'
    NUC = r'([ATGCatgcu]+)'
    OP = r'(-->|->|\-|\_|mutation at position|exchange at position|transversion at nucleotide|replacement of|substitution at position|substitution at codon|substitution at nucleotide|substitution of nucleotide|substitution at residue|substitution at amino acid position|substitution at amino acid|at amino acid position|deletion at nucleotide|at amino acid|at position|residue with|at residue|at codon|>|deletion|indel|delins|del|ins|inv|dup|tri|qua|con|to|Stop|stop|by a|by|for|from|with|\/)'
    OPS = r'(?:{}\s*)+'.format(OP)
    FRAME_SHIFT = r'(fs|fsX|X)'
    FRAME_SHIFT_OR_OP = r'(?:{}|{})'.format(FRAME_SHIFT, OPS)
    SNP_ID = r'(rs[\#]?\s*\d+)'
    POS = r'([\+|\-]?\s*\d+|\?)'
    NUC_POS = r'(?:(?:{}\s*([\+|\-]))?\s*{}|\*\s*{}|{}\s*\*)'.format(POS, POS, POS, POS)
    NUC_POS_OR_OP = r'(?:{}?\s*(?:{}|{})?\s*{}?)'.format(SEP, NUC_POS, OP, SEP)
    NUC_POS_OR_SNP_ID = r'(?:{}?\s*(?:{}|{})?\s*{}?)'.format(SEP, NUC_POS, SNP_ID, SEP)
    NUC_RANGE = r'{}\s*(?:(\_)\s*{})?'.format(NUC_POS, NUC_POS)
    PROTEIN = r'(adenine|alanine|arginine|asparagine|aspartic acid|cytosine|cysteine|glutamate|glutamine|glutamic acid|glycine|guanine|histidine|isoleucine|leucine|lysine|methionine|phenylalanine|proline|serine|threonine|thymidine|tryptophan|tyrosine|valine|Ala|Arg|Asn|Asp|Cys|Gln|Glu|Gly|His|Ile|Leu|Lys|Met|Phe|Pro|Ser|Thr|Trp|Trp|Tyr|Val)'

    # TODO: Merge regex patterns 3+5 and 1+6+7
    pattern1 = re.compile(r'^{}?\s*{}\s*{}?\s*{}?\s*{}*\s*{}?\s*{}?$'.format(REF, NUC_RANGE, SEP, NUC, OP, NUC, SEP))
    pattern2 = re.compile(r'^{}?\s*{}\s*{}?\s*{}?\s*{}?\s*{}\s*{}\s*{}?\s*{}?\s*{}?\s*$'.format(REF, NUC, SEP, NUC_POS, SEP, NUC_POS_OR_OP, NUC, OP, REF, NUC_POS))
    pattern3 = re.compile(r'^{}?\s*{}\s*{}?\s*{}?\s*{}?\s*{}?\s*{}?\s*{}?\s*{}?\b$'.format(P_REF, PROTEIN, NUC_POS_OR_SNP_ID, OP, PROTEIN, NUC_POS_OR_SNP_ID, FRAME_SHIFT_OR_OP, NUC_POS, PROTEIN))
    pattern4 = re.compile(r'^{}?\s*{}\s*{}?$'.format(SEP, SNP_ID, SEP))
    pattern5 = re.compile(r'^(?:(?:(?P<coding_protein>[p])(?P<mutation_component_1>\.))(?P<protein_amino_1>[ATGCISQMNPKDFHLRWVEYX])|(?P<protein_amino_2>[ISQMNPKDFHLRWVEYX]))\s*(?P<position>\d+)\s*(?:(?P<protein_amino_3>[ISQMNPKDFHLRWVEYX])|(?P<frame_shift>fs|fsx)|(?P<mutation_type>del|ins|dup|tri|qua|con|delins|indel))?\b$')
    pattern6 = re.compile(r'^(IVS)\s*{}\s*{}?\s*{}?\s*{}?\s*{}$'.format(NUC_RANGE, SEP, NUC, OP, NUC))
    pattern7 = re.compile(r'^{}(?:\s*{}\s*{})?\s*{}?\s*(exon)\s*{}\s*{}?\s*{}\s*{}\s*{}?$'.format(NUC, OP, NUC, TEXT, NUC_POS, SEP, TEXT, NUC_POS, TEXT))

    pattern1_matches_num = 0
    pattern2_matches_num = 0
    pattern3_matches_num = 0
    pattern4_matches_num = 0
    pattern5_matches_num = 0
    pattern6_matches_num = 0
    pattern7_matches_num = 0

    corpus_size = 0
    json_data = {}

    try:
        with open(file_name, 'r') as file:
            lines = file.read().strip().split('\n')
            grouped_lines = [list(g) for k, g in groupby(lines, key=lambda line: re.match(r'^\d+', line).group())]
            not_matched_groups = []

            for group in grouped_lines:
                group_id = group[0].split("|")[0]
                title = group[0].split("|")[2]
                abstract = group[1].split("|")[2]
                article = title + " " + abstract

                i = 2
                entity_data = []

                while i < len(group):
                    corpus_size += 1
                    parts = group[i].split()
                    start_index = int(parts[1])
                    end_index = int(parts[2])
                    genetic_variant = article[start_index:end_index].strip()
                    pattern1_matches = re.findall(pattern1, genetic_variant)
                    pattern2_matches = re.findall(pattern2, genetic_variant)
                    pattern3_matches = re.findall(pattern3, genetic_variant)
                    pattern4_matches = re.findall(pattern4, genetic_variant)
                    pattern5_matches = re.findall(pattern5, genetic_variant)
                    pattern6_matches = re.findall(pattern6, genetic_variant)
                    pattern7_matches = re.findall(pattern7, genetic_variant)
                    variant_was_matched = False

                    for match in pattern1_matches:
                        variant_was_matched = True
                        pattern1_matches_num += 1
                        component_to_entity_type = ["reference_sequence_type", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "mutation_component", "dna_rna_nucleotide", "mutation_type", "dna_rna_nucleotide", "mutation_component"]
                        
                        for idx, value in enumerate(match):
                            find_indices_and_append(start_index, genetic_variant, value, article, entity_data, component_to_entity_type[idx])

                    for match in pattern2_matches:
                        variant_was_matched = True
                        pattern2_matches_num += 1
                        component_to_entity_type = ["reference_sequence_type", "mutation_component", "dna_rna_nucleotide", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "mutation_component", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "mutation_type", "mutation_component", "dna_rna_nucleotide", "mutation_type", "reference_sequence_type", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit"]
                        
                        for idx, value in enumerate(match):
                            find_indices_and_append(start_index, genetic_variant, value, article, entity_data, component_to_entity_type[idx])

                    for match in pattern3_matches:
                        variant_was_matched = True
                        pattern3_matches_num += 1
                        component_to_entity_type = ["reference_sequence_type", "mutation_component", "protein_amino_acid", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "snp_id", "mutation_component", "mutation_type", "protein_amino_acid", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "snp_id", "mutation_component", "frame_shift_mutation", "mutation_type", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "protein_amino_acid"]
                        
                        for idx, value in enumerate(match):
                            find_indices_and_append(start_index, genetic_variant, value, article, entity_data, component_to_entity_type[idx])

                    for match in pattern4_matches:
                        variant_was_matched = True
                        pattern4_matches_num += 1
                        component_to_entity_type = ["mutation_component", "snp_id", "mutation_component"]
                        
                        for idx, value in enumerate(match):
                            find_indices_and_append(start_index, genetic_variant, value, article, entity_data, component_to_entity_type[idx])

                    for match in pattern5_matches:
                        variant_was_matched = True
                        pattern5_matches_num += 1
                        coding_protein_part = match[0]
                        mutation_component_1_part = match[1]
                        protein_amino_1_part = match[2]
                        protein_amino_2_part = match[3]
                        position_part = match[4]
                        protein_amino_3_part = match[5]
                        frame_shift_part = match[6]
                        mutation_type_part = match[7]

                        # coding_protein_part
                        find_indices_and_append(start_index, genetic_variant, coding_protein_part, article, entity_data, "reference_sequence_type")
                        # mutation_component_1_part
                        find_indices_and_append(start_index, genetic_variant, mutation_component_1_part, article, entity_data, "mutation_component")
                        # protein_amino_1_part
                        find_indices_and_append(start_index, genetic_variant, protein_amino_1_part, article, entity_data, "protein_amino_acid")
                        # protein_amino_2_part:
                        find_indices_and_append(start_index, genetic_variant, protein_amino_2_part, article, entity_data, "protein_amino_acid")
                        # position_part
                        find_indices_and_append(start_index, genetic_variant, position_part, article, entity_data, "mutation_unit")
                        # protein_amino_3_part
                        find_indices_and_append(start_index, genetic_variant, protein_amino_3_part, article, entity_data, "protein_amino_acid")
                        # frame_shift_part
                        find_indices_and_append(start_index, genetic_variant, frame_shift_part, article, entity_data, "frame_shift_mutation")
                        # mutation_type_part
                        find_indices_and_append(start_index, genetic_variant, mutation_type_part, article, entity_data, "mutation_type")

                    for match in pattern6_matches:
                        variant_was_matched = True
                        pattern6_matches_num += 1
                        component_to_entity_type = ["exon_intron", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit","mutation_unit","mutation_unit", "mutation_component", "dna_rna_nucleotide", "mutation_type", "dna_rna_nucleotide"]
                        
                        for idx, value in enumerate(match):
                            find_indices_and_append(start_index, genetic_variant, value, article, entity_data, component_to_entity_type[idx])

                    for match in pattern7_matches:
                        variant_was_matched = True
                        pattern7_matches_num += 1
                        component_to_entity_type = []
                        component_to_entity_type = ["dna_rna_nucleotide", "mutation_type", "dna_rna_nucleotide", "mutation_component", "exon_intron", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "mutation_component", "mutation_component", "mutation_unit", "mutation_component", "mutation_unit", "mutation_unit", "mutation_unit", "mutation_component"]
                        print("HELLLOOO")
                        print(genetic_variant)
                        for idx, value in enumerate(match):
                            find_indices_and_append(start_index, genetic_variant, value, article, entity_data, component_to_entity_type[idx])

                    if variant_was_matched == False:
                        find_indices_and_append(start_index, genetic_variant, genetic_variant, article, entity_data, "mutation_component")
                        not_matched_groups.append(genetic_variant)
                    
                    i += 1

                json_data[f"sample#{group_id}"] = {
                    f"sample#{group_id}_text": article,
                    f"sample#{group_id}_entities": entity_data
                }

            print("******** not matched yet: *********")
            for no_match in not_matched_groups:
                print(f"{no_match}")

            print("******** statistic: *********")
            total_matches = (pattern1_matches_num + pattern2_matches_num + pattern3_matches_num + pattern4_matches_num + pattern5_matches_num + pattern6_matches_num + pattern7_matches_num)
            print("pattern1 matches: ", pattern1_matches_num)
            print("pattern2 matches: ", pattern2_matches_num)
            print("pattern3 matches: ", pattern3_matches_num)
            print("pattern4 matches: ", pattern4_matches_num)
            print("pattern5 matches: ", pattern5_matches_num)
            print("pattern6 matches: ", pattern6_matches_num)
            print("pattern7 matches: ", pattern7_matches_num)
            print("Coverage:", round(total_matches / corpus_size * 100, 2), "% , Corpus size: ", corpus_size, ", Total matches: ", total_matches)
        
        with open(output_file, 'w') as output_file:
            json.dump(json_data, output_file, indent=4)
    except FileNotFoundError:
        print(f"The specified file '{file_name}' was not found.")
    except Exception as e:
        print("An error has occurred:", e)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python fine_grained_corpus_parser.py input_file output_file")
    else:
        file_name = sys.argv[1]
        output_file = sys.argv[2]
        parse_genetic_variants(file_name, output_file)
