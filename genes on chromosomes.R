BiocManager::install("RIdeogram")
library(RIdeogram)
#The karyotype.txt is th file of chromosomes informations which consist of 3 colunms: Chr, Strat, End.
chrdata <- read.delim("karyotype.txt",header = T ,stringsAsFactors = F)
AE_karyotype <- chrdata
#calculated gene density by window.
gene_density <- GFFex("CM.maker.final.chrom_level.gene.v5.gff",karyotype ="karyotype.txt"  ,window = 1000000,feature = "gene")
#add some markers. Markers can be SNP, gene and QTL et. al. The marker files consisted of 6 colunms： Type, Shape, Start, End and color.
mydata <- read.delim("txt",header = T,stringsAsFactors = F)
#draw the figures
ideogram(karyotype = AE_karyotype, overlaid = gene_density,label = mydata,label_type = "marker",width = 100)
#save the figures
convertSVG("chromosome.svg", device = "tiff")
#change heatmap color
ideogram(karyotype = AE_karyotype, overlaid = gene_density,label = mydata,label_type = "marker",width = 100,colorset1 = c("#fc8d59", "#ffffbf", "#91bfdb"))
#adjust chr width and legend position
ideogram(karyotype = AE_karyotype, overlaid = gene_density,label = mydata,label_type = "marker",
         width = 100,colorset1 = c("#fc8d59", "#ffffbf", "#91bfdb"),
         width = 100,Lx=80,Ly=25)
