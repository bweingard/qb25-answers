#!/usr/bin/env python3

from os import chdir

chdir("/Users/cmdb/qb25-answers/unix-python-scripts")

bf = open('ce11_genes.bed')

for line in bf:
    line = line.rstrip("\n").split("\t")
    original_score = int(line[4])
    feature_size = int(line[2]) - int(line[1])
    new_score = original_score * feature_size

#if strand is negative multiply by -1
    if line[5] == "+":
        new_score = new_score
    else:
        new_score = new_score * -1

    print(original_score, feature_size, new_score)
        
        
        #if + multiply new score by 1 and if negative multiply by -1

        #feature_size is gene length