#!/usr/bin/env bash

# In-corpus ablations

# python generate_goldstandard.py --data_set biored --output_dir ./data/biored_test/ --exclude_splits train validation

# echo "Model number 1: AIONER model" &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=3 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_in_corpus --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "microsoft/BiomedNLP-PubMedBERT-base-uncased-abstract-fulltext" --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --transformers_use_crf --remove_standard_test_corpora --include biored > ./_output/experiments/in_corpus_ablations_tmp
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_1_all.txt --entity_types "cell lines" chemicals diseases genes species
# echo "ablation_1_all.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_1_all.txt &>> ./_output/experiments/in_corpus_ablations

# echo "" &>> ./_output/experiments/in_corpus_ablations
# echo "Model number 2: AIONER model plus other datasets" &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=3 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_in_corpus --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "microsoft/BiomedNLP-PubMedBERT-base-uncased-abstract-fulltext" --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --transformers_use_crf --remove_standard_test_corpora --include biored nlm_gene gnormplus cdr nlm_chem linneaus s800 ncbi > ./_output/experiments/in_corpus_ablations_tmp_2
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_2_all.txt --entity_types "cell lines" chemicals diseases genes species
# echo "ablation_2_all.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_2_all.txt &>> ./_output/experiments/in_corpus_ablations

# echo "" &>> ./_output/experiments/in_corpus_ablations
# echo "Model number 3: MTL model" &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_in_corpus --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "microsoft/BiomedNLP-PubMedBERT-base-uncased-abstract-fulltext" --learning_rate 2.0e-5 --multi_task_learning --transformers_use_crf --remove_standard_test_corpora --include biored nlm_gene gnormplus cdr nlm_chem linneaus s800 ncbi > ./_output/experiments/in_corpus_ablations_tmp_3
# CUDA_VISIBLE_DEVICES=1 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_cell_lines.txt --entity_types "cell lines"
# echo "ablation_3_cell_lines.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_cell_lines.txt &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=1 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_chemicals.txt --entity_types chemicals
# echo "ablation_3_chemicals.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_chemicals.txt &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=1 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_diseases.txt --entity_types diseases
# echo "ablation_3_diseases.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_diseases.txt &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=1 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_genes.txt --entity_types genes
# echo "ablation_3_genes.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_genes.txt &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=1 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_species.txt --entity_types species
# echo "ablation_3_species.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_3_species.txt &>> ./_output/experiments/in_corpus_ablations

# echo "Model number 4: AIONER model (BioLink-BERT)" &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=3 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_in_corpus --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --remove_standard_test_corpora --include biored > ./_output/experiments/in_corpus_ablations_tmp_4
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_4_all.txt --entity_types "cell lines" chemicals diseases genes species
# echo "ablation_4_all.txt" &>> ./_output/experiments/in_corpus_ablations
# python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_4_all.txt &>> ./_output/experiments/in_corpus_ablations

# echo "Model number 5: Own AIO model version (BioLink-BERT)" &>> ./_output/experiments/in_corpus_ablations
# CUDA_VISIBLE_DEVICES=3 python train_ner_gs_model.py --type all --path /home/tmp/hunflair/multi_task_learning/ablations_in_corpus --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --learning_rate 2.0e-5 --multi_task_learning --remove_standard_test_corpora --include biored nlm_gene gnormplus cdr nlm_chem linneaus s800 ncbi > ./_output/experiments/in_corpus_ablations_tmp_5
CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/all/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_5_all.txt" &>> ./_output/experiments/in_corpus_ablations
python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_all.txt &>> ./_output/experiments/in_corpus_ablations

CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/all/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_cell_lines.txt --entity_types "cell lines" 
echo "ablation_5_cell_lines.txt" &>> ./_output/experiments/in_corpus_ablations
python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_cell_lines.txt &>> ./_output/experiments/in_corpus_ablations

CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/all/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_chemicals.txt --entity_types chemicals
echo "ablation_5_chemicals.txt" &>> ./_output/experiments/in_corpus_ablations
python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_chemicals.txt &>> ./_output/experiments/in_corpus_ablations

CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/all/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_diseases.txt --entity_types diseases
echo "ablation_5_diseases.txt" &>> ./_output/experiments/in_corpus_ablations
python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_diseases.txt &>> ./_output/experiments/in_corpus_ablations

CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/all/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_genes.txt --entity_types genes
echo "ablation_5_genes.txt" &>> ./_output/experiments/in_corpus_ablations
python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_genes.txt &>> ./_output/experiments/in_corpus_ablations

CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --predict_test_only --input_dataset biored --model /home/tmp/hunflair/multi_task_learning/ablations_in_corpus/all/best-model.pt --output_file data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_species.txt --entity_types species
echo "ablation_5_species.txt" &>> ./_output/experiments/in_corpus_ablations
python evaluate_annotation.py --gold_file ./data/biored_test/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/in_corpus_ablations/ablation_5_species.txt &>> ./_output/experiments/in_corpus_ablations
