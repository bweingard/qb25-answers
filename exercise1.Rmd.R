getwd()
setwd("/Users/cmdb/qb25-answers/week1")

install.packages(tidyverse)
library(tidyverse)

header <- c("chr", "start", "end", "count")
df_kc <- read_tsv("hg19-kc-count.bed", col_names = header)

library(ggplot2)

df_kc$chr <- factor(df_kc$chr, levels = paste0("chr", c(1:22, "X", "Y", "MT")))

#Plot using ggplot(), geom_line(), and facet_wrap(), using the scales argument to let the x- and y-axes adjust for each chromosome
#If you need a place to start, plot just chr1 by first subsetting using filter( chr == "chr1" ) so that you don’t have to use facet_wrap(), then proceed to plotting all the chromosomes
#Save your plot using ggsave( "exercise1.png" )

ggplot(df_kc, aes(x = start, y = count, color = chr)) + geom_line() + facet_wrap(.~ chr ,scales = "free") + geom_point(alpha = 0.6, size = 0.05) +theme(text = element_text(size = 5),
                                                                                                                                                        axis.text.x = element_text(angle = 45, hjust = 1))
ggsave( "exercise1.png" )
