# BC5CDR
echo "Computing results for BC5CDR"
read k

python -m evaluate_annotation --gold_file annotations/goldstandard/bc5cdr.txt --pred_file \
  annotations/pubtator/bc5cdr.txt \
  annotations/bern/bc5cdr.txt \
  annotations/stanza_craft_bc4chemd/bc5cdr.txt \
  annotations/stanza_craft_bc5cdr/bc5cdr.txt \
  annotations/stanza_craft_bionlp13cg/bc5cdr.txt \
  annotations/stanza_craft_jnlpba/bc5cdr.txt \
  annotations/stanza_craft_linneaus/bc5cdr.txt \
  annotations/stanza_craft_ncbi_disease/bc5cdr.txt \
  annotations/stanza_craft_s800/bc5cdr.txt \
  annotations/stanza_genia_bc4chemd/bc5cdr.txt \
  annotations/stanza_genia_bc5cdr/bc5cdr.txt \
  annotations/stanza_genia_bionlp13cg/bc5cdr.txt \
  annotations/stanza_genia_jnlpba/bc5cdr.txt \
  annotations/stanza_genia_linneaus/bc5cdr.txt \
  annotations/stanza_genia_ncbi_disease/bc5cdr.txt \
  annotations/stanza_genia_s800/bc5cdr.txt \
  annotations/scispacy_en_ner_bc5cdr_md/bc5cdr.tsv \
  annotations/scispacy_en_ner_bionlp13cg_md/bc5cdr.tsv \
  annotations/scispacy_en_ner_craft_md/bc5cdr.tsv \
  annotations/scispacy_en_ner_jnlpba_md/bc5cdr.tsv
read k

# BioID
echo "Computing results for BioID"
read k

python -m evaluate_annotation --gold_file annotations/goldstandard/bioid.txt --pred_file \
  annotations/pubtator/bioid.txt \
  annotations/bern/bioid.txt \
  annotations/stanza_craft_bc4chemd/bioid.txt \
  annotations/stanza_craft_bc5cdr/bioid.txt \
  annotations/stanza_craft_bionlp13cg/bioid.txt \
  annotations/stanza_craft_jnlpba/bioid.txt \
  annotations/stanza_craft_linneaus/bioid.txt \
  annotations/stanza_craft_ncbi_disease/bioid.txt \
  annotations/stanza_craft_s800/bioid.txt \
  annotations/stanza_genia_bc4chemd/bioid.txt \
  annotations/stanza_genia_bc5cdr/bioid.txt \
  annotations/stanza_genia_bionlp13cg/bioid.txt \
  annotations/stanza_genia_jnlpba/bioid.txt \
  annotations/stanza_genia_linneaus/bioid.txt \
  annotations/stanza_genia_ncbi_disease/bioid.txt \
  annotations/stanza_genia_s800/bioid.txt \
  annotations/scispacy_en_ner_bc5cdr_md/bioid.tsv \
  annotations/scispacy_en_ner_bionlp13cg_md/bioid.tsv \
  annotations/scispacy_en_ner_craft_md/bioid.tsv \
  annotations/scispacy_en_ner_jnlpba_md/bioid.tsv
read k

# BioNLP-ST-2013-CG
echo "Computing results for BioNLP-ST-2013_CG"
read k

python -m evaluate_annotation --gold_file annotations/goldstandard/bionlp_st_2013_cg.txt --pred_file \
  annotations/pubtator/bionlp_st_2013_cg.txt \
  annotations/bern/bionlp_st_2013_cg.txt \
  annotations/stanza_craft_bc4chemd/bionlp_st_2013_cg.txt \
  annotations/stanza_craft_bc5cdr/bionlp_st_2013_cg.txt \
  annotations/stanza_craft_bionlp13cg/bionlp_st_2013_cg.txt \
  annotations/stanza_craft_jnlpba/bionlp_st_2013_cg.txt \
  annotations/stanza_craft_linneaus/bionlp_st_2013_cg.txt \
  annotations/stanza_craft_ncbi_disease/bionlp_st_2013_cg.txt \
  annotations/stanza_craft_s800/bionlp_st_2013_cg.txt \
  annotations/stanza_genia_bc4chemd/bionlp_st_2013_cg.txt \
  annotations/stanza_genia_bc5cdr/bionlp_st_2013_cg.txt \
  annotations/stanza_genia_bionlp13cg/bionlp_st_2013_cg.txt \
  annotations/stanza_genia_jnlpba/bionlp_st_2013_cg.txt \
  annotations/stanza_genia_linneaus/bionlp_st_2013_cg.txt \
  annotations/stanza_genia_ncbi_disease/bionlp_st_2013_cg.txt \
  annotations/stanza_genia_s800/bionlp_st_2013_cg.txt \
  annotations/scispacy_en_ner_bc5cdr_md/bionlp_st_2013_cg.tsv \
  annotations/scispacy_en_ner_bionlp13cg_md/bionlp_st_2013_cg.tsv \
  annotations/scispacy_en_ner_craft_md/bionlp_st_2013_cg.tsv \
  annotations/scispacy_en_ner_jnlpba_md/bionlp_st_2013_cg.tsv
read k

# CRAFT
echo "Computing results for CRAFTv5"
read k

python -m evaluate_annotation --gold_file annotations/goldstandard/craft.txt --pred_file \
  annotations/pubtator/craft.txt \
  annotations/bern/craft.txt \
  annotations/stanza_craft_bc4chemd/craft.txt \
  annotations/stanza_craft_bc5cdr/craft.txt \
  annotations/stanza_craft_bionlp13cg/craft.txt \
  annotations/stanza_craft_jnlpba/craft.txt \
  annotations/stanza_craft_linneaus/craft.txt \
  annotations/stanza_craft_ncbi_disease/craft.txt \
  annotations/stanza_craft_s800/craft.txt \
  annotations/stanza_genia_bc4chemd/craft.txt \
  annotations/stanza_genia_bc5cdr/craft.txt \
  annotations/stanza_genia_bionlp13cg/craft.txt \
  annotations/stanza_genia_jnlpba/craft.txt \
  annotations/stanza_genia_linneaus/craft.txt \
  annotations/stanza_genia_ncbi_disease/craft.txt \
  annotations/stanza_genia_s800/craft.txt \
  annotations/scispacy_en_ner_bc5cdr_md/craft.tsv \
  annotations/scispacy_en_ner_bionlp13cg_md/craft.tsv \
  annotations/scispacy_en_ner_craft_md/craft.tsv \
  annotations/scispacy_en_ner_jnlpba_md/craft.tsv
read k

# PDR
echo "Computing results for PDR"
read k

python -m evaluate_annotation --gold_file annotations/goldstandard/pdr.txt --pred_file \
  annotations/pubtator/pdr.txt \
  annotations/bern/pdr.txt \
  annotations/stanza_craft_bc4chemd/pdr.txt \
  annotations/stanza_craft_bc5cdr/pdr.txt \
  annotations/stanza_craft_bionlp13cg/pdr.txt \
  annotations/stanza_craft_jnlpba/pdr.txt \
  annotations/stanza_craft_linneaus/pdr.txt \
  annotations/stanza_craft_ncbi_disease/pdr.txt \
  annotations/stanza_craft_s800/pdr.txt \
  annotations/stanza_genia_bc4chemd/pdr.txt \
  annotations/stanza_genia_bc5cdr/pdr.txt \
  annotations/stanza_genia_bionlp13cg/pdr.txt \
  annotations/stanza_genia_jnlpba/pdr.txt \
  annotations/stanza_genia_linneaus/pdr.txt \
  annotations/stanza_genia_ncbi_disease/pdr.txt \
  annotations/stanza_genia_s800/pdr.txt \
  annotations/scispacy_en_ner_bc5cdr_md/pdr.tsv \
  annotations/scispacy_en_ner_bionlp13cg_md/pdr.tsv \
  annotations/scispacy_en_ner_craft_md/pdr.tsv \
  annotations/scispacy_en_ner_jnlpba_md/pdr.tsv
read k

# tmvar_v3
echo "Computing results for tmvar_v3"
read k

python -m evaluate_annotation --gold_file annotations/goldstandard/tmvar_v3.txt --pred_file \
  annotations/pubtator/tmvar_v3.txt \
  annotations/bern/tmvar_v3.txt \
  annotations/stanza_craft_bc4chemd/tmvar_v3.txt \
  annotations/stanza_craft_bc5cdr/tmvar_v3.txt \
  annotations/stanza_craft_bionlp13cg/tmvar_v3.txt \
  annotations/stanza_craft_jnlpba/tmvar_v3.txt \
  annotations/stanza_craft_linneaus/tmvar_v3.txt \
  annotations/stanza_craft_ncbi_disease/tmvar_v3.txt \
  annotations/stanza_craft_s800/tmvar_v3.txt \
  annotations/stanza_genia_bc4chemd/tmvar_v3.txt \
  annotations/stanza_genia_bc5cdr/tmvar_v3.txt \
  annotations/stanza_genia_bionlp13cg/tmvar_v3.txt \
  annotations/stanza_genia_jnlpba/tmvar_v3.txt \
  annotations/stanza_genia_linneaus/tmvar_v3.txt \
  annotations/stanza_genia_ncbi_disease/tmvar_v3.txt \
  annotations/stanza_genia_s800/tmvar_v3.txt \
  annotations/scispacy_en_ner_bc5cdr_md/tmvar_v3.tsv \
  annotations/scispacy_en_ner_bionlp13cg_md/tmvar_v3.tsv \
  annotations/scispacy_en_ner_craft_md/tmvar_v3.tsv \
  annotations/scispacy_en_ner_jnlpba_md/tmvar_v3.tsv

