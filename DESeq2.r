##title: "461samples_exclude_mislabeled_sex"
##author: "YC"
##date: "5/17/2019"
##output: html_document

#import clinical dataset N=461

ds <- read.csv('/Users/cactaceae/Desktop/Transcriptomics/organized_DB_2_n461.csv', na.strings = c(""," ","NA"), blank.lines.skip = F, row.names = 1)
colSums(is.na(ds)) 
ds_n461 <- ds[order(row.names(ds)),]

ds$hosp_recr <- as.numeric(ds$hosp_recr)
ds$AMA <- as.numeric(ds$AMA)
ds$t_re_seq <- as.numeric(ds$t_re_seq)
ds$preterm <- as.numeric(ds$preterm)
ds$bw_low <- as.numeric(ds$bw_low)

#calculate variables correlation 
cor_variables <- cor(ds[, c(1:12,14:15,17:29)], use="complete.obs", method="kendall")
write.csv(cor_variables, file = "cor_variables.csv")

#import gene counts table N=461
raw_counts <- read.csv('/Users/cactaceae/Desktop/Transcriptomics/raw_counts_n461.csv', header = T, row.names = 1 )
raw_counts <- raw_counts[,order(colnames(raw_counts))]
table(rownames(ds_n461)==colnames(counts_n461))

#manipulate dataset (deal with missing value, re-level factors)
a <- ds_n461
#no missing value column
a$PN_MARITAL <- factor(a$PN_MARITAL, labels = c("Married", "Divorced", "Single"))
a$employment <- factor(a$employment, labels = c("No", "Yes"))
a$SEX <- factor(a$SEX, labels = c("Male", "Female"))
a$parity <- factor(a$parity, labels = c("Nulliparous", "Parous"))

a$tobacco_binary <- as.character(a$tobacco_binary)
a$alc_binary <- as.character(a$alc_binary)
a$pre_bmi_cate <- as.character(a$pre_bmi_cate)

#existing missing value column
a[is.na(a)] <- "Missing"

a$race_ethnic <- factor(a$race_ethnic, labels = c("Caucasian", "Hispanic", "African-American", "Asian", "Other", "Missing"))
a$edu <- factor(a$edu, labels = c("Less_than_high_school", "High_school_diploma_or_GED", "Some_college_no_degree", "Associate_degree", "Bachelor_degree", "Post_graduate_degree", "Missing"))
a$income_fam <- factor(a$income_fam, labels = c("Less_than_$30,000", "$30,000-$49,999", "$50,000-$74,999", "$75,000-$99,999", "$100,000_or_more", "Do_not_know", "Missing"))
a$preeclamp <- factor(a$preeclamp, labels = c("No", "Yes", "Missing"))
a$gest_htn <- factor(a$gest_htn, labels = c("No", "Yes", "Missing"))
a$gest_diab <- factor(a$gest_diab, labels = c("No", "Yes", "Missing"))
a$tobacco <- factor(a$tobacco, labels = c("Never_user", "User_stopped_in_pregnancy", "User_continued_in_pregnancy", "Missing"))
a$alc <- factor(a$alc, labels = c("Never_user", "User_stopped_in_pregnancy", "User_continued_in_pregnancy", "Missing"))

#relevel factor
a$pre_bmi_cate <- factor(a$pre_bmi_cate, levels = c("normal", "obese", "overweight", "underweight", "Missing")) 
a$tobacco_binary <- factor(a$tobacco_binary, levels = c("No", "Yes", "Missing"))
a$alc_binary <- factor(a$alc_binary, levels = c("No", "Yes", "Missing"))

#check IDs are matching each other in two matrix
table(rownames(a)==colnames(counts_n461))

#create DESeqDataSet  
#design = ~ hosp_recr + race_ethnic + PN_MARITAL + edu + income_fam + employment + parity + preeclamp + gest_htn + gest_diab + SEX + t_re_seq + preterm + bw_low + pre_bmi_cate + AMA + alc + tobacco_binary

library("DESeq2")
dds <- DESeqDataSetFromMatrix(countData = counts_n461, colData = a, design = ~ hosp_recr + race_ethnic + PN_MARITAL + edu + income_fam + employment + parity + preeclamp + gest_htn + gest_diab + SEX + t_re_seq + preterm + bw_low + pre_bmi_cate + AMA + alc + tobacco_binary)
#save(dds, file = "dds.RData")

#perform varianceStabilizingTransformation
#dds_vst <- varianceStabilizingTransformation(dds, blind = T)
vsd <- dds_vst
assay(vsd) <- limma::removeBatchEffect(assay(dds_vst), dds_vst$t_re_seq)  #remove batch effects

#performs PCA 
pca_vsd <- prcomp(t(assay(vsd))) # prcomp: center = T, scale =F
names(pca_vsd)

library("pcaExplorer")
#scree plots of the PC computed on the samples
pcascree(pca_vsd, type="cev", pc_nr = 10, title="Proportion of explained proportion of variance")

#select target variables for plotting correlation of variables VS PC
ds_pca <- colData(dds)[,colnames(colData(dds))[c(1,3,5,9:11,13:15,18:21,26,28:32)]] 

#compute the correlation of selected variables versus PCs
res_pca_vsd <- correlatePCs(pca_vsd,ds_pca)

#plot significance of the correlation of each variables vs a PC
plotPCcorrs(res_pca_vsd, logp = T, pc =1)
plotPCcorrs(res_pca_vsd, logp = T, pc =2)
plotPCcorrs(res_pca_vsd, logp = T, pc =3)
plotPCcorrs(res_pca_vsd, logp = T, pc =4)


library("ggplot2")
percentVar <- pca_vsd$sdev^2/sum(pca_vsd$sdev^2)
group1 <- dds$preeclamp # according to variable correlation coefficient on first PC1 and PC2 
group2 <- dds$preterm # according to variable correlation coefficient on first PC3 and PC4 
df_pca_vsd <- as.data.frame(pca_vsd$x)
ggplot(data = df_pca_vsd, aes(x = PC1, y = PC2, label = rownames(df_pca_vsd), color = group1, main = "preeclamp")) +
  geom_point() + 
  #geom_text(colour = "purple", alpha = 0.5, size = 2) +
  xlab(paste0("PC1: ", round(percentVar[1] * 100), "% variance")) + 
  ylab(paste0("PC2: ", round(percentVar[2] * 100), "% variance")) + 
  coord_fixed()

ggplot(data = df_pca_vsd, aes(x = PC3, y = PC4, label = rownames(df_pca_vsd), color = group2)) +
  geom_point() + 
  #geom_text(colour = "purple", alpha = 0.5, size = 2) +
  xlab(paste0("PC3: ", round(percentVar[3] * 100), "% variance")) + 
  ylab(paste0("PC4: ", round(percentVar[4] * 100), "% variance")) + 
  coord_fixed()

#perform differential expression 
library("BiocParallel") 
dds_ <- DESeq(dds, parallel = T, BPPARAM = MulticoreParam(4)) #run this step on HPC which takes around 12h

#lists the coefficients & how to access to all calculated values
resultsNames(dds_)
#names(mcols(dds_))
mcols((dds_), use.names = T)[1:4,1:4]
#head(coef(dds_))
```

#get the tobacco variable
res_toba <- results(dds_, name = "tobacco_binary_Yes_vs_No", parallel = T, BPPARAM = MulticoreParam(4))
summary(res_toba)
mcols(res_toba,use.names=T) 
table(res_toba$padj < 0.1 & abs(res_toba$log2FoldChange) >1)

#volcano plot--tobacco
alpha <- 0.1 #Threshold on the adjusted p-value
cols <- densCols(res_toba$log2FoldChange, -log10(res_toba$pvalue))
plot(res_toba$log2FoldChange, -log10(res_toba$padj), col=cols, panel.first=grid(),
     main="Volcano plot toba", xlab="Effect size: log2(fold-change)", ylab="-log10(adjusted p-value)", pch=20, cex=0.6)
abline(v=0)
abline(v=c(-1,1), col="brown")
abline(h=-log10(alpha), col="brown")

gn.selected <- abs(res_toba$log2FoldChange) > 1 & res_toba$padj < alpha 
text(res_toba$log2FoldChange[gn.selected], -log10(res_toba$padj)[gn.selected], lab=rownames(res_toba)[gn.selected], cex=0.6, font = 2)
