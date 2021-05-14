### total suspected pathogenic RNA variants from MitoMap
library(tidyverse); library(readxl)
totPathRNA <- read_xlsx("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/pathRNAVariants.xlsx")
totPathRNA <- totPathRNA[-c(8:10)]
names(totPathRNA) <- c("base", "gene", "disease", "allele", "RNA", "homoplasmic", "heteroplasmic")
totPathRNA <- totPathRNA %>% filter(!is.na(gene))
totPathRNA$homoplasmic[totPathRNA$homoplasmic == "+"] <- "yes"
totPathRNA$homoplasmic[totPathRNA$homoplasmic == "-"] <- "no"
totPathRNA$homoplasmic[totPathRNA$homoplasmic == "nr"] <- NA
totPathRNA$heteroplasmic[totPathRNA$heteroplasmic == "+"] <- "yes"
totPathRNA$heteroplasmic[totPathRNA$heteroplasmic == "-"] <- "no"
totPathRNA$heteroplasmic[totPathRNA$heteroplasmic == "nr"] <- NA
totPathRNA <- totPathRNA[c(1,2,4,5,6,7,3)]
totPathRNA <- inner_join(WTref, totPathRNA, by = "base")
totPathRNA <- totPathRNA[-c(4)]
totPathRNA <- rename(totPathRNA, gene = gene.y)
write_csv(totPathRNA, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/totPathRNA.csv")
