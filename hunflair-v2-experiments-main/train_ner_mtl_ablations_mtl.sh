#!/usr/bin/env bash

# Multi-task learning ablations
# Train models on a single entity type (multi-task learning)
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
echo "Model number 1" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_1
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_gene.txt --multi_task_learning --entity_types genes
echo "ablation_1_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_chemical.txt --multi_task_learning --entity_types chemicals
echo "ablation_1_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_disease.txt --multi_task_learning --entity_types diseases
echo "ablation_1_disease.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_disease.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_species.txt --multi_task_learning --entity_types species
echo "ablation_1_species.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_species.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_cell_line.txt --multi_task_learning --entity_types "cell lines"
echo "ablation_1_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 2" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_2
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_2_gene.txt --multi_task_learning --entity_types genes
echo "ablation_2_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_2_gene.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 3" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus bioinfer iepa osiris seth_corpus --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_3
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_3_gene.txt --multi_task_learning --entity_types genes
echo "ablation_3_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_3_gene.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 4" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus bioinfer iepa osiris seth_corpus cemp --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_4
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_4_gene.txt --multi_task_learning --entity_types genes
echo "ablation_4_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_4_gene.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 5" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored cemp --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_5
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_5_gene.txt --multi_task_learning --entity_types genes
echo "ablation_5_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_5_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_5_chemical.txt --multi_task_learning --entity_types chemicals
echo "ablation_5_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_5_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 6" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_6
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_6_gene.txt --multi_task_learning --entity_types genes
echo "ablation_6_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_6_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_6_chemical.txt --multi_task_learning --entity_types chemicals
echo "ablation_6_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_6_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 7" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_7
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_7_gene.txt --multi_task_learning --entity_types genes
echo "ablation_7_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_7_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_7_chemical.txt --multi_task_learning --entity_types chemicals
echo "ablation_7_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_7_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 8" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_8
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_8_gene.txt --multi_task_learning --entity_types genes
echo "ablation_8_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_8_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_8_chemical.txt --multi_task_learning --entity_types chemicals
echo "ablation_8_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_8_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 9" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_9
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_9_gene.txt --multi_task_learning --entity_types genes
echo "ablation_9_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_9_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_9_cell_line.txt --multi_task_learning --entity_types "cell lines"
echo "ablation_9_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_9_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 10" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_10
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_10_gene.txt --multi_task_learning --entity_types genes
echo "ablation_10_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_10_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_10_cell_line.txt --multi_task_learning --entity_types "cell lines"
echo "ablation_10_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_10_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 11" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include --include biored variome scai mirna --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_11
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_gene.txt --multi_task_learning --entity_types genes
echo "ablation_11_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_disease.txt --multi_task_learning --entity_types diseases
echo "ablation_11_disease.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_disease.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_species.txt --multi_task_learning --entity_types species
echo "ablation_11_species.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_species.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 12" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations --data_path /home/tmp/hunflair/multi_task_learning --batch_size 12 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5  --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800 --multi_task_learning > ./_output/experiments/multi_task_learning_ablation_12
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_gene.txt --multi_task_learning --entity_types genes
echo "ablation_12_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_chemical.txt --multi_task_learning --entity_types chemicals
echo "ablation_12_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_disease.txt --multi_task_learning --entity_types diseases
echo "ablation_12_disease.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_disease.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_species.txt --multi_task_learning --entity_types species
echo "ablation_12_species.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_species.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_cell_line.txt --multi_task_learning --entity_types "cell lines"
echo "ablation_12_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations

