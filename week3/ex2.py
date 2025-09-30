#!/usr/bin/env python3

#before start: change directory to week 3:


#wget "https://www.dropbox.com/scl/fi/9kpzomh4uor2z5z7q5i82/biallelic.vcf?rlkey=mc2m37gnntajiptp51cvwb28x&st=g6xits13&dl=0"

#mv 'biallelic.vcf?rlkey=mc2m37gnntajiptp51cvwb28x&st=g6xits13&dl=0' biallelic.vcf


# extract the allele frequency of each variant and output it to a new file called AF.txt which contains only the allele frequencies – one per line (potentially having the first line contain a header)
x = open("AF.txt", "w")
y = open("DP.txt", "w")
for line in open('biallelic.vcf'):
    if line.startswith('#'):
        continue
    fields = line.rstrip('\n').split('\t')
    info = fields[7].split(";") #column 8, split by : and take the 4th value (3rd column)
    for frequency in info:
        if frequency.startswith("AF="):
            print(frequency[3:], file = x)
    samples = fields[9:]
    for depth in samples:
        value = depth.split(":")[2]
        print(value, file = y)
    #print(f"Frequency: {frequency}, Depth: {depth}")
    #print({frequency})


