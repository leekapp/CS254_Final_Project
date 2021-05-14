library(tidyverse)
library(readxl)
dat <- read.csv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/intermediateTables/base&WTIndex.csv")

index <- unique(dat$WT)
vec <- unique(dat$base)

invariant <- as.data.frame(setdiff(index, vec))
rownames(invariant) <- c(setdiff(index, vec))
colnames(invariant) <- c("base")


ref_seq <- read_csv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/intermediateTables/ref_seq.csv")
helixIndex <- read_csv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/intermediateTables/baseIndex.csv")

invariantBases <- inner_join(ref_seq, invariant, by = "base")
rownames(invariantBases) <- invariantBases$base
table(invariantBases$wildtype)
which(invariantBases$wildtype == 'N') # = base 3107 in the mtDNA - wierd because it's in the ref_seq

helixDF <- read_csv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/helixData.csv")
mtTable <- read_csv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/norm_mtDNA_table.csv")
mtTable <- mtTable[-c(1)]

helixBases <- inner_join(ref_seq, helixIndex, by = "base")
helixBases <- unique(helixBases)
row.names(helixBases) <- helixBases$base

ref_annotation <- read_xlsx("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/ref_annotation.xlsx")

helixBases <- inner_join(helixBases, ref_annotation, by="base")
helixBases <- helixBases[-c(3)]
row.names(helixBases) <- helixBases$base
write_csv(helixBases, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/helixBases.csv")


protein <- helixDF %>% filter(feature == "protein_coding_gene")


invariantBases <- inner_join(invariantBases, ref_annotation, by = "base")
invariantBases <- invariantBases[-c(3)]
invariantBases <- rename(invariantBases, wildtype = wildtype.x)

WTannot <- inner_join(ref_seq,ref_annotation,by = "base")
write_csv(WTannot, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/fullWTseq.csv")
write_csv(invariantBases, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/invariant.csv")
table(invariantBases$annotation)
table(helixDF$annotation)

invariantBases %>% filter(!is.na(annotation)) %>% 
  ggplot(mapping = aes(x = annotation)) +
    geom_bar() +
    labs(title = "Distribution of codon positions among invariant bases", x = "codon position")
    theme_minimal()

helixDF %>% filter(!is.na(annotation)) %>% 
    ggplot(mapping = aes(x = annotation)) +
    geom_bar() +
    labs(title = "Distribution of codon positions among Helix mtDB", x = "codon position")
    theme_minimal()
    