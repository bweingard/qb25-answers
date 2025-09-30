setwd("/Users/cmdb/qb25-answers/week3")

install.packages(tidyverse)
library(tidyverse)
library(ggplot2)

chr2_data <- read.delim("Chr2_A01_62.txt", header = FALSE)

chr2_data$V2 <- ifelse(chr2_data$V2 == 1, "Alternative", "Reference")
colnames(chr2_data)[2] <- "genotype"
colnames(chr2_data)[1] <- "position"

ggplot(chr2_data, aes(x = position, y = 1, color = genotype)) + 
  geom_point(size = 3, alpha = 0.7) + 
  scale_color_manual(values = c("Reference" = "blue", "Alternative" = "red")) + 
  labs(x = "Position", y = "", title = "Genotype distrubution on ChrII sample A01_62") + 
  theme_minimal() + 
  theme(axis.text.y = element_blank(), panel.grid.major.y = element_blank(), 
    panel.grid.minor = element_blank())
#Q3.2 Transitions/crossover events are on the ends of the chromosomes. This means that recombination in chr II likely happens in higher frequencies closer to ends of chromosomes/telomeres. 

A01_64_data <- read.delim("A01_62_allchr.txt", header = FALSE)
colnames(A01_64_data)[3] <- "genotype"
colnames(A01_64_data)[2] <- "position"
colnames(A01_64_data)[1] <- "chromosome"
A01_64_data$genotype <- ifelse(A01_64_data$genotype== 1, "Alternative", "Reference")
A01_64_data$chromosome <- factor(A01_64_data$chromosome, levels = paste0("chr", c("I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X", 
                                                                                  "XI", "XII", "XIII", "XIV", "XV", "XVI", "M")))

A01_64_data$chrom_y <- as.numeric(factor(A01_64_data$chromosome))



ggplot(A01_64_data, aes(x = position, y = chrom_y, color = genotype)) + 
  geom_point(size = 3, alpha = 0.7) + 
  scale_color_manual(values = c("Reference" = "blue", "Alternative" = "red")) + 
  labs(x = "Position", y = "", title = "Genotype distrubution on ChrII sample A01_62") + 
  theme_minimal() + 
  theme(axis.text.y = element_blank(), panel.grid.major.y = element_blank(), 
        panel.grid.minor = element_blank()) +  facet_grid(~ chromosome, scales = "free_x", space = "free_x")

ggplot(A01_64_data, aes(x = position, y = chrom_y, color = genotype)) + 
  geom_point(size = 3, alpha = 0.7) + 
  scale_color_manual(values = c("Reference" = "blue", "Alternative" = "red")) + 
  labs(x = "Position", y = "", title = "Genotype distrubution on ChrII sample A01_62") + 
  theme_minimal() + scale_y_continuous(
    breaks = 1:length(levels(A01_64_data$chromosome)),
    labels = levels(A01_64_data$chromosome)) +
 theme(panel.grid.major.y = element_blank(), panel.grid.minor = element_blank())

