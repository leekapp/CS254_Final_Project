### all presumed pathogenic variants from MitoMap
library(tidyverse); library(readxl)
pathCoding <- read_xlsx("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/pathCodingVariants.xlsx")
pathCoding <- pathCoding[-c(2, 8:10)]
names(pathCoding) <- c("gene", "base", "allele", "amino_acid_change", "plasmicity", "disease")
pathCoding <- pathCoding %>% filter(!is.na(gene))
pathCoding$homoplasmic <- ifelse(pathCoding$plasmicity == "+/-" | pathCoding$plasmicity == "+/+", "yes", "no")
pathCoding$heteroplasmic <- ifelse(pathCoding$plasmicity == "-/-" | pathCoding$plasmicity == "-/+", "yes", "no")
pathCoding$homoplasmic[pathCoding$plasmicity == "nr/nr"] <- NA
pathCoding$homoplasmic[pathCoding$plasmicity == "na/na"] <- NA
pathCoding$homoplasmic[pathCoding$plasmicity == "nr/+"] <- NA
pathCoding$homoplasmic[pathCoding$plasmicity == "./+"] <- NA
pathCoding$homoplasmic[pathCoding$plasmicity == "/"] <- NA
pathCoding$homoplasmic[pathCoding$plasmicity == "99%/-"] <- "yes"
pathCoding$heteroplasmic[pathCoding$plasmicity == "/"] <- NA
pathCoding$heteroplasmic[pathCoding$plasmicity == "./+"] <- "yes"
pathCoding$heteroplasmic[pathCoding$plasmicity == "nr/+"] <- "yes"
pathCoding$heteroplasmic[pathCoding$plasmicity == "nr/nr"] <- NA
pathCoding$heteroplasmic[pathCoding$plasmicity == "na/na"] <- NA
pathCoding <- pathCoding[-c(5)]
pathCoding <- pathCoding[c(1,2,3,4,6,7,5)]
pathCoding <- inner_join(WTref, pathCoding, by = "base")
pathCoding <- pathCoding[-c(4)]
pathCoding <- rename(pathCoding, gene = gene.y)
write_csv(pathCoding, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/pathCodingVars.csv")
