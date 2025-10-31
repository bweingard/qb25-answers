#wget https://raw.githubusercontent.com/bxlab/cmdb-quantbio/refs/heads/main/assignments/lab/unsupervised_learning/extra_data/read_matrix.tsv.gz
#gunzip read_matrix.tsv.gz

library(readr)
library(matrixStats)
library(dplyr)
library(tidyr)
library(ggplot2)
setwd("~/qb25-answers/week7")
reads <- read.table("read_matrix.tsv")



#Step 1.1
read_matrix <- as.matrix(reads)

STDEV <- rowSds(read_matrix)

top500_idx <- order(STDEV, decreasing = TRUE)[1:500]
t500_genes_matrix <- read_matrix[top500_idx, ]

#Step 1.2
t500_genes_matrix <- t(t500_genes_matrix)
pca <- prcomp(t500_genes_matrix)
(summary(pca))

#Step 1.3
pca_analysis <- as_tibble(pca$x[,1:2], rownames = "Sample") %>% separate("Sample", c("Tissue", "Replicate") ,sep = "_")
PCA_1 <- pca_analysis %>% ggplot(aes(PC1, PC2, color=Tissue, shape=Replicate)) +
  geom_point(size=3) + ggtitle("PCA Version 1")

ggsave("PCA_1.png", PCA_1)

##problem: Replicate 3 of LFC.Fe is mixed into Fe cluster instead of being with its own, Rep1 of Fe is in LCF.Fe, same thing.
##This suggests that the labeling was mixed up between the two. To fix this, switch the label.

#fix: R3 LCF.FE <-> R1 Fe
pca_analysis <- as_tibble(pca$x[,1:2], rownames = "Sample")

#swap the labels
sample1 <- which(pca_analysis$Sample == "LFC.Fe_Rep3")
sample2 <- which(pca_analysis$Sample == "Fe_Rep1")

temporary_label <- pca_analysis$Sample[sample1]
pca_analysis$Sample[sample1] <- pca_analysis$Sample[sample2]
pca_analysis$Sample[sample2] <- temporary_label

#run again
pca_analysis <- pca_analysis %>% separate("Sample", c("Tissue", "Replicate"), sep = "_")
PCA_2 <- pca_analysis %>% ggplot(aes(PC1, PC2, color=Tissue, shape=Replicate)) +
  geom_point(size=3) + ggtitle("PCA Version 2")

ggsave("PCA_2.png", PCA_2)


##question 2: The PCA variation can be explained through the order of the tissues in the gut, leading to different gene expression in each tissue type.


#to plot variance I need prop_variance
summary_pca <- summary(pca)
prop_var <- summary_pca$importance[2,]
cum_var <- summary_pca$importance[3,]

pca_summary <- data.frame(PC = paste0("PC", 1:length(prop_var)), prop_var = prop_var, cum_var = cum_var)
pca_summary$PC <- factor(pca_summary$PC, levels = paste0("PC", c(1:21)))

#plot variance as bar chart
bar_plot <- pca_summary %>% ggplot(aes(x=PC, y=prop_var, fill = PC)) +
  geom_bar(stat = "identity") +
  labs(y="Percent variance explained") + ggtitle("Percent Variance per PC")

ggsave("bar_plot.png", bar_plot)



#Exercise 2:
#2.1
combined = read_matrix[,seq(1, 21, 3)]
combined = combined + read_matrix[,seq(2, 21, 3)]
combined = combined + read_matrix[,seq(3, 21, 3)]
combined = combined / 3

#find SD
STDEV <- rowSds(combined)
filtered_matrix <- combined[STDEV >=1, ]

#2.2
set.seed(42)
kmeans_results = kmeans(as.matrix(filtered_matrix), centers=12, nstart=100)
cluster_labels <- kmeans_results$cluster

filtered_matrix <- cbind(filtered_matrix, cluster_labels)
filtered_matrix <- filtered_matrix[order(filtered_matrix[, 8], decreasing=FALSE), ]
filtered_matrix[, 8] <- factor(filtered_matrix[, 8], levels = paste0(c(1:12)))
cluster_labels <- filtered_matrix[, 8]

  
heatmap <- heatmap(filtered_matrix[,-8], Rowv=NA, Colv=NA, RowSideColors=RColorBrewer::brewer.pal(12,"Paired")[cluster_labels],  ylab="Gene", margins = c(8,5))
#heatmap has cluster 12 on top and 1 on bottom and i cant figure out whats causing it

#exercise 3 -> selecting clusters 8 and 9 bcuz they are largest
filtered_matrix_df <- as.data.frame(filtered_matrix) %>% group_by(cluster_labels)
filtered_matrix_df$gene <- rownames(filtered_matrix)
filtered_matrix_df <- filtered_matrix_df %>% select(gene, everything())
count(filtered_matrix_df)

filtered_matrix_df <- filtered_matrix_df %>% ungroup()

#I assume we are supposed to select drosophila for our enrichments since these are drosophila samples

cluster_8 <- filtered_matrix_df %>% filter(cluster_labels == 8) %>% select(gene)
#enriched for negative regulation of oskar mRNA translation and chorion-containing eggshell formation
##mostly enriched in Cu tissue
cluster_9 <- filtered_matrix_df %>% filter(cluster_labels == 9) %>% select(gene)
#enriched for equator specification
#mostly enriched in A1 tissue


#No, neither of these make sense biologically. 
#cluster8 is enriched for genes involved in oogenesis and development of embryos - does not make sense for midgut / copper tissue.
#cluster8 is enriched for equator specification, which is defined in the panther database as "The formation and development of the equator that forms the boundary between the photoreceptors in the dorsal sector of the eye and those in the ventral sector, dividing the eye into dorsal and ventral halves."
#neither are these are related to midgut function/formation

