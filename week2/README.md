
#Week 2 Exericise1

bowtie2 -p 4 -x ~/qb25-answers/week2/genomes/sacCer3 -U ~/Data/BYxRM/fastq/A01_01.fq.gz > A01_01.sam
samtools sort -o A01_01.bam A01_01.sam
samtools index A01_01.bam
samtools idxstats A01_01.bam > A01_01.idxstats
