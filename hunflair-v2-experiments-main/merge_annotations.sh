mkdir -p annotations/hunflair-transformers/

python -m merge_annotations --output_file annotations/hunflair-transformers/bc5cdr.txt --pred_files \
  annotations/hunflair-transformers-chemical/bc5cdr.txt \
  annotations/hunflair-transformers-disease/bc5cdr.txt

python -m merge_annotations --output_file annotations/hunflair-transformers/bioid.txt --pred_files \
  annotations/hunflair-transformers-chemical/bioid.txt \
  annotations/hunflair-transformers-gene/bioid.txt \
  annotations/hunflair-transformers-species/bioid.txt

python -m merge_annotations --output_file annotations/hunflair-transformers/bionlp_st_2013_cg.txt --pred_files \
  annotations/hunflair-transformers-chemical/bionlp_st_2013_cg.txt \
  annotations/hunflair-transformers-disease/bionlp_st_2013_cg.txt \
  annotations/hunflair-transformers-gene/bionlp_st_2013_cg.txt \
  annotations/hunflair-transformers-species/bionlp_st_2013_cg.txt

python -m merge_annotations --output_file annotations/hunflair-transformers/craft.txt --pred_files \
  annotations/hunflair-transformers-chemical/craft.txt \
  annotations/hunflair-transformers-disease/craft.txt \
  annotations/hunflair-transformers-gene/craft.txt \
  annotations/hunflair-transformers-species/craft.txt

# ---------------------------------------------------------------------------------------------------------
mkdir -p annotations/hunflair-paper/

python -m merge_annotations --output_file annotations/hunflair-paper/bc5cdr.txt --pred_files \
  annotations/hunflair-paper-chemical/bc5cdr.txt \
  annotations/hunflair-paper-disease/bc5cdr.txt

python -m merge_annotations --output_file annotations/hunflair-paper/bioid.txt --pred_files \
  annotations/hunflair-paper-chemical/bioid.txt \
  annotations/hunflair-paper-gene/bioid.txt \
  annotations/hunflair-paper-species/bioid.txt

python -m merge_annotations --output_file annotations/hunflair-paper/bionlp_st_2013_cg.txt --pred_files \
  annotations/hunflair-paper-chemical/bionlp_st_2013_cg.txt \
  annotations/hunflair-paper-disease/bionlp_st_2013_cg.txt \
  annotations/hunflair-paper-gene/bionlp_st_2013_cg.txt \
  annotations/hunflair-paper-species/bionlp_st_2013_cg.txt

python -m merge_annotations --output_file annotations/hunflair-paper/craft.txt --pred_files \
  annotations/hunflair-paper-chemical/craft.txt \
  annotations/hunflair-paper-disease/craft.txt \
  annotations/hunflair-paper-gene/craft.txt \
  annotations/hunflair-paper-species/craft.txt
