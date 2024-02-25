mkdir -p overlaps/bc5cdr

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bc5cdr.txt \
  --pred_file annotations/pubtator/bc5cdr.txt \
       annotations/bern/bc5cdr_bern_results.txt \
       annotations/hunflair-paper/bc5cdr.txt \
       annotations/hunflair-transformers-aio/bc5cdr.txt \
  --target tp \
  --output_file overlaps/bc5cdr/tp_all_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bc5cdr.txt \
  --pred_file annotations/pubtator/bc5cdr.txt \
       annotations/bern/bc5cdr_bern_results.txt \
       annotations/hunflair-paper/bc5cdr.txt \
       annotations/hunflair-transformers-aio/bc5cdr.txt \
  --entity_type disease \
  --target tp \
  --output_file overlaps/bc5cdr/tp_disease_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bc5cdr.txt \
  --pred_file annotations/pubtator/bc5cdr.txt \
       annotations/bern/bc5cdr_bern_results.txt \
       annotations/hunflair-paper/bc5cdr.txt \
       annotations/hunflair-transformers-aio/bc5cdr.txt \
  --entity_type chemical \
  --target tp \
  --output_file overlaps/bc5cdr/tp_chemical_nen_tools.png

#python -m compute_prediction_overlap \
#  --gold_file annotations/goldstandard/bc5cdr.txt \
#  --pred_file annotations/pubtator/bc5cdr.txt \
#       annotations/bern/bc5cdr_bern_results.txt \
#       annotations/hunflair-paper/bc5cdr.txt \
#       annotations/hunflair-transformers-aio/bc5cdr.txt \
#  --target fn \
#  --output_file overlaps/bc5cdr/fn_all_nen_tools.png
#
#python -m compute_prediction_overlap \
#  --gold_file annotations/goldstandard/bc5cdr.txt \
#  --pred_file annotations/pubtator/bc5cdr.txt \
#       annotations/bern/bc5cdr_bern_results.txt \
#       annotations/hunflair-paper/bc5cdr.txt \
#       annotations/hunflair-transformers-aio/bc5cdr.txt \
#  --entity_type disease \
#  --target fn \
#  --output_file overlaps/bc5cdr/fn_disease_nen_tools.png


##
## -----------------------------------------------------------
##

mkdir -p overlaps/bioid

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bioid.txt \
  --pred_file annotations/pubtator/bioid.txt \
       annotations/bern/bioid_bern_results.txt \
       annotations/hunflair-paper/bioid.txt \
       annotations/hunflair-transformers-aio/bioid.txt \
  --target tp \
  --output_file overlaps/bioid/tp_all_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bioid.txt \
  --pred_file annotations/pubtator/bioid.txt \
       annotations/bern/bioid_bern_results.txt \
       annotations/hunflair-paper/bioid.txt \
       annotations/hunflair-transformers-aio/bioid.txt \
  --target tp \
  --entity_type chemical \
  --output_file overlaps/bioid/tp_chemical_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bioid.txt \
  --pred_file annotations/pubtator/bioid.txt \
       annotations/bern/bioid_bern_results.txt \
       annotations/hunflair-paper/bioid.txt \
       annotations/hunflair-transformers-aio/bioid.txt \
  --target tp \
  --entity_type gene \
  --output_file overlaps/bioid/tp_gene_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bioid.txt \
  --pred_file annotations/pubtator/bioid.txt \
       annotations/bern/bioid_bern_results.txt \
       annotations/hunflair-paper/bioid.txt \
       annotations/hunflair-transformers-aio/bioid.txt \
  --target tp \
  --entity_type chemical \
  --output_file overlaps/bioid/tp_species_nen_tools.png


##
## -----------------------------------------------------------
##

mkdir -p overlaps/bionlp_st_2013_cg

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bionlp_st_2013_cg.txt \
  --pred_file annotations/pubtator/bionlp_st_2013_cg.txt \
       annotations/bern/bionlp_bern_results.txt \
       annotations/hunflair-paper/bionlp_st_2013_cg.txt \
       annotations/hunflair-transformers-aio/bionlp_st_2013_cg.txt \
  --target tp \
  --output_file overlaps/bionlp_st_2013_cg/tp_all_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bionlp_st_2013_cg.txt \
  --pred_file annotations/pubtator/bionlp_st_2013_cg.txt \
       annotations/bern/bionlp_bern_results.txt \
       annotations/hunflair-paper/bionlp_st_2013_cg.txt \
       annotations/hunflair-transformers-aio/bionlp_st_2013_cg.txt \
  --target tp \
  --entity_type chemical \
  --output_file overlaps/bionlp_st_2013_cg/tp_chemical_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bionlp_st_2013_cg.txt \
  --pred_file annotations/pubtator/bionlp_st_2013_cg.txt \
       annotations/bern/bionlp_bern_results.txt \
       annotations/hunflair-paper/bionlp_st_2013_cg.txt \
       annotations/hunflair-transformers-aio/bionlp_st_2013_cg.txt \
  --target tp \
  --entity_type disease \
  --output_file overlaps/bionlp_st_2013_cg/tp_disease_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bionlp_st_2013_cg.txt \
  --pred_file annotations/pubtator/bionlp_st_2013_cg.txt \
       annotations/bern/bionlp_bern_results.txt \
       annotations/hunflair-paper/bionlp_st_2013_cg.txt \
       annotations/hunflair-transformers-aio/bionlp_st_2013_cg.txt \
  --target tp \
  --entity_type gene \
  --output_file overlaps/bionlp_st_2013_cg/tp_gene_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/bionlp_st_2013_cg.txt \
  --pred_file annotations/pubtator/bionlp_st_2013_cg.txt \
       annotations/bern/bionlp_bern_results.txt \
       annotations/hunflair-paper/bionlp_st_2013_cg.txt \
       annotations/hunflair-transformers-aio/bionlp_st_2013_cg.txt \
  --target tp \
  --entity_type species \
  --output_file overlaps/bioid/tp_species_nen_tools.png

##
## -----------------------------------------------------------
##

mkdir -p overlaps/craft

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/craft.txt \
  --pred_file annotations/pubtator/craft.txt \
       annotations/bern/craft_bern_results.txt \
       annotations/hunflair-paper/craft.txt \
       annotations/hunflair-transformers-aio/craft.txt \
  --target tp \
  --output_file overlaps/craft/tp_all_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/craft.txt \
  --pred_file annotations/pubtator/craft.txt \
       annotations/bern/craft_bern_results.txt \
       annotations/hunflair-paper/craft.txt \
       annotations/hunflair-transformers-aio/craft.txt \
  --target tp \
  --entity_type chemical \
  --output_file overlaps/craft/tp_chemical_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/craft.txt \
  --pred_file annotations/pubtator/craft.txt \
       annotations/bern/craft_bern_results.txt \
       annotations/hunflair-paper/craft.txt \
       annotations/hunflair-transformers-aio/craft.txt \
  --target tp \
  --entity_type disease \
  --output_file overlaps/craft/tp_disease_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/craft.txt \
  --pred_file annotations/pubtator/craft.txt \
       annotations/bern/craft_bern_results.txt \
       annotations/hunflair-paper/craft.txt \
       annotations/hunflair-transformers-aio/craft.txt \
  --target tp \
  --entity_type gene \
  --output_file overlaps/craft/tp_gene_nen_tools.png

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/craft.txt \
  --pred_file annotations/pubtator/craft.txt \
       annotations/bern/craft_bern_results.txt \
       annotations/hunflair-paper/craft.txt \
       annotations/hunflair-transformers-aio/craft.txt \
  --target tp \
  --entity_type species \
  --output_file overlaps/craft/tp_species_nen_tools.png

##
## -----------------------------------------------------------
##

mkdir -p overlaps/pdr

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/pdr.txt \
  --pred_file annotations/pubtator/pdr.txt \
       annotations/bern/pdr_bern_results.txt \
       annotations/hunflair-paper-disease/pdr.txt \
       annotations/hunflair-transformers-aio/pdr.txt \
  --target tp \
  --entity_type disease \
  --output_file overlaps/pdr/tp_disease_nen_tools.png


##
## -----------------------------------------------------------
##

mkdir -p overlaps/tmvar_v3

python -m compute_prediction_overlap \
  --gold_file annotations/goldstandard/tmvar_v3.txt \
  --pred_file annotations/pubtator/tmvar_v3.txt \
       annotations/bern/tmvar_v3_bern_results.txt \
       annotations/hunflair-paper-gene/tmvar_v3.txt \
       annotations/hunflair-transformers-aio/tmvar_v3.txt \
  --target tp \
  --entity_type gene \
  --output_file overlaps/tmvar_v3/tp_gene_nen_tools.png
