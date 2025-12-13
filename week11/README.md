Step 1.1

How many 100bp reads are needed to sequence a 1Mbp genome to 3x coverage?

1Mbp genome x 3x coverage = 3Mbp of data

3Mbp / 100bp/read = 0.03 M reads or 30,000 reads



Step 1.4

1. 48091 has 0x coverage
2. I think it matches poisson expectations pretty well, normal also but normal is centered around 3 while poisson is centered between 2 and 3. Overall I think the fit is good.

Step 1.5
1. 53 have 0x coverage
2. Matches expectations for poisson and normal well, stronger than the 3x coverage.

Step 1.6
1. 0 have 0x coverage
2. Strong if not perfect fit with poisson and normal distribution.

Step 2.4
(graphviz) cmdb@QuantBio-29 week11 % python3 debruijn.py                                   
(graphviz) cmdb@QuantBio-29 week11 % dot -Tpng debruijn_graph.dot -o ex2_digraph.png

Step 2.5
TCTTATTCATTGATTT

Step 2.6
Accurate reconstruction needs high coverage and overlap between kmers to ge rid of ambiguity and resolve any confusion from repeated regions. Using long read or paired0end sequencing would help, but generally you just want the most coverage so you don't have any gaps and are maximizing overlaps to find the best representation of the sequence.
