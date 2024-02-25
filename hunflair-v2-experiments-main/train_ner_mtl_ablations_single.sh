#!/usr/bin/env bash

# Multi-task learning ablations
# Train models on a single entity type
# Compare to the model trained on all entity types with multiple entity types predicted at once
# Choose the best performing dataset combinations for each entity type
# Train on BioRed and test which additional corpora to include
# 1 --include biored
# 2 --include biored gnormplus
# 3 --include biored gnormplus bioinfer iepa osiris seth_corpus
# 4 --include biored gnormplus bioinfer iepa osiris seth_corpus cemp
# 5 --include biored cemp
# 6 --include biored chebi
# 7 --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc
# 8 --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp
# 9 --include biored gellus
# 11 --include biored variome scai mirna
# 12 --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800

# Test on high quality data out-of-corpus (development set)
# --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder
echo "Model number 1" &>> ./_output/experiments_single/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored &>> ./_output/experiments_single/multi_task_learning_ablation_1
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_gene.txt 
echo "ablation_1_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type chemical --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored &>> ./_output/experiments_single/multi_task_learning_ablation_1
sleep 5
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_single/chemical/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_chemical.txt 
echo "ablation_1_chemical.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_chemical.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type disease --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored &>> ./_output/experiments_single/multi_task_learning_ablation_1
sleep 5
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_single/disease/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_disease.txt 
echo "ablation_1_disease.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_disease.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type species --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored &>> ./_output/experiments_single/multi_task_learning_ablation_1
sleep 5
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_single/species/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_species.txt 
echo "ablation_1_species.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_species.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type cell_line --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored &>> ./_output/experiments_single/multi_task_learning_ablation_1
sleep 5
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_single/cell_line/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_cell_line.txt 
echo "ablation_1_cell_line.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_1_cell_line.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 2" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus &>> ./_output/experiments_single/multi_task_learning_ablation_2
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_2_gene.txt 
echo "ablation_2_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_2_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 3" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus bioinfer iepa osiris seth_corpus &>> ./_output/experiments_single/multi_task_learning_ablation_3
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_3_gene.txt 
echo "ablation_3_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_3_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 4" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus bioinfer iepa osiris seth_corpus cemp &>> ./_output/experiments_single/multi_task_learning_ablation_4
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_4_gene.txt 
echo "ablation_4_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_4_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 5" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored cemp &>> ./_output/experiments_single/multi_task_learning_ablation_5
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_5_gene.txt 
echo "ablation_5_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_5_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type chemical --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored cemp &>> ./_output/experiments_single/multi_task_learning_ablation_5
sleep 5
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_single/chemical/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_5_chemical.txt 
echo "ablation_5_chemical.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_5_chemical.txt &>> ./_output/experiments_single/multi_task_learning_ablations

# echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 6" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi &>> ./_output/experiments_single/multi_task_learning_ablation_6
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_6_gene.txt 
echo "ablation_6_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_6_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type chemical --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi &>> ./_output/experiments_single/multi_task_learning_ablation_6
sleep 5
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_single/chemical/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_6_chemical.txt 
echo "ablation_6_chemical.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_6_chemical.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 7" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc &>> ./_output/experiments_single/multi_task_learning_ablation_7
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_7_gene.txt 
echo "ablation_7_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_7_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type chemical --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc &>> ./_output/experiments_single/multi_task_learning_ablation_7
sleep 5
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_single/chemical/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_7_chemical.txt 
echo "ablation_7_chemical.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_7_chemical.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 8" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp &>> ./_output/experiments_single/multi_task_learning_ablation_8
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_8_gene.txt 
echo "ablation_8_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_8_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type chemical --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp &>> ./_output/experiments_single/multi_task_learning_ablation_8
sleep 5
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_single/chemical/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_8_chemical.txt 
echo "ablation_8_chemical.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_8_chemical.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 9" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus &>> ./_output/experiments_single/multi_task_learning_ablation_9
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_9_gene.txt 
echo "ablation_9_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_9_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type cell_line --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus &>> ./_output/experiments_single/multi_task_learning_ablation_9
sleep 5
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_single/cell_line/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_9_cell_line.txt 
echo "ablation_9_cell_line.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_9_cell_line.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 10" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus &>> ./_output/experiments_single/multi_task_learning_ablation_10
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_10_gene.txt 
echo "ablation_10_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_10_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type cell_line --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus &>> ./_output/experiments_single/multi_task_learning_ablation_10
sleep 5
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_single/cell_line/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_10_cell_line.txt 
echo "ablation_10_cell_line.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_10_cell_line.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 11" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include --include biored variome scai mirna &>> ./_output/experiments_single/multi_task_learning_ablation_11
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_11_gene.txt 
echo "ablation_11_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_11_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type disease --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include --include biored variome scai mirna &>> ./_output/experiments_single/multi_task_learning_ablation_11
sleep 5
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_single/disease/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_11_disease.txt 
echo "ablation_11_disease.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_11_disease.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type species --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include --include biored variome scai mirna &>> ./_output/experiments_single/multi_task_learning_ablation_11
sleep 5
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_single/species/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_11_species.txt 
echo "ablation_11_species.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_11_species.txt &>> ./_output/experiments_single/multi_task_learning_ablations

echo " " &>> ./_output/experiments_single/multi_task_learning_ablations
echo "Model number 12" &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type gene --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 12 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800 &>> ./_output/experiments_single/multi_task_learning_ablation_12
sleep 5
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_single/gene/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_gene.txt 
echo "ablation_12_gene.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_gene.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type chemical --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 12 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800 &>> ./_output/experiments_single/multi_task_learning_ablation_12
sleep 5
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_single/chemical/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_chemical.txt 
echo "ablation_12_chemical.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_chemical.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type disease --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 12 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800 &>> ./_output/experiments_single/multi_task_learning_ablation_12
sleep 5
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_single/disease/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_disease.txt 
echo "ablation_12_disease.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_disease.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type species --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 12 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800 &>> ./_output/experiments_single/multi_task_learning_ablation_12
sleep 5
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_single/species/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_species.txt 
echo "ablation_12_species.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_species.txt &>> ./_output/experiments_single/multi_task_learning_ablations
sleep 5
CUDA_VISIBLE_DEVICES=1 python train_ner_gs_model.py --strict_overlap --type cell_line --path /home/tmp/hunflair/multi_task_learning/ablations_single --data_path /home/tmp/hunflair --batch_size 12 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800 &>> ./_output/experiments_single/multi_task_learning_ablation_12
sleep 5
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_single/cell_line/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_cell_line.txt 
echo "ablation_12_cell_line.txt" &>> ./_output/experiments_single/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_single/ablation_12_cell_line.txt &>> ./_output/experiments_single/multi_task_learning_ablations

