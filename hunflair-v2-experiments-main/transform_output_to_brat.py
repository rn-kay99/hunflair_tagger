from pathlib import Path
import bconv
from tqdm import tqdm

### This script converts the output of the PubTator annotator to the brat format.
### We have to comment out line 324 in bconv/doc/document.py to make it work.
### `self._validate_spans` will throw an error if the annotated spans are not correct.

def hotfix_file(f):
    """
    Applies a hotfix to the file to make it compatible with the brat converter.
    Introduces a newline between documents.
    """
    current_pmid = None
    lines = []
    for line in f:
        if current_pmid is None:
            current_pmid = line.split('|')[0]
        if line.startswith(current_pmid):
            lines.append(line)
        else:
            if line.strip():
                lines.append('\n')
            current_pmid = line.split('|')[0]
            lines.append(line)

    return ''.join(lines)


if __name__ == '__main__':
    input_folder = Path('output_annotations')
    output_folder = Path('output_annotations_brat')
    output_folder.mkdir(exist_ok=True)


    for pubtator_file in tqdm(list(input_folder.glob("stanza*/*.txt"))):
        if not "craft" in pubtator_file.name:
            continue
        doc_id_to_brat_doc = {}
        file_name = pubtator_file.name
        model_name = pubtator_file.parent.name
        with pubtator_file.open('r', encoding='utf8') as f_pubtator:
            output_model_folder = output_folder / model_name / file_name
            output_model_folder.mkdir(exist_ok=True, parents=True)
            hotfixed_str = hotfix_file(f_pubtator)
            collection = bconv.loads(hotfixed_str, fmt="pubtator")
            pubtator_elem = collection[0]
            for doc in collection:
                ann_file = output_model_folder / f"{doc.id}.ann"
                txt_file = output_model_folder / f"{doc.id}.txt"
                with ann_file.open('w', encoding='utf8') as f_ann, \
                        txt_file.open('w', encoding='utf8') as f_txt:
                    bconv.dump(doc, f_ann, fmt="brat")
                    f_txt.write(doc.text)


