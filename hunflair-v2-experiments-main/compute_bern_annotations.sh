echo "Annotating bc5cdr"
python -m bern.generate_data --data_set bc5cdr --output_file output_annotations/bern/bc5cdr_text.txt --exclude_splits train validation
python -m bern.retrieve_annotations --input_file output_annotations/bern/bc5cdr_text.txt --output_file output_annotations/bern/bc5cdr.txt

echo "Annotating bioid"
python -m bern.generate_data --data_set bioid --output_file output_annotations/bern/bioid_text.txt
python -m bern.retrieve_annotations --input_file output_annotations/bern/bioid_text.txt --output_file output_annotations/bern/bioid.txt

echo "Annotating bionlp_st_2013_cg"
python -m bern.generate_data --data_set bionlp_st_2013_cg --output_file output_annotations/bern/bionlp_st_2013_cg_text.txt --exclude_splits train validation
python -m bern.retrieve_annotations --input_file output_annotations/bern/bionlp_st_2013_cg_text.txt --output_file output_annotations/bern/bionlp_st_2013_cg.txt

echo "Annotating craft"
python -m bern.generate_data --data_set craft --output_file output_annotations/bern/craft_text.txt
python -m bern.retrieve_annotations --input_file output_annotations/bern/craft_text.txt --output_file output_annotations/bern/craft.txt

echo "Annotating pdr"
python -m bern.generate_data --data_set pdr --output_file output_annotations/bern/pdr_text.txt
python -m bern.retrieve_annotations --input_file output_annotations/bern/pdr_text.txt --output_file output_annotations/bern/pdr.txt

echo "Annotating tmvar_v3"
python -m bern.generate_data --data_set tmvar_v3 --output_file output_annotations/bern/tmvar_v3_text.txt
python -m bern.retrieve_annotations --input_file output_annotations/bern/tmvar_v3_text.txt --output_file output_annotations/bern/tmvar_v3.txt

echo "Annotating MedMentions"
python -m bern.generate_data --data_set medmentions --output_file output_annotations/bern/medmentions_text.txt
python -m bern.retrieve_annotations --input_file output_annotations/bern/medmentions_text.txt --output_file output_annotations/bern/medmentions.txt
