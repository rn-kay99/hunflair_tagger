# Bachelor Thesis Project

This repository contains the code for the experiments done for the bachelor thesis. The thesis document can be found in the file `submissions/Bachelorarbeit.pdf`. \
In addition, you can find the project's exposè in `submissions/Expose.pdf`.

## Installation guide
**Requirements:**
- Python 3.8 or higher

**Note**: It's recommended to use a virtual environment to avoid conflicts with other projects. \
You can create a virtual environment with:
```bash
python -m venv venv
```

To install the Flair library, you can use pip:
```bash
cd hunflair-v2-experiments-main/flair
pip install .
```
Then install the dependencies for hunflair-v2-experiments-main:
```bash
cd hunflair-v2-experiments-main
pip install -r requirements.txt
```

**Note:** If you are using an M1 Mac and have problems installing nmslib, try running the following command:
```bash
CFLAGS="-mavx -DWARN(a)=(a)" pip install nmslib
```

## How to train a model
To train and predict using the NER model, execute the ```train.sh``` script in the main directory. The results of the training process will be stored in the ```/models``` directory. \
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
The Flair library, which serves as the foundation for this project, is located in the `/hunflair-v2-experiments-main/flair` directory. \
The code is based on the original Flair code which can be found at https://github.com/flairNLP/flair/tree/master/flair. For this project, Flair version 0.12.2 was used.\
Certain modifications have been made to enable the NER tagger to work with genetic variations.\
Under `/hunflair-v2-experiments-main` the implementation of Hunflair 2 can be found, which also contains the integration of the BiolinkBERT model.
<!-- For information about the changes, please have a look at `/flair/README.md`. -->

## Datasets
The datasets used in this project are stored in the `/data` directory. The following corpora are included:

- **Biored**: [BioRED: A Rich Biomedical Relation Extraction Dataset](https://doi.org/10.1093/bib/bbac282)
- **TmVar3**: [tmVar 3.0: an improved variant concept recognition and normalization tool](https://doi.org/10.1093/bioinformatics/btac537)
- **Osiris**: [OSIRISv1.2: a named entity recognition system for sequence variants
  of genes in biomedical literature.](http://dx.doi.org/10.1186/1471-2105-9-84)

The `X_train.txt` and `X_test.txt` files within each corpus directory contain the raw, unprocessed data. \
The `mod_X_train.txt` and `mod_X_test.txt` files contain the modified data, where data points not representing genetic variations have been removed. \
The `train.json` and `test.json` files within each corpus contain data for training and testing the fine-grained BioLinkBERT model, which were parsed using custom regular expressions.

## Utils
The `/utils` directory contains Python scripts and helper functions specifically designed to process the corpus and prepare the data for training the NER model. Here are the main components:
- `fine_grained_corpus_parser.py`: This script takes an annotated corpus as input and uses regular expressions to parse the corpus, extracting fine-grained annotations.
- `merge_fine_grained_entities.py`: The script merges the fine-grained entities. 

## Results
The models BILSTM-CRF, BioLinkBERT and fine-grained BioLinkBERT were trained and tested on the three corpora, with the following results.

Performance of the models on the BioRed corpus:
| Modell                               | Precision ($\pm$ std)       | Recall ($\pm$ std)      | F1-Score ($\pm$ std)           |
| ------------------------------------ | --------------------------- | ----------------------- | ------------------------------ |
| PubMedBERT-CRF                       | 0,847                       | **0,871**               | 0,859                          |
| BiLSTM-CRF                           | 0,835 ($\pm$ 0.05)          | 0,783 ($\pm$ 0.04)      | 0,808 ($\pm$ 0.04)             |
| BioLinkBERT                          | **0,859** ($\pm$ 0.02)     | 0,866 ($\pm$ 0.03)      | **0,863**  ($\pm$ 0.01)       |
| Fine-grained BioLinkBERT             | 0,657 ($\pm$ 0.06)          | 0,817 ($\pm$ 0.03)      | 0,706 ($\pm$ 0.04)             |

\
Performance of the models on the tmVar3 corpus:

| Modell                   | Precision ($\pm$ std)       | Recall ($\pm$ std)      | F1-Score ($\pm$ std)  |
| ------------------------ | --------------------------- | ----------------------- | ---------------------- |
| tmVar 3.0                | 0,940                       | **0,889**               | **0,914**              |
| BiLSTM-CRF               | 0,856 ($\pm$ 0.03)          | 0,659 ($\pm$ 0.05)      | 0,744 ($\pm$ 0.03)     |
| BioLinkBERT              | **0,954** ($\pm$ 0.05)     | 0,682 ($\pm$ 0.04)      | 0,795 ($\pm$ 0.04)     |
| Fine-grained BioLinkBERT | 0,644  ($\pm$ 0.05)         | 0,758 ($\pm$ 0.06)      | 0,696 ($\pm$ 0.06)     |

\
Performance of the models on the Osiris corpus:

| Modell                   | Precision ($\pm$ std)  | Recall ($\pm$ std)      | F1-Score ($\pm$ std)   |
| ------------------------ | ---------------------- | ----------------------- | ---------------------- |
| tmVar 3.0                | **0,986**              | 0,850                   | **0,913**              |
| BiLSTM-CRF               | 0,859 ($\pm$ 0.04)     | 0,785 ($\pm$ 0.05)      | 0,820 ($\pm$ 0.02)     |
| BioLinkBERT              | 0,897 ($\pm$ 0.02)     | **0,865** ($\pm$ 0.03) | 0.899 ($\pm$ 0.03)     |
| Fine-grained BioLinkBERT | 0,637 ($\pm$ 0.05)     | 0,714 ($\pm$ 0.04)      | 0,673 ($\pm$ 0.04)     |
