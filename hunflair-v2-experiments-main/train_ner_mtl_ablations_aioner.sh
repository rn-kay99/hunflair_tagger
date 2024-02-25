#!/usr/bin/env bashtl/best-model.pt

# Multi-task learning
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
# For models 9, 10, 11 model with learning rate 2e-5 returns no results
# For model 11: Try increase learning rate to 4e-5 (does not work), 1e-4 (does not work), 1e-5 (does not work), 4e-6 (does not work), 2e-6 (does not work), 1e-6 (does not work), 4e-7 (does not work).
# For model 11: Try remove option --aioner_remove_duplicates, 2e-5 (does not work), try to remove VARIOME corpus (does not work), VARIOME and MiRNA (does not work), so remove all additional corpora VARIOME, MiRNA and SCAI (this is the same as only biored and works again...)
echo "Model number 1" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored > ./_output/experiments/multi_task_learning_ablation_1
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_gene.txt --entity_types genes
echo "ablation_1_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_chemical.txt --entity_types chemicals
echo "ablation_1_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_disease.txt --entity_types diseases
echo "ablation_1_disease.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_disease.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_species.txt --entity_types species
echo "ablation_1_species.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_species.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_cell_line.txt --entity_types "cell lines"
echo "ablation_1_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_1_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 2" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus > ./_output/experiments/multi_task_learning_ablation_2
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_2_gene.txt --entity_types genes
echo "ablation_2_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_2_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_2_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_2_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_2_all.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 3" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus bioinfer iepa osiris seth_corpus > ./_output/experiments/multi_task_learning_ablation_3
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_3_gene.txt --entity_types genes
echo "ablation_3_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_3_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_3_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_3_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_3_all.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 4" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gnormplus bioinfer iepa osiris seth_corpus cemp > ./_output/experiments/multi_task_learning_ablation_4
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_4_gene.txt --entity_types genes
echo "ablation_4_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_4_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_4_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_4_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_4_all.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 5" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored cemp > ./_output/experiments/multi_task_learning_ablation_5
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_gene.txt --entity_types genes
echo "ablation_5_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_chemical.txt --entity_types chemicals
echo "ablation_5_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_5_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_5_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_5_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 6" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi > ./_output/experiments/multi_task_learning_ablation_6
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_gene.txt --entity_types genes
echo "ablation_6_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_chemical.txt --entity_types chemicals
echo "ablation_6_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_6_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_6_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_6_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 7" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc > ./_output/experiments/multi_task_learning_ablation_7
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_gene.txt --entity_types genes
echo "ablation_7_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_7_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_chemical.txt --entity_types chemicals
echo "ablation_7_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_all_2.txt --input_dataset nlmchem --entity_types "cell lines" chemicals diseases genes species
echo "ablation_7_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_7_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 8" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp > ./_output/experiments/multi_task_learning_ablation_8
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_gene.txt --entity_types genes
echo "ablation_8_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_8_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_chemical.txt --entity_types chemicals
echo "ablation_8_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_8_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_8_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 9" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus > ./_output/experiments/multi_task_learning_ablation_9
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_gene.txt --entity_types genes
echo "ablation_9_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_9_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_cell_line.txt --entity_types "cell lines"
echo "ablation_9_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_9_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_9_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 10" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored gellus > ./_output/experiments/multi_task_learning_ablation_10
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_gene.txt --entity_types genes
echo "ablation_10_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_10_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_cell_line.txt --entity_types "cell lines"
echo "ablation_10_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_10_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_10_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 11" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 16 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 4.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include --include biored variome scai mirna > ./_output/experiments/multi_task_learning_ablation_11
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_gene.txt --entity_types genes
echo "ablation_11_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_11_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_disease.txt --entity_types diseases
echo "ablation_11_disease.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_disease.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_11_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_species.txt --entity_types species
echo "ablation_11_species.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_species.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_all_3.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_11_all_3.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_11_all_3.txt &>> ./_output/experiments/multi_task_learning_ablations

echo " " &>> ./_output/experiments/multi_task_learning_ablations
echo "Model number 12" &>> ./_output/experiments/multi_task_learning_ablations
CUDA_VISIBLE_DEVICES=0 python train_ner_gs_model.py --type mtl --path /home/tmp/hunflair/multi_task_learning/ablations_aioner_2 --data_path /home/tmp/hunflair/multi_task_learning --batch_size 12 --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_with_test --learning_rate 2.0e-5 --multi_task_learning --aioner --aioner_remove_duplicates --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder --include biored chebi bionlp_st_2011_id bionlp_st_2013_pc gnormplus bioinfer iepa osiris seth_corpus cemp gellus variome scai mirna loctext cpi deca s800 > ./_output/experiments/multi_task_learning_ablation_12
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_gene.txt --entity_types genes
echo "ablation_12_gene.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_gene.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_chemical.txt --entity_types chemicals
echo "ablation_12_chemical.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_chemical.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_2.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_2.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_disease.txt --entity_types diseases
echo "ablation_12_disease.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_disease.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_3.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_3.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_3.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_species.txt --entity_types species
echo "ablation_12_species.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_species.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_4.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_4.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_4.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_cell_line.txt --entity_types "cell lines"
echo "ablation_12_cell_line.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_cell_line.txt &>> ./_output/experiments/multi_task_learning_ablations
python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablations_aioner_2/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_5.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_5.txt" &>> ./_output/experiments/multi_task_learning_ablations
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations_aioner_2/ablation_12_all_5.txt &>> ./_output/experiments/multi_task_learning_ablations
