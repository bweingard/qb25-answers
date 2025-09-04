#!/usr/bin/env python3

import sys
import fasta

my_file = open(sys.argv[1])
contigs_list = fasta.FASTAReader(my_file)


from statistics import mean

Total_length = 0 
length = 0
for ident, sequence in contigs_list:
    Total_length = Total_length + len(sequence)
    length = length + 1 


Average_length = Total_length/length

print("Number of contigs:", length, ", Total length:", Total_length, ", Average length:", Average_length)
