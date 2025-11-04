#week8 exercise

library(tidyverse)
library(broom)
library(DESeq2)

setwd("~/qb25-answers/week8/")


#1.1
counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt")
counts_df <- column_to_rownames(counts_df, var = "GENE_NAME")

metadata_df <- read_delim("gtex_metadata_downsample.txt")
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")

#1.2
table(colnames(counts_df) == rownames(metadata_df))

dds <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~ SEX + AGE + DTHHRDY)

#1.3
vsd <- vst(dds)

plotPCA(vsd, intgroup = "SEX")
#PC1 is 48% variance, PCR is 7% variance. Based on the distribution it seems like PC2 may account for some of the sex variance, but overall doesn't look like it has much impact.
plotPCA(vsd, intgroup = "AGE")
#PC1 is 48% and PC2 is 7% variance, looks like there is nothing significant with age, seems spread across PCR2.
plotPCA(vsd, intgroup = "DTHHRDY")
#PC1 is 48% variance and looks like it explains the differences in death types. PCR is 7% variance

#2.1 
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()

vsd_df <- bind_cols(metadata_df, vsd_df)

m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
#p-value for sex is not less than 0.05 (its like 0.28), which suggests that WASH7P is not showing significant evidence for sex differential expression

m2 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
#the p-value for sex for this gene is 0.03, which is less than 0.05, suggesting that SLC25A47 is showing evidence of sex-differential expression
##the direction is that is more expressed in males by 0.5 based on the estimate


#2.2
dds <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~ SEX + AGE + DTHHRDY)

dds <- DESeq(dds)

res <- results(dds, name = "SEX_male_vs_female") %>% 
  as_tibble(rownames = "GENE_NAME") %>% 
  arrange(padj)

res %>%
  filter(padj < 0.1) %>%
  nrow()
# 262 genes with significant differential expression between male vs female

chr <- read_delim("gene_locations.txt")

res <- res %>% left_join(chr, by = "GENE_NAME") %>% arrange(padj)
# chrY has the most differentially expressed genes for males and ChrX for females (although males have some too)
# more male upregulated at the top -> males express these genes more

res %>% filter(GENE_NAME == "WASH7P")
#WASH7P has a log2FC of 0.08, suggesting it is not differential expressed between males and females, this validates what was stated earlier.
#However, this also has an adj p-value of 0.899, which is outside the FDR parameters. So this is potentially a false positive.

res %>% filter(GENE_NAME == "SLC25A47")
#this gene has a log2FC of 3.06, meaning it is being significantly expressed in males compared to females, validating earlier statements.
##p-adj is very strong


#If I lower the threshold, this makes it more stringent because I am filtering out data with more variance. This results in me having less false positives since it is more strict, and potentially more false negitives as I coulld be filtering out significant expression differences that have low p-value but not as low as our threshold.
#If i raise the threshold, I am leaving more room for error, resulting in more false positives, however this would reduce the amount of false negatives.
#more stringent -> get rid of significant data, more false negatives, less


#Step 2.4
res2 <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>% 
  as_tibble(rownames = "GENE_NAME") %>% 
  arrange(padj)

res2 %>%
  filter(padj < 0.1) %>%
  nrow()
# 16069 genes with significant differential expression between ventilator deaths vs natural causes

#Step 2.5
metadata_df$SEX2 <- sample(metadata_df$SEX)

dds2 <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~ SEX + AGE + DTHHRDY + SEX2 )

dds2 <- DESeq(dds2)

res3 <- results(dds2, name = "SEX2_male_vs_female") %>% 
  as_tibble(rownames = "GENE_NAME") %>% 
  arrange(padj)

res3 %>%
  filter(padj < 0.1) %>%
  nrow()
#there are now 12 genes considered to be significantly differently expressed between the sexes, adn these are our false positive
##this is much different from the 262 genes I found before, showing that the FDR works really well. 12/262 is about a 5% false positive rate, and this is less than the 10% we are setting.


#Exercise 3:
# make a volcano plot

res$SIGNIFICANCE <- ifelse(res$padj <= 0.1, "Significant", "Not Significant")
res$EXPRESSION <- ifelse(res$log2FoldChange >= 1 & res$padj <=0.1, "Up-Regulated", ifelse(res$log2FoldChange <= -1 & res$padj <= 0.1, "Down-Regulated", "Neutral"))

volcano_plot <- ggplot(data = res, aes(x = log2FoldChange, y = -log10(padj), color = EXPRESSION)) +
  geom_point() + scale_color_manual(values = c("Up-Regulated" = "Red",
                                               "Down-Regulated" = "Blue",
                                               "Neutral" = "Black"))
ggsave( "volcano_plot.png", volcano_plot)
