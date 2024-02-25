#!/usr/bin/env bash

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

python generate_goldstandard.py --data_set nlm_gene --output_dir ./data/nlm_gene/
python generate_goldstandard.py --data_set nlmchem --output_dir ./data/nlm_chem/
python generate_goldstandard.py --data_set ncbi_disease --output_dir ./data/ncbi_disease/
python generate_goldstandard.py --data_set linnaeus --output_dir ./data/linneaus/
python generate_goldstandard.py --data_set cellfinder --output_dir ./data/cell_finder/

# Test on high quality data out-of-corpus (development set)
# --exclude nlm_chem nlm_gene ncbi_disease linneaus cell_finder
echo "Model number 1" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_1/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_gene.txt --entity_types genes
echo "ablation_1_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_1/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_chemical.txt --entity_types chemicals
echo "ablation_1_chemical.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_chemical.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablation_1/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_disease.txt --entity_types diseases
echo "ablation_1_disease.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_disease.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablation_1/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_species.txt --entity_types species
echo "ablation_1_species.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_species.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablation_1/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_1_cell_line.txt --entity_types "cell lines"
echo "ablation_1_cell_line.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_1_cell_line.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 2" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_2/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_2_gene.txt --entity_types genes
echo "ablation_2_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_2_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_2/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_2_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_2_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_2_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 3" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_3/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_3_gene.txt --entity_types genes
echo "ablation_3_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_3_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_3/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_3_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_3_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_3_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 4" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_4/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_4_gene.txt --entity_types genes
echo "ablation_4_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_4_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_4/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_4_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_4_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_4_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 5" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_5/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_5_gene.txt --entity_types genes
echo "ablation_5_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_5_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_5/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_5_chemical.txt --entity_types chemicals
echo "ablation_5_chemical.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_5_chemical.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_5/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_5_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_5_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_5_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_5/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_5_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_5_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_5_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 6" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_6/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_6_gene.txt --entity_types genes
echo "ablation_6_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_6_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_6/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_6_chemical.txt --entity_types chemicals
echo "ablation_6_chemical.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_6_chemical.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_6/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_6_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_6_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_6_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_6/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_6_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_6_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_6_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 7" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_7/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_7_gene.txt --entity_types genes
echo "ablation_7_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_7_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_7/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_7_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_7_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_7_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_7/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_7_chemical.txt --entity_types chemicals
echo "ablation_7_chemical.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_7_chemical.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --model /home/tmp/hunflair/multi_task_learning/ablation_7/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_7_all_2.txt --input_dataset nlmchem --entity_types "cell lines" chemicals diseases genes species
echo "ablation_7_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_7_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 8" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_8/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_8_gene.txt --entity_types genes
echo "ablation_8_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_8_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_8/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_8_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_8_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_8_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_8/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_8_chemical.txt --entity_types chemicals
echo "ablation_8_chemical.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_8_chemical.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_8/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_8_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_8_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_8_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 9" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_9/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_9_gene.txt --entity_types genes
echo "ablation_9_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_9_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_9/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_9_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_9_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_9_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablation_9/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_9_cell_line.txt --entity_types "cell lines"
echo "ablation_9_cell_line.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_9_cell_line.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablation_9/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_9_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_9_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_9_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 10" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_10/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_10_gene.txt --entity_types genes
echo "ablation_10_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_10_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_10/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_10_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_10_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_10_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablation_10/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_10_cell_line.txt --entity_types "cell lines"
echo "ablation_10_cell_line.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_10_cell_line.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablation_10/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_10_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_10_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_10_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 11" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_11/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_gene.txt --entity_types genes
echo "ablation_11_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_11/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_11_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablation_11/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_disease.txt --entity_types diseases
echo "ablation_11_disease.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_disease.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablation_11/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_11_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablation_11/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_species.txt --entity_types species
echo "ablation_11_species.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_species.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablation_11/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_11_all_3.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_11_all_3.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_11_all_3.txt >> ./_output/experiments/multi_task_learning_ablations_predictions

echo " " >> ./_output/experiments/multi_task_learning_ablations_predictions
echo "Model number 12" >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_gene.txt --entity_types genes
echo "ablation_12_gene.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_gene.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlm_gene --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_gene/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_chemical.txt --entity_types chemicals
echo "ablation_12_chemical.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_chemical.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset nlmchem --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_2.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_2.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/nlm_chem/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_2.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_disease.txt --entity_types diseases
echo "ablation_12_disease.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_disease.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset ncbi_disease --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_3.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_3.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/ncbi_disease/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_3.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_species.txt --entity_types species
echo "ablation_12_species.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_species.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset linnaeus --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_4.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_4.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/linneaus/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_4.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_cell_line.txt --entity_types "cell lines"
echo "ablation_12_cell_line.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_cell_line.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
python predict_hunflair_v2.py --input_dataset cellfinder --model /home/tmp/hunflair/multi_task_learning/ablation_12/all/best-model.pt --output_file data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_5.txt --entity_types "cell lines" chemicals diseases genes species
echo "ablation_12_all_5.txt" >> ./_output/experiments/multi_task_learning_ablations_predictions
python evaluate_annotation.py --gold_file ./data/cell_finder/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/mtl_ablations/ablation_12_all_5.txt >> ./_output/experiments/multi_task_learning_ablations_predictions
