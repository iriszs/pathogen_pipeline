library(ggplot2)
library(RColorBrewer)
library(scales)
library(edgeR)



###############################################################################################
#create empty dataframe
completeDF <- data.frame(pathogen=character(),
                         bp=numeric(), 
                         sample=character(), 
                         cpm=numeric(),
                         stringsAsFactors=FALSE) 
###############################################################################################

#two different list of files. One with files that also contain the unidentified, one without
#files <- list.files(path="/media/imgorter/1TB_Seagate/barplot_data/pileup/combined/bp_per_pathogen", pattern="*.txt", full.names=T, recursive=FALSE)
files <- list.files(path="/media/imgorter/1TB_Seagate/Plot_data/barplot/bp_per_pathogen/without_unknown", pattern="*.txt", full.names=T, recursive=FALSE)

#create a color palette that uses continues colors
hmcol <- colorRampPalette(c("magenta2", "dodgerblue3", "white", "tan1", "firebrick3")) (n=54)

###############################################################################################

for (x in files){
  #read table
  data <- read.table(x, sep="\t") # load file
  #get the filename, filename without path and filename without extension
  filename <- tools::file_path_sans_ext(x)
  splitted <- strsplit(filename, "/")[[1]]
  #get the basename of the file
  basename <- tail(splitted[[9]])
  #combine the dataframe per file to one dataframe
  newdata <- data
  data <- cbind(data, rep(basename, nrow(data)))
  #set the colnames of the dataframe
  colnames(data) <- c("pathogen", "bp", "sample")
  #perform a CPM on the basepair data to normalize
  data$cpm <- cpm(data$bp)
  completeDF <- rbind(completeDF, data)
}

library(xlsx)
#write back to excel file
write.xlsx(completeDF, "/media/imgorter/1TB_Seagate/Plot_data/Heatmap/bp_per_sample.xlsx") 



###############################################################################################

###############################################################################################

#plot creation
ggplot(completeDF,aes(x = sample, y = cpm, fill = pathogen)) +
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = percent_format()) + theme(legend.position = "right") +
  theme(axis.text.x = element_text(size=9, angle=90)) + scale_fill_manual(values=hmcol)

###############################################################################################

###############################################################################################



pathogens <- ""
for (x in files) {
  #data <- read.table(x, sep = "\t")[1] # load file
  data <- read.csv(x)[1]
  data <- unlist(data)
  print(as.character(data))
  pathogens <- unique(c(pathogens, as.character(data)))
}

length(pathogens)
pathogens <- pathogens[which(pathogens!= "")]


#get all files per group
BR_WB_files <- grep("BR_WB", files, value=TRUE)
BR_MG_files <- grep("BR_MG", files, value=TRUE)
NL_MG_files <- grep("NL_MG", files, value=TRUE)

#function to plot the mean of every group
plot_mean <- function(file,desiredName, legendPos){
  #get the filename, and basename without extension 
  filename <- tools::file_path_sans_ext(file)
  splitted <- strsplit(filename, "/")[[1]]
  #basename <- tail(splitted[[8]])
  basename <- tail(splitted[[10]])
  #create new dataframe
  df <- data.frame(matrix(ncol = 1, nrow = length(pathogens)))
  #set rownames en colnames 
  rownames(df) <- pathogens
  colnames(df) <- "bp"
  df[which(is.na(df)),1] <-  0
  for (x in file) {
    #data <- read.table(x, sep = "\t")# load file
    data <- read.csv(x)
    newdf <- data[match(rownames(df), data[,1]),]
    newdf[which(is.na(newdf[,2])),2]  <- 0
    df <- df + newdf[,2]
  }
  df[,1] <- df[,1]/length(file)
  df[,2] <- rep(desiredName, length(pathogens))
  df <- as.data.frame(df)
  #perform CPM normalisation on 
  df$cpm <- cpm(df$bp)
  df$pathogen <- row.names(df)
  print(df$pathogen[order(df$bp, decreasing = T)])
  ggplot(df,aes(x = V2, y = cpm, fill = pathogen)) +
    geom_bar(position = "fill",stat = "identity") +
    scale_y_continuous(labels = percent_format()) + theme(legend.position = legendPos) +
    theme(axis.text.x = element_text(size=9, angle=45)) + scale_fill_manual(values=hmcol)
    # geom_text(aes(label = rownames(df)), size = 3, hjust = 0.5, vjust = 3, position =     "stack")
}


#create PDF
pdf("Desktop/mean_pathogenFiles.pdf")
# Top 5:
# Escherichia coli              
# Toxoplasma gondii          
# Cryptococcus gattii
# Toxocara canis  
# Trichinella spiralis
plot_mean(BR_MG_files, "BR_MG_files", "none")
# Toxoplasma gondii
# Toxocara canis
# Trichinella spiralis
# Cryptococcus gattii
# Solanum lycopersicum
plot_mean(BR_WB_files, "BR_WB_files", "none")
# Toxoplasma gondii
# Toxocara canis
# Pseudomonas aeruginosa
# Trichinella spiralis         
# Cryptococcus gattii
plot_mean(NL_MG_files, "NL_MG_files", "none")
dev.off()


pdf("Desktop/mean_pathogenFiles_legend.pdf")
plot_mean(BR_MG_files, "BR_MG_files", "right")
plot_mean(BR_WB_files, "BR_WB_files", "right")
plot_mean(NL_MG_files, "NL_MG_files", "right")
dev.off()





