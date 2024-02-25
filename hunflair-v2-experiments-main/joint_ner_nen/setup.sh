#!/usr/bin/env bash

DIRECTORY="$1"

if [[ -z "$DIRECTORY" ]]; then
    echo "Error: please specify directory where all data will be stored"
    echo "Usage: setup.sh <directory>"
    exit 1
fi


if [[ ! -f "$DIRECTORY/umls-2017AA-full.zip" ]]; then
    echo "Error: file umls-2017AA-full.zip not found!"
    echo "Error: You need to obtain a copy of UMLS 2017AA full release file and place it in this directory!"
    exit 1
fi

if [[ ! -f "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF" ]]; then
    unzip -o "$DIRECTORY/umls-2017AA-full.zip" -d "$DIRECTORY"
    # poorly disguised zip files...
    unzip -o "$DIRECTORY/2017AA-full/2017aa-1-meta.nlm" -d "$DIRECTORY/2017AA-full"
    mkdir -p "$DIRECTORY/umls"
    gunzip -c "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF.aa.gz" > "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF.aa"
    gunzip -c "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF.ab.gz" > "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF.ab"
    echo "Merge MRCONSO.RFF.aa MRCONSO.RFF.ab into MRCONSO.RFF"
    cat "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF.aa" "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF.ab" > "$DIRECTORY/2017AA-full/2017AA/META/MRCONSO.RRF"
fi

echo "Download CTD vocabularies"
wget -nc -c -P "$DIRECTORY" "http://ctdbase.org/reports/CTD_chemicals.tsv.gz"
gunzip -c "$DIRECTORY/CTD_chemicals.tsv.gz" >  "$DIRECTORY/CTD_chemicals.tsv"
wget -nc -c -P "$DIRECTORY" "http://ctdbase.org/reports/CTD_diseases.tsv.gz"
gunzip -c "$DIRECTORY/CTD_diseases.tsv.gz" > "$DIRECTORY/CTD_diseases.tsv"

echo "Download MONDO ontology"
wget -nc -c -P "$DIRECTORY" "http://purl.obolibrary.org/obo/mondo.obo"
