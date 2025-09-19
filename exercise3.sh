#!/bin/bash

Question 3

#Code 1
bedtools intersect -a nhlf-active.bed -b nhlf-active.bed > nhlf-overlaps.bed

bedtools intersect -a nhek-active.bed -b nhek-active.bed > nhek-overlaps.bed

wc -l n*-active.bed
#0
#0

#Code 2+3
bedtools intersect -a nhek-active.bed -b nhlf-active.bed > active-overlaps.bed
wc -l active-overlaps.bed 
#12174 lines/features

bedtools intersect -v -a nhek-active.bed -b nhlf-active.bed > active-in-nhek-not-nhlf.bed        
wc -l active-in-nhek-not-nhlf.bed 
#2405 lines/features

#sum of two bed files do not equal, the original has 14013, the sum of these are 14597. To change add -u
#result: 11855, sum is correct now

#Code 4-6
bedtools intersect -f 1 -a nhek-active.bed -b nhlf-active.bed > command-4.bed
bedtools intersect —F 1 -a nhek-active.bed -b nhlf-active.bed > command-5.bed
bedtools intersect —f 1 -F 1 -a nhek-active.bed -b nhlf-active.bed > command-6.bed
head -1 command-*     
#==> command-4.bed <==
#chr1	25558413	25559413	1_Active_Promoter	0	.25558413 25559413

##More active promoters and strong enhancers, transcription at the start

#==> command-5.bed <==
#chr1	19923013	19924213	1_Active_Promoter	0	.19922613 19924613

##Still have active promoters and strong enhancers, but I see some heterochromatin in the beginning and transcription on the end

#==> command-6.bed <==
#chr1	1051137	1051537	1_Active_Promoter	0	.1051137 1051537
##This only has active and mostly weak promoters and weak enhancers.


#Code 7-9
bedtools intersect -a nhek-active.bed -b nhlf-active.bed > active-active.bed
#head -1 active-active.bed 
##chr1	19923013	19924213	1_Active_Promoter	0	.	19922613	19924613
###Strong enhancers and active promoters only

bedtools intersect -a nhek-active.bed -b nhlf-repressed.bed > active-repressed.bed 
##chr1	1981140	1981540	1_Active_Promoter	0	.	1981140	1981540
###About half are active promoters, the rest are repressed, insulated, or weak promoters

bedtools intersect -a nhek-repressed.bed -b nhlf-repressed.bed > repressed-repressed.bed 
##chr1	11537413	11538213	12_Repressed	0	.	11534013	11538613
###All repressed or heterochromatin




