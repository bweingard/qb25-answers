setwd("/Users/cmdb/qb25-answers/week3")

install.packages(tidyverse)
library(tidyverse)
library(ggplot2)

allele_frequences <- read.delim("AF.txt", header = FALSE)


ggplot(allele_frequences, aes(x = V1)) + 
  geom_histogram(bins = 11, fill = "purple") + labs(x = "Allelic Frequencies", y = "Counts")

#Q2.1 This looks as expected for allelic frequencies, as the peak is at 0.5 representing a good mix of alternative and reference alleles // heterozygotes. The name of this distribution is Gaussian normal distribution.

depth <- read.delim("DP.txt", header = FALSE)

ggplot(depth, aes(x = V1)) + 
  geom_histogram(bins = 21, fill = "skyblue") + labs(x = "Depth Frequencies", y = "Counts") + xlim(0,20)

#Q2.2 This is looking at allelic depth, which is the number of reads that map to a specific allele in a given position. Since the histogram is skewed to the right, this means that more reads have lower depth frequencies -> lower coverage.