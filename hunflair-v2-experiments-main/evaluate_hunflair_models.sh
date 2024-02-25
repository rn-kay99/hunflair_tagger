
## Hunflair v2 evaluation

echo "Hunflair v2 evaluation"

echo "---------------------"
echo "PDR"

# python generate_goldstandard.py --data_set pdr --output_dir ./data/pdr/

echo " "
echo "All"

echo " "
echo "AIO (all)"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset pdr --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/pdr/hunflair_v2_all_aio_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/pdr/goldstandard.txt --pred_file ./data/pdr/hunflair_v2_all_aio_biored.txt

echo " "
echo "AIONER (all)"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset pdr --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/pdr/hunflair_v2_all_aioner_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/pdr/goldstandard.txt --pred_file ./data/pdr/hunflair_v2_all_aioner_biored.txt

echo " "
echo "Disease"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset pdr --model hunflair-paper-disease --output_file data/pdr/hunflair_v1_disease_paper.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/pdr/goldstandard.txt --pred_file ./data/pdr/hunflair_v1_disease_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset pdr --model /home/tmp/hunflair/disease_transformers_lr_2e-5/disease/best-model.pt --output_file data/pdr/hunflair_v2_disease_transformers_lr_2e-5.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/pdr/goldstandard.txt --pred_file ./data/pdr/hunflair_v2_disease_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset pdr --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/pdr/hunflair_v2_disease_mtl_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/pdr/goldstandard.txt --pred_file ./data/pdr/hunflair_v2_disease_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset pdr --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/pdr/hunflair_v2_disease_aio_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/pdr/goldstandard.txt --pred_file ./data/pdr/hunflair_v2_disease_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset pdr --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/pdr/hunflair_v2_disease_aioner_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/pdr/goldstandard.txt --pred_file ./data/pdr/hunflair_v2_disease_aioner_biored.txt

echo " "

echo "---------------------"
echo "BioID"

# # python generate_goldstandard.py --data_set bioid --output_dir ./data/bioid/

echo " "
echo "All"

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bioid/hunflair_v2_all_aio_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_all_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bioid --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bioid/hunflair_v2_all_aioner_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_all_aioner_biored.txt

echo " "
echo "Genes"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model hunflair-paper-gene --output_file data/bioid/hunflair_v1_gene_paper.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v1_gene_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model /home/tmp/hunflair/gene_transformers_lr_2e-5/gene/final-model.pt --output_file data/bioid/hunflair_v2_gene_transformers_lr_2e-5.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_gene_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bioid/hunflair_v2_gene_mtl_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_gene_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bioid/hunflair_v2_gene_aio_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_gene_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bioid --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bioid/hunflair_v2_gene_aioner_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_gene_aioner_biored.txt

echo " "
echo "Chemicals"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model hunflair-paper-chemical --output_file data/bioid/hunflair_v1_chemical_paper.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v1_chemical_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model /home/tmp/hunflair/chemical_transformers_lr_2e-5/chemical/final-model.pt --output_file data/bioid/hunflair_v2_chemical_transformers_lr_2e-5.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_chemical_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bioid/hunflair_v2_chemical_mtl_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_chemical_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bioid/hunflair_v2_chemical_aio_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_chemical_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bioid --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bioid/hunflair_v2_chemical_aioner_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_chemical_aioner_biored.txt

echo " "
echo "Species"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model hunflair-paper-species --output_file data/bioid/hunflair_v1_species_paper.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v1_species_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model /home/tmp/hunflair/species_transformers_lr_2e-5/species/final-model.pt --output_file data/bioid/hunflair_v2_species_transformers_lr_2e-5.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_species_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bioid/hunflair_v2_species_mtl_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_species_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bioid/hunflair_v2_species_aio_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_species_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bioid --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bioid/hunflair_v2_species_aioner_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_species_aioner_biored.txt

echo " "
echo "Cell lines"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model hunflair-paper-cellline --output_file data/bioid/hunflair_v1_cell_line_paper.txt --entity_types "cell lines"
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v1_cell_line_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bioid --model /home/tmp/hunflair/cell_line_transformers_lr_2e-5/cell_line/final-model.pt --output_file data/bioid/hunflair_v2_cell_line_transformers_lr_2e-5.txt --entity_types "cell lines"
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_cell_line_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bioid/hunflair_v2_cell_line_mtl_biored.txt --entity_types "cell lines"
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_cell_line_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bioid --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bioid/hunflair_v2_cell_line_aio_biored.txt --entity_types "cell lines"
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_cell_line_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bioid --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bioid/hunflair_v2_cell_line_aioner_biored.txt --entity_types "cell lines"
python evaluate_annotation.py --gold_file ./data/bioid/goldstandard.txt --pred_file ./data/bioid/hunflair_v2_cell_line_aioner_biored.txt

echo " "

echo "---------------------"
echo "CRAFT"

# python generate_goldstandard.py --data_set craft --output_dir ./data/craft/

echo " "
echo "All"

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset craft --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/craft/hunflair_v2_all_aio_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_all_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset craft --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/craft/hunflair_v2_all_aioner_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_all_aioner_biored.txt

echo " "
echo "Genes"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset craft --model hunflair-paper-gene --output_file data/craft/hunflair_v1_gene_paper.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v1_gene_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset craft --model /home/tmp/hunflair/gene_transformers_lr_2e-5/gene/final-model.pt --output_file data/craft/hunflair_v2_gene_transformers_lr_2e-5.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_gene_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset craft --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/craft/hunflair_v2_gene_mtl_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_gene_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset craft --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/craft/hunflair_v2_gene_aio_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_gene_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset craft --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/craft/hunflair_v2_gene_aioner_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_gene_aioner_biored.txt

echo " "
echo "Chemicals"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset craft --model hunflair-paper-chemical --output_file data/craft/hunflair_v1_chemical_paper.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v1_chemical_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset craft --model /home/tmp/hunflair/chemical_transformers_lr_2e-5/chemical/best-model.pt --output_file data/craft/hunflair_v2_chemical_transformers_lr_2e-5.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_chemical_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset craft --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/craft/hunflair_v2_chemical_mtl_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_chemical_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset craft --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/craft/hunflair_v2_chemical_aio_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_chemical_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset craft --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/craft/hunflair_v2_chemical_aioner_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_chemical_aioner_biored.txt

echo " "
echo "Species"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset craft --model hunflair-paper-species --output_file data/craft/hunflair_v1_species_paper.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v1_species_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset craft --model /home/tmp/hunflair/species_transformers_lr_2e-5/species/best-model.pt --output_file data/craft/hunflair_v2_species_transformers_lr_2e-5.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_species_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset craft --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/craft/hunflair_v2_species_mtl_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_species_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset craft --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/craft/hunflair_v2_species_aio_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_species_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset craft --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/craft/hunflair_v2_species_aioner_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/craft/goldstandard.txt --pred_file ./data/craft/hunflair_v2_species_aioner_biored.txt

echo " "

echo "---------------------"
echo "BC5CDR"

# python generate_goldstandard.py --data_set bc5cdr --output_dir ./data/bc5cdr/

echo " "
echo "All"

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bc5cdr --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bc5cdr/hunflair_v2_all_aio_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_all_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bc5cdr --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bc5cdr/hunflair_v2_all_aioner_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_all_aioner_biored.txt

echo " "
echo "Chemicals"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bc5cdr --model hunflair-paper-chemical --output_file data/bc5cdr/hunflair_v1_chemical_paper.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v1_chemical_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bc5cdr --model /home/tmp/hunflair/chemical_transformers_lr_2e-5/chemical/best-model.pt --output_file data/bc5cdr/hunflair_v2_chemical_transformers_lr_2e-5.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_chemical_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bc5cdr --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bc5cdr/hunflair_v2_chemical_mtl_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_chemical_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bc5cdr --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bc5cdr/hunflair_v2_chemical_aio_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_chemical_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bc5cdr --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bc5cdr/hunflair_v2_chemical_aioner_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_chemical_aioner_biored.txt

echo " "
echo "Disease"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bc5cdr --model hunflair-paper-disease --output_file data/bc5cdr/hunflair_v1_disease_paper.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v1_disease_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bc5cdr --model /home/tmp/hunflair/disease_transformers_lr_2e-5/disease/best-model.pt --output_file data/bc5cdr/hunflair_v2_disease_transformers_lr_2e-5.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_disease_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bc5cdr --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bc5cdr/hunflair_v2_disease_mtl_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_disease_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bc5cdr --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bc5cdr/hunflair_v2_disease_aio_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_disease_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bc5cdr --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bc5cdr/hunflair_v2_disease_aioner_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bc5cdr/goldstandard.txt --pred_file ./data/bc5cdr/hunflair_v2_disease_aioner_biored.txt

echo " "

echo "---------------------"
echo "BioNLP 2013 CG"

# python generate_goldstandard.py --data_set bionlp_st_2013_cg --output_dir ./data/bionlp_st_2013_cg/

echo " "
echo "All"

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_all_aio_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_all_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_all_aioner_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_all_aioner_biored.txt

echo " "
echo "Genes"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model hunflair-paper-gene --output_file data/bionlp_st_2013_cg/hunflair_v1_gene_paper.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v1_gene_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/gene_transformers_lr_2e-5/gene/final-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_gene_transformers_lr_2e-5.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_gene_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_gene_mtl_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_gene_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_gene_aio_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_gene_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_gene_aioner_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_gene_aioner_biored.txt

echo " "
echo "Chemicals"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model hunflair-paper-chemical --output_file data/bionlp_st_2013_cg/hunflair_v1_chemical_paper.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v1_chemical_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/chemical_transformers_lr_2e-5/chemical/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_chemical_transformers_lr_2e-5.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_chemical_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_chemical_mtl_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_chemical_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_chemical_aio_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_chemical_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_chemical_aioner_biored.txt --entity_types chemicals
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_chemical_aioner_biored.txt

echo " "
echo "Diseases"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model hunflair-paper-disease --output_file data/bionlp_st_2013_cg/hunflair_v1_disease_paper.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v1_disease_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/disease_transformers_lr_2e-5/disease/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_disease_transformers_lr_2e-5.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_disease_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_disease_mtl_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_disease_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_disease_aio_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_disease_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_diseases_aioner_biored.txt --entity_types diseases
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_diseases_aioner_biored.txt

echo " "
echo "Species"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model hunflair-paper-species --output_file data/bionlp_st_2013_cg/hunflair_v1_species_paper.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v1_species_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/species_transformers_lr_2e-5/species/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_species_transformers_lr_2e-5.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_species_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_species_mtl_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_species_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_species_aio_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_species_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset bionlp_st_2013_cg --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/bionlp_st_2013_cg/hunflair_v2_species_aioner_biored.txt --entity_types species
python evaluate_annotation.py --gold_file ./data/bionlp_st_2013_cg/goldstandard.txt --pred_file ./data/bionlp_st_2013_cg/hunflair_v2_species_aioner_biored.txt

echo " "

echo "---------------------"
echo "TmVar v3.0"

# python generate_goldstandard.py --data_set tmvar_v3 --output_dir ./data/tmvar_v3/

echo " "
echo "All"

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset tmvar_v3 --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/tmvar_v3/hunflair_v2_all_aio_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/tmvar_v3/goldstandard.txt --pred_file ./data/tmvar_v3/hunflair_v2_all_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset tmvar_v3 --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/tmvar_v3/hunflair_v2_all_aioner_biored.txt --entity_types "cell lines" chemicals diseases genes species
python evaluate_annotation.py --gold_file ./data/tmvar_v3/goldstandard.txt --pred_file ./data/tmvar_v3/hunflair_v2_all_aioner_biored.txt

echo " "
echo "Genes"

echo " "
echo "Hunflair v1"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset tmvar_v3 --model hunflair-paper-gene --output_file data/tmvar_v3/hunflair_v1_gene_paper.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/tmvar_v3/goldstandard.txt --pred_file ./data/tmvar_v3/hunflair_v1_gene_paper.txt

echo " "
echo "Single All Datasets"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --input_dataset tmvar_v3 --model /home/tmp/hunflair/gene_transformers_lr_2e-5/gene/final-model.pt --output_file data/tmvar_v3/hunflair_v2_gene_transformers_lr_2e-5.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/tmvar_v3/goldstandard.txt --pred_file ./data/tmvar_v3/hunflair_v2_gene_transformers_lr_2e-5.txt

echo " "
echo "MTL Biored Only"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset tmvar_v3 --model /home/tmp/hunflair/multi_task_learning/mtl/mtl/best-model.pt --output_file data/tmvar_v3/hunflair_v2_gene_mtl_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/tmvar_v3/goldstandard.txt --pred_file ./data/tmvar_v3/hunflair_v2_gene_mtl_biored.txt

echo " "
echo "AIO"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --input_dataset tmvar_v3 --model /home/tmp/hunflair/aio/all/best-model.pt --output_file data/tmvar_v3/hunflair_v2_gene_aio_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/tmvar_v3/goldstandard.txt --pred_file ./data/tmvar_v3/hunflair_v2_gene_aio_biored.txt

echo " "
echo "AIONER"
# CUDA_VISIBLE_DEVICES=3 python predict_hunflair_v2.py --multi_task_learning --aioner --input_dataset tmvar_v3 --model /home/tmp/hunflair/aioner_adapted/mtl/best-model.pt --output_file data/tmvar_v3/hunflair_v2_gene_aioner_biored.txt --entity_types genes
python evaluate_annotation.py --gold_file ./data/tmvar_v3/goldstandard.txt --pred_file ./data/tmvar_v3/hunflair_v2_gene_aioner_biored.txt

echo " "
