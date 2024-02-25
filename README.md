# Bachelor Thesis Project

This repository contains the code for the experiments done for the bachelor thesis. The thesis document can be found in the file `submissions/Bachelorarbeit.pdf`. \
In addition, you can find the project's exposè in `submissions/Expose.pdf`.

## Installation guide
**Requirements:**
- Python 3.8 or higher

**Note**: It's recommended to use a virtual environment to avoid conflicts with other projects.

To install the Flair library, you can use pip:
```bash
cd hunflair_tagger/flair

pip install .
```
Ensure that ```/hunflair_tagger/flair``` is included in the Python path so that Python can locate the directory.
```bash
export PYTHONPATH=$PYTHONPATH:/hunflair_tagger
```
Scispacy should be installed:
```bash
pip install scispacy==0.5.1

pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.5.1/en_core_sci_sm-0.5.1.tar.gz
```

**Note:** If you are using an M1 Mac and have problems installing nmslib, try running the following command:
```bash
CFLAGS="-mavx -DWARN(a)=(a)" pip install nmslib
```

## How to train a model
To train and predict using the NER model, execute the ```train.sh``` script in the main directory. The results of the training process will be stored in the ```/models``` directory. \
Ensure you have the required dependencies installed before running. \
The command has the following format:
```bash
./train.sh <corpus> <model>
```
* ```<corpus>```: Select from three options: **biored**, **tmvar3**, or **osiris**.
* ```<model>```: Choose one of three options: **bilstm_crf**, **biolinkbert**, or **fine_grained_biolinkbert**. \
Example call: ```./train.sh tmvar3 bilstm_crf```

**Note:** Make sure the script has the necessary permissions. \
You can grant the necessary permissions by executing the following command in the terminal:
```bash
chmod +x train.sh
```

## Flair
The Flair library, which serves as the foundation for this project, is located in the `/flair` directory. \
The code is based on the original Flair code which can be found at https://github.com/flairNLP/flair/tree/master/flair. \
Certain modifications have been made to enable the NER tagger to work with genetic variations.\
Under `/hunflair-v2-experiments-main` the implementation of Hunflair 2 can be found, which also contains the integration of the BiolinkBERT model.
<!-- For information about the changes, please have a look at `/flair/README.md`. -->

## Datasets
The datasets used in this project are stored in the `/data` directory. The following corpora are included:

- **Biored**: [BioRED: A Rich Biomedical Relation Extraction Dataset](https://doi.org/10.1093/bib/bbac282)
- **Tmvar3**: [tmVar 3.0: an improved variant concept recognition and normalization tool](https://doi.org/10.1093/bioinformatics/btac537)
- **Osiris**: [OSIRISv1.2: a named entity recognition system for sequence variants
  of genes in biomedical literature.](http://dx.doi.org/10.1186/1471-2105-9-84)

The `X_train.txt` and `X_test.txt` files within each corpus directory contain the raw, unprocessed data. \
The `mod_X_train.txt` and `mod_X_test.txt` files contain the modified data, where data points not representing genetic variations have been removed. \
The `train.json` and `test.json` files within each corpus contain data for training and testing the fine-grained BioLinkBERT model, which were parsed using custom regular expressions.

## Utils
The `/utils` directory contains Python scripts and helper functions specifically designed to process the corpus and prepare the data for training the NER model. Here are the main components: