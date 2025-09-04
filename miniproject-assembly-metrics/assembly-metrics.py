#!/usr/bin/env python3

import sys
import fasta

my_file = open(sys.argv[1])
contigs_list = fasta.FASTAReader(my_file)


from statistics import mean
contig_lengths = []

Total_length = 0 
length = 0
for ident, sequence in contigs_list:
    Total_length = Total_length + len(sequence)
    length = length + 1
    contig_lengths.append(len(sequence))


Average_length = Total_length/length

print("Number of contigs:", length, ", Total length:", Total_length, ", Average length:", Average_length)

contig_lengths.sort(reverse=True)

cumulative_length = 0

for length2 in contig_lengths:
    cumulative_length = cumulative_length + length2
    if cumulative_length >= (0.5 * Total_length):
        N50 = length2
        break 
    else:
        continue
    ##this is making contigs greater than 50%??
print(N50,"is the sequence length of the shortest contig at 50% of the total assembly length.")
