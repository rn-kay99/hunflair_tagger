from datasets import load_dataset

from utils import DEFAULT_TYPE_MAPPING

evaluation_datasets = [
    # NER + NEN datasets
    ("bc5cdr", ["train", "validation"]),
    ("tmvar_v3", []),
    ("bioid", []),

    # NER only data sets
    ("bionlp_st_2013_cg", ["train", "validation"]),
    ("pdr", []),
    ("craft", [])
]

for data_set, exclude_splits in evaluation_datasets:
    data = load_dataset(f"bigbio/{data_set}", name=f"{data_set}_bigbio_kb")

    total_entities = 0
    num_nc_entities = 0

    for split in data.keys():
        if split in exclude_splits:
            continue

        for document in data[split]:
            for entity in document["entities"]:
                entity_type = entity["type"].lower()
                if entity_type not in DEFAULT_TYPE_MAPPING:
                    continue

                total_entities += 1
                if len(entity["offsets"]) > 1:
                    #print(entity["offsets"])
                    num_nc_entities += 1

    print(f"{data_set}: {num_nc_entities} / {total_entities} ({num_nc_entities / total_entities})")
