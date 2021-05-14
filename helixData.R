#Lee Kapp STAT235 project - Helix mitochondrial DNA mutation database
#ARF = alternate read fraction to quantify levels of heteroplasmy - probably will just ignore these columns along with haplogroups

#The Cambridge reference human mtDNA sequence is GenBank: J01415.2
#Also see https://www.mitomap.org/foswiki/bin/view/MITOMAP/GenomeLoci for annotation of mt genes and locations
# mt genome = 13 protein coding genes, 22 tRNAs, 2 rRNAs, D-Loop, no introns
# Alleles data are lists with the WT base listed first followed by the variants detected at that base

### Models to try: logistic regression, Decision Tree, Random Forest, PCA, neural network
library(tidyverse)

helixMT<-read_tsv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/helixDB.txt")
helixMT <- helixMT[-c(11, 12)]
helixMT$mutation<-c(rep("unknown", length(helixMT$alleles)))
helixMT$mutation<-ifelse(helixMT$alleles %in% c("[\"C\",\"T\"]","[\"T\",\"C\"]","[\"A\",\"G\"]","[\"G\",\"A\"]"), "transition", helixMT$mutation)
helixMT$mutation<-ifelse(helixMT$alleles %in% c("[\"C\",\"A\"]","[\"A\",\"C\"]","[\"C\",\"G\"]","[\"G\",\"C\"]","[\"A\",\"T\"]","[\"T\",\"A\"]", "[\"G\",\"T\"]","[\"T\",\"G\"]"), "transversion", helixMT$mutation)
helixMT$mutation<-ifelse(helixMT$mutation =="unknown", "in-del", helixMT$mutation)
helixMT$mean_ARF <- ifelse(helixMT$mean_ARF == "NaN", NA, helixMT$mean_ARF)


allelesPerGene <- as.data.frame(table(helixMT$gene, helixMT$mutation))
colnames(allelesPerGene) <- c('gene', 'allele', 'count')

indels <- allelesPerGene %>% filter(allele == "in-del")
indels <- indels[-c(2)]
colnames(indels) <- c('gene', 'indels')
transitions <- allelesPerGene %>% filter(allele == "transition")
transitions <- transitions[-c(2)]
colnames(transitions) <- c('gene', 'transitions')
transversions <- allelesPerGene %>% filter(allele == "transversion")
transversions <- transversions[-c(2)]
colnames(transversions) <- c('gene', 'transversions')

alleleCounts <- inner_join(indels, transitions)
alleleCounts <- inner_join(alleleCounts, transversions)

hom_rows <- rowsum(helixMT[5], helixMT$gene)
het_rows <- rowsum(helixMT[7], helixMT$gene)
plasmicity <- cbind(hom_rows, het_rows)
colnames(plasmicity) <- c('hom_counts', 'het_counts')
mtDNA_table <- cbind(alleleCounts, plasmicity)

### Need to normalize counts per gene to gene sequece length

write.csv(helixMT, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/helixMT.csv")
write.csv(mtDNA_table, "/Users/leekapp/Desktop/CS254/Assignments/FinalProject/mtDNA_table.csv")

### need to know the role of each bp per codon to identify missense, nonsense, and silent mutations. Could analyze in-dels
# for whether they're a multiple of three (for protein coding genes)
wildtype <- read.csv("/Users/leekapp/Desktop/CS254/Assignments/FinalProject/ref_seq.csv")

numUnique <- unique(helixMT$locus)
coding <- helixMT %>% filter(feature!= "non_coding")
numUniqueBases <- unique(coding$locus)
nonCoding <- helixMT %>% filter(feature == "non_coding")
a <- sum(nonCoding$counts_hom) + sum(nonCoding$counts_het)
b <- sum(helixMT$counts_hom) + sum(helixMT$counts_het)
a/b
