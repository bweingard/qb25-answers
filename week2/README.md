
#Week 2 Exericise 1

bowtie2 -p 4 -x ~/qb25-answers/week2/genomes/sacCer3 -U ~/Data/BYxRM/fastq/A01_01.fq.gz > A01_01.sam
samtools sort -o A01_01.bam A01_01.sam
samtools index A01_01.bam
samtools idxstats A01_01.bam > A01_01.idxstats


#Week 2 Exercise 2

#The wt strain is B and the alternate strain is R. More color in sample = more misalignments = R instead of B.
#Samples 1, 3, and 4 have lots of color so I predict more R than B.
#Samples 2, 5, and 6 have less color so I predict more alignment to reference B.
#If I open the genotype text file this is confirmed.



#Week 2 Exercise 4
minimap2 -a -d -map-ont /Users/cmdb/qb25-answers/week2/genomes/saCCer3.fa /Users/cmdb/qb25-answers/week2/rawdata/ERR8562478.fastq > longreads.sam

#Week 2 Exercise 5
hisat2 -x /Users/cmdb/qb25-answers/week2/genomes/sacCer3 -U /Users/cmdb/qb25-answers/week2/rawdata/SRR10143769.fastq -S question_5.sam 

