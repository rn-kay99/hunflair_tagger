# HunFlair-v2 experiments

---

This repository contains the source code to reproduce the experiments conducted in ... 

### Train and predict using a HunFlair v2 model

----

To train a HunFlair model from scratch and generate its annotations, follow the instructions below.

- Create a new conda environment, install `flair` from our development branch and all other dependencies:

```
conda create --name myenv python==3.9
conda activate myenv
pip install git+https://github.com/flairNLP/flair@multi_entity_hunflair charset-normalizer==2.1.0 scispacy==0.2.5 https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.2.5/en_core_sci_sm-0.2.5.tar.gz bioc datasets
```

- Train model on a BigBio dataset, e.g., BioRED, and all its entity types. Then, generate corresponding predictions on BC5CDR:
```
python train_ner_gs_model.py --type single --path models/hunflair_v2/ --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_corpora biored --test_corpora --batch_size 16 --learning_rate 2.0e-5
python predict_hunflair_v2.py --single --input_dataset bc5cdr --model models/hunflair_v2/best-model.pt --output_file data/bc5cdr/hunflair_v2.txt
```

As a note aside: You can train other customized models using the HUNER and BigBio datasets using the `--type` option. Here is an overview over all relevant options:

```
--type
    single  Train a model on a single BigBio dataset performing training/inference on all its entity types simultaneously.
    gene    Train a model specifically for `gene` entities. Other options are `species`, `cell_line`, `chemical` and `disease`
    mtl     Train a model on multiple HUNER datasets performing training/inference on all given entity types separately.
    all     Same as MTL, but perform training/inference on all given entity types in each dataset simultaneously.
    
--train_corpora Train corpora can be passed in the two different ways given below:
    biored  Single BigBio dataset when using --type single. See BigBio for other possible datasets.
    biored  List of HUNER datasets when using other --type options. Name determined by the suffix of the class name in lowercase for each dataset supported by Hunflair, e.g., class name HUNER_GENE_BIORED => biored. Multiple datasets are passed like "--train_corpora biored craft_v4"
    
--test_corpora  List of HUNER datasets used for evaluation. Overlaps to training corpora are automatically removed. Default is "--test_corpora bioid tmvar_v3 cdr bionlp2013_cg craft_v4 pdr"

--transformer_word_embedding  Name of the Huggingface Transformers model to use
```

### Evaluation

For evaluating the prediction of a model against the gold standard run the following commands:
```
# Create gold standard
python -m generate_goldstandard --output_dir data

# Evaluate a model prediction
python -m evaluate_annotation --gold_file data/bc5cdr/goldstandard.txt --pred_file data/bc5cdr/hunflair_v2.txt 

```

### Pubtator baseline

----

To create the annotations of the PubTator baseline run the following instructions.

*BC5CDR*
```
python -m pubtator.generate_data --data_set bc5cdr --output_dir data/bc5cdr --docs_per_file 80 --exclude_splits train validation
python -m pubtator.generate_requests --input_dir data/bc5cdr --output_dir data/bc5cdr
python -m pubtator.retrieve_annotations --input_dir data/bc5cdr --output_dir data/bc5cdr
python -m pubtator.combine_results --input_dir data/bc5cdr --output_file data/bc5cdr/pubtator.txt --write_text
```

*BioID*
```
python -m pubtator.generate_data --data_set bioid --output_dir data/bioid --docs_per_file 140
python -m pubtator.generate_requests --input_dir data/bioid --output_dir data/bioid
python -m pubtator.retrieve_annotations --input_dir data/bioid --output_dir data/bioid
python -m pubtator.combine_results --input_dir data/bioid --output_file data/bioid/pubtator.txt --write_text
```

*BioNLP-ST-2013-CG*
```
python -m pubtator.generate_data --data_set bionlp_st_2013_cg --output_dir data/bionlp_st_2013_cg --docs_per_file 80 --exclude_splits train validation
python -m pubtator.generate_requests --input_dir data/bionlp_st_2013_cg --output_dir data/bionlp_st_2013_cg
python -m pubtator.retrieve_annotations --input_dir data/bionlp_st_2013_cg --output_dir data/bionlp_st_2013_cg
python -m pubtator.combine_results --input_dir data/bionlp_st_2013_cg --output_file data/bionlp_st_2013_cg/pubtator.txt --write_text
```

*CRAFT*
```
python -m pubtator.generate_data --data_set craft --output_dir data/craft --docs_per_file 2
python -m pubtator.generate_requests --input_dir data/craft --output_dir data/craft
python -m pubtator.retrieve_annotations --input_dir data/craft --output_dir data/craft
python -m pubtator.combine_results --input_dir data/craft --output_file data/craft/pubtator.txt --write_text
```

*PDR*
```
python -m pubtator.generate_data --data_set pdr --output_dir data/pdr --docs_per_file 60
python -m pubtator.generate_requests --input_dir data/pdr --output_dir data/pdr
python -m pubtator.retrieve_annotations --input_dir data/pdr --output_dir data/pdr
python -m pubtator.combine_results --input_dir data/pdr --output_file data/pdr/pubtator.txt --write_text
```

*tmvar_v3*
```
python -m pubtator.generate_data --data_set tmvar_v3 --output_dir data/tmvar_v3 --docs_per_file 15
python -m pubtator.generate_requests --input_dir data/tmvar_v3 --output_dir data/tmvar_v3
python -m pubtator.retrieve_annotations --input_dir data/tmvar_v3 --output_dir data/tmvar_v3
python -m pubtator.combine_results --input_dir data/tmvar_v3 --output_file data/tmvar_v3/pubtator.txt --write_text
```

*MedMentions*
```
python -m pubtator.generate_data --data_set medmentions --output_dir data/medmentions --docs_per_file 58
python -m pubtator.generate_requests --input_dir data/medmentions --output_dir data/medmentions
python -m pubtator.retrieve_annotations --input_dir data/medmentions --output_dir data/medmentions
python -m pubtator.combine_results --input_dir data/medmentions --output_file data/medmentions/pubtator.txt --write_text

### BERN2 baseline

#### Install BERN2

#### Start BERN2
In the script folder of your BERN2 folder, run the following command:
```
bash run_bern2.sh
```
or on windows:
```
bash run_bern2_windows.sh
```
or if you're running BERN2 on cpu only:
```
bash run_bern2_cpu.sh
```
Wait until you get a message that the server is running.

Once you are done, run the following command in the script folder:
```
bash stop_bern2.sh
```
----
*BC5CDR*
```
python -m bern.generate_data --data_set bc5cdr --output_file data/bc5cdr/text.txt --exclude_splits train validation
python -m bern.retrieve_annotations --input_file data/bc5cdr/text.txt --output_file data/bc5cdr/bern.txt
```
*BioID*
```
python -m bern.generate_data --data_set bioid --output_file data/bioid/text.txt
python -m bern.retrieve_annotations --input_file data/bioid/text.txt --output_file data/bioid/bern.txt
```
*BioNLP-ST-2013-CG*
```
python -m bern.generate_data --data_set bionlp_st_2013_cg --output_file data/bionlp_st_2013_cg/text.txt --exclude_splits train validation
python -m bern.retrieve_annotations --input_file data/bionlp_st_2013_cg/text.txt --output_file data/bionlp_st_2013_cg/bern.txt
```
*CRAFT*
```
python -m bern.generate_data --data_set craft --output_file data/craft/text.txt
python -m bern.retrieve_annotations --input_file data/craft/text.txt --output_file data/craft/bern.txt
```
*PDR*
```
python -m bern.generate_data --data_set pdr --output_file data/pdr/text.txt
python -m bern.retrieve_annotations --input_file data/pdr/text.txt --output_file data/pdr/bern.txt
```
*tmvar_v3*
```
python -m bern.generate_data --data_set tmvar_v3 --output_file data/tmvar_v3/text.txt
python -m bern.retrieve_annotations --input_file data/tmvar_v3/text.txt --output_file data/tmvar_v3/bern.txt
```
