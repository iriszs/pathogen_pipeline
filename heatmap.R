library(heatmap3)
library(openxlsx)
library(edgeR)

#read file that contains the basepairs of a pathogen per origin
basepairs <- read.csv("/media/imgorter/1TB_Seagate/Plot_data/Heatmap/bp_per_sample.csv")

#alter the dataframe 
target <- read.csv("/media/imgorter/1TB_Seagate/Plot_data/Heatmap/donor_list.csv")

row.names(target) <- target$Donor

row.names(target) <- toupper(row.names(target))

colnames(basepairs) <- toupper(colnames(basepairs))

target$Donor <- NULL

target$File_Name <- NULL

row.names(basepairs) <- basepairs$PATHOGENS

basepairs$PATHOGENS <- NULL

#normalization
basepairs <- cpm(basepairs)

basepairs <- as.matrix(basepairs)

head(target)
targetInterest <- target[c(2, 5)]
colnames(targetInterest) <- c("Age", "PMD")

#create colors for sequencers
sequencerCol <- rep("black", length(target$batch))
sequencerCol[which(target$batch == "clon")] <- "bisque2"
sequencerCol[which(target$batch == "illu")] <- "burlywood4"

#create colors for tissue
tissueCol <- rep("black", length(target$Microglia.Whole.Brain))
tissueCol[which(target$Microglia.Whole.Brain == "Biopsy")] <- "yellow"
tissueCol[which(target$Microglia.Whole.Brain == "Microglia")] <- "purple"
tissueCol[which(target$Microglia.Whole.Brain == "Whole Brain")] <- "aquamarine"

#gender colors
genderCol <- rep("black", length(target$Gender))
genderCol[which(target$Gender == "M")] <- "deepskyblue"
genderCol[which(target$Gender == "F")] <- "deeppink"

#cohort colors
cohortCol <- rep("black", length(target$Origin))
cohortCol[which(target$Origin == "Brazil")] <- "green"
cohortCol[which(target$Origin == "Netherlands")] <- "red"

#vector with all colors
colColor <- cbind(Sequencer = sequencerCol, Tissue = tissueCol, Gender = genderCol, Cohort = cohortCol) 

#heatmap creation
heatmap3(basepairs, scale="row", ColSideAnn = as.matrix(target), ColSideFun = function(x) showAnn(targetInterest), col=colorRampPalette(c("magenta2", "dodgerblue3", "white", "tan1", "firebrick3"))(999), ColSideWidth=1.2)

#create legens
showLegend(legend= c("Illumina", "Clone", "Biopsy", "Microglia", "Whole Brain", "Male", "Female", "Brazil", "Netherlands"), col = c("burlywood4", "bisque2", "yellow", "purple", "aquamarine", "deepskyblue", "deeppink", "green", "red"), cex = 0.7)

heatmap3(basepairs, ColSideColors = colColor)

showAnn(annData)

showAnn(ColSideAnn)
