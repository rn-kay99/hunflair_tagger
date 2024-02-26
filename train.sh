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
id=$(printf "%04d" $(( RANDOM % 10000 )))

# If the "fine_grained_biolinkbert" is selected, the corpora will be set to the fine grained variant of the corpora.
if [ "$model_type" == "fine_grained_biolinkbert" ]; then
    corpora_saving_name="fine_grained_$corpora"
else
    corpora_saving_name="bigbio-$corpora"
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
    rm -f $HOME/.flair/datasets/${corpora_saving_name}/{training.log,train.conll,test.conll,loss.tsv,final-model.pt,dev.tsv,best-model.pt}
    echo "Training of the Fine-Grained BioLinkBERT starts..."
    python hunflair-v2-experiments-main/train_ner_gs_model.py --type fine_grained_variation --path models/${corpora}_${id} --transformer_word_embedding "michiyasunaga/BioLinkBERT-base" --train_corpora ${corpora_saving_name} --test_corpora ${corpora_saving_name} --batch_size 16 --learning_rate 2.0e-5 --max_epochs 200 --seed ${id} > $output_subdir/train.log
else
    echo Invalid model selection. Select "bilstm_crf", "biolinkbert" or "fine_grained_biolinkbert".
    exit 1
fi
echo "Training completed."

# copy best-model and final-model into output directory
best_model_file="$HOME/.flair/datasets/${corpora_saving_name}/best-model.pt"
final_model_file="$HOME/.flair/datasets/${corpora_saving_name}/final-model.pt"
if [ "$model_type" == "bilstm_crf" ] || [ "$model_type" == "biolinkbert" ]; then
    best_model_file="$HOME/.flair/datasets/${corpora_saving_name}/scispacysentencesplitter_core_sci_sm_0.5.1_scispacytokenizer_core_sci_sm_0.5.1/best-model.pt"
    final_model_file="$HOME/.flair/datasets/${corpora_saving_name}/scispacysentencesplitter_core_sci_sm_0.5.1_scispacytokenizer_core_sci_sm_0.5.1/final-model.pt"
fi

if [ -f "$best_model_file" ]; then
    mv "$best_model_file" "$output_subdir/"
fi
if [ -f "$final_model_file" ]; then
    mv "$final_model_file" "$output_subdir/"
fi

# Make prediction
echo "Prediction with the model starts..."
python hunflair-v2-experiments-main/predict_hunflair_v2.py --single --input_dataset ${corpora} --model models/${model_type}/${corpora}_${id}/best-model.pt --output_file $output_subdir/pred.txt > $output_subdir/pred.log
python utils/clean_prediction.py --pred_file  models/${model_type}/${corpora}_${id}/pred.txt --output_file models/${model_type}/${corpora}_${id}/tmp_pred.txt
mv models/${model_type}/${corpora}_${id}/tmp_pred.txt models/${model_type}/${corpora}_${id}/pred.txt
if [ "$model_type" == "fine_grained_biolinkbert" ]; then
    python utils/merge_fine_grained_entities.py --input_file models/${model_type}/${corpora}_${id}/pred.txt --output_file models/${model_type}/${corpora}_${id}/tmp_pred.txt
    mv models/${model_type}/${corpora}_${id}/tmp_pred.txt models/${model_type}/${corpora}_${id}/pred.txt
fi
echo "Prediction completed."

# Evaluate model prediction
echo "Evaluation of the prediction starts..."
python utils/evaluate_prediction.py --pred_file models/${model_type}/${corpora}_${id}/pred.txt --gold_file data/${corpora}/mod_${corpora}_test.txt > models/${model_type}/${corpora}_${id}/eval.txt
echo "Evaluation completed."