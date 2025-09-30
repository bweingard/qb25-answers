#!/bin/bash

bedtools intersect -c -a hg19-kc.bed -b snps-chr1.bed | sort -k5,5nr | head -n 1
#chr1	245912648	246670581	ENST00000490107.6_7	5445

#Systematic name: ENST00000490107.6_7
#Human readable name:  SMYD3_HUMAN
#position: hg19 chr1:245,912,649-246,670,581 (transcript)
#size: 757,933 (transcript)
#exon count: 12 (transcript)

## SMYD3 encodes a histone methyltransferase that is a member of an RNA polymerase complex. It’s a really large gene so I think that’s why it could have the most snps and variation, as well as multiple exons.

bedtools sample -n 20 -seed 42 -i snps-chr1.bed > snps-subset.bed

bedtools sort -i snps-subset.bed > snps-sort.bed 

bedtools sort -i hg19-kc.bed > hg19-sorted.bed

bedtools closest -d -t first -a snps-sort.bed -b hg19-sorted.bed > last-thing.bed 

awk '$11 == 0' last-thing.bed | wc -l
      #15
	  ##15 snps are inside of a gene

awk '$11 != 0' last-thing.bed             
#chr1	11638083	11638084	rs6698664	0	+	chr1	11653741 11655507 ENST00000793460.1_2 15658
#chr1	19821839	19821840	rs2088825	0	+	chr1	19823503 19890741 ENST00000816783.1_2 1664
#chr1	20821533	20821534	rs74720529	0	+	chr1	20825940 20834644 ENST00000264198.5_7 4407
#chr1	83638833	83638834	rs9429360	0	+	chr1	83368865 83632498 ENST00000452901.5_3 6336
#chr1	164976172	164976173	rs11325393	0	+ chr1 164953138 164953229 ENST00000390797.1 22944

##min is 1664, max is 22944, range is difference -> 21280
