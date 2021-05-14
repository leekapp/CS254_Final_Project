### Confirmed pathogenic mutations from MitoMap - these are all RNAs
library(tidyverse); library(readxl)
confPath <- read_xlsx("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/confirmedStatus.xlsx")
colnames(confPath) <- c("base", "gene", "allele", "RNA", "homoplasmic", "heteroplasmic", "mitoTip", "disease")
confPath <- confPath %>% filter(!is.na(gene))
confPath <- confPath[-c(7)]
WTref <- read_csv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/fullWTseq.csv")
pathVariants <- inner_join(WTref, confPath, by = "base")
pathVariants <- pathVariants[-c(4)]
pathVariants <- rename(pathVariants, gene = gene.y)
pathVariants$homoplasmic <- ifelse(pathVariants$homoplasmic == "-", "no", pathVariants$homoplasmic)
pathVariants$heteroplasmic <- ifelse(pathVariants$heteroplasmic == "-", "no", pathVariants$heteroplasmic)
pathVariants$homoplasmic <- ifelse(pathVariants$homoplasmic == "+", "yes", pathVariants$homoplasmic)
pathVariants$heteroplasmic <- ifelse(pathVariants$heteroplasmic == "+", "yes", pathVariants$heteroplasmic)
write_csv(pathVariants, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/confPathRNAs.csv")
