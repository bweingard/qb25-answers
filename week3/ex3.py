#!/usr/bin/env python3

sample_ids = ["A01_62", "A01_39", "A01_63", "A01_35", "A01_31",
              "A01_27", "A01_24", "A01_23", "A01_11", "A01_09"]

z = open("gt_long.txt","w")
for line in open('biallelic.vcf'):
    if line.startswith('#'):
        continue
    fields = line.rstrip('\n').split('\t')
    chrom = fields[0]
    pos = fields[1]
    samples = fields[9:]
    for i in range(len(sample_ids)):
        sample_data = samples[i]
        genotype = sample_data.split(":")[0]
        if genotype == "0":
            print("0", file = z)
        elif genotype == "1":
            print ("1", file = z)
        else:
            continue
        print()
#Q3.1 I think that A01_09, A01_11, A01_39 are definetly derived from lab strain, as they have no full variant calls
#A01_24, A01_27, A01_31, and A01_65 have the same insertional mutations so maybe they could be derived from wine strain.

a = open("Chr2_A01_62.txt","w")
for line in open('biallelic.vcf'):
    if line.startswith('#'):
        continue
    fields = line.rstrip('\n').split('\t')
    chrom = fields[0]
    pos = fields[1]
    samples = fields[9:]
    if chrom == "II":
        for i in range(len(sample_ids)):
                if sample_ids[i] == "A01_62":
                    sample_data = samples[i]
                genotype = sample_data.split(":")[0]
                if genotype == "0":
                    print("0", file = a)
                elif genotype == "1":
                    print ("1", file = a)
                else:
                    continue
                print()