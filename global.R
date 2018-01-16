library("shiny")
library("gplots")
library("doBy")
library("plotrix")
library("agricolae")

final <- read.csv("final.csv")
gene_anno <- read.csv("annotation.csv")

gene_list <- unique(final$gene)
