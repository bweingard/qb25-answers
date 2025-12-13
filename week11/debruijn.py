#!/usr/bin/env python
# coding: utf-8


reads = ['ATTCA', 'ATTGA', 'CATTG', 'CTTAT', 'GATTG', 'TATTT', 'TCATT', 'TCTTA', 'TGATT', 'TTATT', 'TTCAT', 'TTCTT', 'TTGAT']

k = 3
graph = set()

for read in reads:
    for i in range(len(read) - k):
        kmer1 = read[i:i+k]
        kmer2 = read[i+1:i+1+k]
        graph.add((kmer1, kmer2))

with open("debruijn_graph.dot", "w") as f:
    f.write("digraph G {\n")
    for edge in sorted(graph):
        f.write(f" {edge[0]} -> {edge[1]};\n")
    f.write("}\n")

