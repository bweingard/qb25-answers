getwd()
setwd("/Users/cmdb/qb25-answers/week1")

install.packages(tidyverse)
library(tidyverse)

header <- c("chr", "start", "end", "count")
hg19_kc <- read_tsv("hg19-kc-count.bed", col_names = header)
hg16_kc <- read_tsv("hg16-kc-count.bed", col_names = header)

hg19_kc$chr <- factor(hg19_kc$chr, levels = paste0("chr", c(1:22, "X", "Y", "MT")))
hg16_kc$chr <- factor(hg16_kc$chr, levels = paste0("chr", c(1:22, "X", "Y", "M")))

combined <- bind_rows( hg19=hg19_kc, hg16=hg16_kc, .id="assembly" )

ggplot(combined, aes(x = start, y = count, color = assembly)) + geom_line() + facet_wrap(.~ chr ,scales = "free") + geom_point(alpha = 0.6, size = 0.05) +theme(text = element_text(size = 5),
                                                                                                                                                        axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("exercise2.png")
