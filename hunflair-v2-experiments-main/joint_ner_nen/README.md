# Cross-corpus evaluation on joint NER and NEN 

This corresponds to the section TODO in the paper.

As we use pre-computed annotations from the folder `annotations`, 
to reproduce the number the only thing you need to do is run:

```bash
$ python -m joint_ner_nen.evaluate 
```

This computes micro (average over entities) and macro (average over documents) precision, recall and f1 score,
both at the document and mention level. As gold mentions can have multiple identifiers we use a **relaxed** version of a match,
i.e. we consider the prediction correct if any of the predicted identifier is equal to any of the gold ones.

Below you find the steps we followed to generated the gold standard annotations and the HunFlair predictions.

## Mapping MedMentions and CRAFT to CTD

As reported in the paper, there are no corpora with entity mentions normalized to CTD vocabularies which were not used to train the tools considered in the evaluation. 
For this reason we resort to use two other corpora, MedMentions and CRAFT, by mapping their annotations to identifiers in the CTD vocabularies.

### 1. UMLS

You need to obtain the UMLS version used by MedMentions: UMLS2017AA full release
More [here](https://www.nlm.nih.gov/research/umls/index.html) on how to do that.

UMLS provides "entity types" named "semantic types".
The full list can be found [here](https://lhncbc.nlm.nih.gov/ii/tools/MetaMap/documentation/SemanticTypesAndGroups.html).
We consider only:
- Chemical: T103 (Chmical), T120 (Chemical Viewed Functionally), T104 (Chemical Viewed Structurally), T197 (Inorganic Chemical), T109 (Organic Chemical)
- Disease: T047 (Disease or Syndrome), T050 (Experimental Model of Disease), T017 (Anatomical Structure), T033 (Finding), T038 (Biologic Function)

### 2. Setup

This will generate all the data necessary to create the evaluation corpora.

```bash
# Don't forget to place the `umls-2017AA-full.zip` file in here!
export DIRECTORY="path/to/directory"
chmod +x ./joint_ner_nen/setup.sh
./joint_ner_nen/setup.sh $DIRECTORY
```

### 3. Map the annotations

After this you can call the script that performs the mapping (UMLS->CTD, MONDO->CTD):

```bash
export DIRECTORY="path/to/directory"
(venv) user$ python -m joint_ner_nen.map_to_ctd --dir $DIRECTORY
```

## Predicting with HunFlair 

```bash
CUDA_VISIBLE_DEVICES=0 python -m joint_ner_nen.predict --dir ./annotations --batch_size 1000 
```
