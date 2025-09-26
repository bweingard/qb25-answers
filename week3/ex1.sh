#!/bin/bash

conda activate qb25

cd qb25-answers/

mkdir week3

cd week3
wget "https://www.dropbox.com/scl/fi/sjkw34og2gas72kke9lqm/BYxRM_bam.tar.gz?dl=0&e=1&rlkey=kc7a9i3mbx5r0cq0tw5cdy7oz"   

mv 'BYxRM_bam.tar.gz?dl=0&e=1&rlkey=kc7a9i3mbx5r0cq0tw5cdy7oz' BYxRM_bam.tar.gz
tar -xzvf BYxRM_bam.tar.gz  

cd BYxRM_bam

samtools index -M A01*

#https://unix.stackexchange.com/questions/602657/how-to-create-a-new-file-based-on-results-from-multiple-files-and-keep-the-filen
for file in *.bam
do
    key="$file"
    value="$(samtools view -c "$file")"
    echo "$key $value"
done > read_counts.txt

awk {'print $1'} read_counts.txt > bamListFile.txt

conda activate freebayes

freebayes -f ~/qb25-answers/week2/genomes/sacCer3.fa -L bamListFile.txt --genotype-qualities -p 1 > unfiltered.vcf
vcffilter -f "QUAL > 20" -f "AN > 9" unfiltered.vcf > filtered.vcf

#this next one didn't work
vcfallelicprimitives -kg filtered.vcf > decomposed.vcf
vcfbreakmulti decomposed.vcf > biallelic.vcf