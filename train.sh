#!/bin/bash

# Description:
# This script performs a training, prediction, and consolidation process for a Named Entity Recognition (NER) model.
# It generates a unique ID, conducts training with a specified 'corpora', makes predictions, and consolidates annotations.
# All outputs and generated files are stored in a specific subfolder.

# Usage:
# Use the command "chmod +x train.sh" to give the file the right to be executed.
# ./train.sh [corpora] [model_type]
# Example: ./train.sh tmvar3 bilstm_crf
# Replace [corpora] with 'biored', 'tmvar3' or 'osiris' and [model_type] with 'bilstm_crf', 'biolinkbert', or 'fine_grained_biolinkbert'.


# Check whether two parameters have been transferred
if [ "$#" -ne 2 ]; then
    echo "Error: Exactly two parameters 'corpora' and 'model_type' must be passed."
    exit 1
fi

corpora=$1
model_type=$2

# Generate a random 4-digit ID that is used for unique model name and random seed
# id=$(printf "%04d" $(( RANDOM % 10000 )))
id=1234

# If the "fine_grained_biolinkbert" is selected, the corpora will be set to the fine grained variant of the corpora.
if [ "$model_type" == "fine_grained_biolinkbert" ]; then
    if [ "$corpora" == "biored" ]; then
        corpora="fine_grained_biored"
    elif [ "$corpora" == "tmvar3" ]; then
        corpora="fine_grained_tmvar3"
        echo "TEST"
    elif [ "$corpora" == "osiris" ]; then
        corpora="fine_grained_osiris"
    fi
fi

# Copy the fine-grained versions of the corpora into the directory where Flair expects them
current_path=$(pwd)
fine_grained_biored_target_path="$HOME/.flair/datasets/fine_grained_biored/json_data"
fine_grained_tmvar3_target_path="$HOME/.flair/datasets/fine_grained_tmvar3/json_data"
fine_grained_osiris_target_path="$HOME/.flair/datasets/fine_grained_osiris/json_data"
mkdir -p "$fine_grained_biored_target_path"
mkdir -p "$fine_grained_tmvar3_target_path"
mkdir -p "$fine_grained_osiris_target_path"
cp -r "$current_path/data/biored/fine_grained_data/"* "$fine_grained_biored_target_path"
cp -r "$current_path/data/tmvar3/fine_grained_data/"* "$fine_grained_tmvar3_target_path"
cp -r "$current_path/data/osiris/fine_grained_data/"* "$fine_grained_osiris_target_path"

echo "Generated ID: $id"

# Set and create output directory
output_subdir="models/${model_type}/${corpora}_${id}"
mkdir -p $output_subdir

# Execute the corresponding training function based on the selected corpora and model
if [ "$model_type" == "bilstm_crf" ]; then
    echo "Training of the BiLSTM-CRF starts..."
    python hunflair-v2-experiments-main/train_ner_gs_model.py --type variation --path models/${corpora}_${id} --train_corpora ${corpora} --test_corpora --batch_size 16 --learning_rate 2.0e-5 --max_epochs 200 --seed ${id} > $output_subdir/train.log
elif [ "$model_type" == "biolinkbert" ]; then
    echo "Training of the BioLinkBERT starts..."
    python hunflair-v2-experiments-main/train_ner_gs_model.py --type variation --path models/${corpora}_${id} --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_corpora ${corpora} --test_corpora --batch_size 16 --learning_rate 2.0e-5 --max_epochs 200 --seed ${id} > $output_subdir/train.log
elif [ "$model_type" == "fine_grained_biolinkbert" ]; then
    echo "Deleting old prediction files..."
    rm -f /vol/fob-vol4/mi17/steinkay/.flair/datasets/${corpora}/{training.log,train.conll,test.conll,loss.tsv,final-model.pt,dev.tsv,best-model.pt}
    echo "Training of the Fine-Grained BioLinkBERT starts..."
    python hunflair-v2-experiments-main/train_ner_gs_model.py --type fine_grained_variation --path models/${corpora}_${id} --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_corpora ${corpora} --test_corpora ${corpora} --batch_size 16 --learning_rate 2.0e-6 --max_epochs 200 --seed ${id} > $output_subdir/train.log
else
    echo Invalid model selection. Select "bilstm_crf", "biolinkbert" or "fine_grained_biolinkbert".
    exit 1
fi
echo "Training completed. Log file is located in $output_subdir/train.log"

best_model_file="$HOME/.flair/datasets/${corpora}/best-model.pt"
final_model_file="$HOME/.flair/datasets/${corpora}/final-model.pt"
if [ -f "$best_model_file" ]; then
    mv "$best_model_file" "$output_subdir/"
fi
if [ -f "$final_model_file" ]; then
    mv "$final_model_file" "$output_subdir/"
fi

# Make prediction
echo "Prediction with the model starts..."
python hunflair-v2-experiments-main/predict_hunflair_v2.py --single --input_dataset ${corpora} --model models/${model_type}/${corpora}_${id}/best-model.pt --output_file $output_subdir/pred.txt > $output_subdir/pred.log
echo "Prediction completed. Log file is located in $output_subdir/predict.log"