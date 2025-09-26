#!/usr/bin/python3

from os import chdir
chdir("/Users/cmdb/qb25-answers/week2/variants/")

sam_data = "/Users/cmdb/qb25-answers/week2/variants/A01_01.sam"

sam_list = open(sam_data)

chrom_counts = {}
mismatch_counts = {}


for line in sam_list:
    if line.startswith("@"):
        continue  
    fields = line.rstrip("\n").split("\t")
    chrom = fields[2]
    if chrom in chrom_counts:
        chrom_counts[chrom] += 1
    else:
        chrom_counts[chrom] = 1
    for field in fields[11:]:
        if field.startswith("NM:i:"):
            mismatches = int(field[5:])
            if mismatches in mismatch_counts:
                mismatch_counts[mismatches] +=1
            else:
                mismatch_counts[mismatches] = 1
            break
for chrom in chrom_counts.keys():
    print(f"{chrom}\t{chrom_counts[chrom]}")

#key is chromosome name (column 3 (2 in python)), use dictionary to count how many times each chromosome appears in list

#if loop where :
    #add one everytime everytime you see it
    #create key value pair for each time you see chromosome name

#can compare to idx stats file to see if its the same


for mismatch in sorted(mismatch_counts):
    print(f"{mismatch}\t{mismatch_counts[mismatch]}")

    



     


