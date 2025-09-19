#!/bin/bash

wc -l hg1*-kc-count.bed
    #3085 hg16-kc-count.bed 
	## 3085 genes in hg16
    #3114 hg19-kc-count.bed
	## 3114 genes in hg19

bedtools intersect -v -a hg19-kc-count.bed -b hg16-kc-count.bed | wc -l
    #36
	##36 genes in hg19 that are not in hg16


bedtools intersect -v -a hg16-kc-count.bed -b hg19-kc-count.bed | wc -l
	#7
	##7 genes in hg16 that are not in hg19

##hg19 is a newer version of the genome compared to hg16, so there could be differences due to better sequencing technology, updated annotations, and new genes. For the reverse, I think those 7 genes could have been annotated differently and mapped better in hg19 so maybe they are combined
