#!/bin/bash

#Unix Commands Assignment

##Question 1

cd ~/qb25-answers/unix-python-scripts/

wc -l ce11_genes.bed
###53935

cut -f 1 ce11_genes.bed | sort | uniq -c
###5460 chrI
###6299 chrII
###4849 chrIII
###21418 chrIV
###  12 chrM
###9057 chrV
###6840 chrX

cut -f 6 ce11_genes.bed | sort | uniq -c
###26626 -
###27309 +

##Question 3

cd 
cd ~/Data/GTEx/

cut -f 7 GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | sort |uniq -c |sort -r | head -n 3
###3288 Whole Blood
###1132 Muscle - Skeletal
### 867 Lung

wc -l GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt
### 22952 GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt

grep -w RNA GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l
### 20016

grep -w -v RNA GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt | wc -l
### 2936
