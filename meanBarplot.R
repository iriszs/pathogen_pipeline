library(ggplot2)
library(edgeR)
library(scales)

############################################################
#plot the mean for every cohort
############################################################

hmcol <- colorRampPalette(c("magenta2", "dodgerblue3", "white", "tan1", "firebrick3")) (n=56)

#get files
files_with_unknown <- list.files(path="/media/imgorter/1TB_Seagate/Plot_data/barplot/bp_per_pathogen/with_unknown", pattern="*.csv", full.names=TRUE, recursive=FALSE)
files_without_unknown <- list.files(path="/media/imgorter/1TB_Seagate/Plot_data/barplot/bp_per_pathogen/without_unknown/", pattern = "*.txt", full.names=TRUE, recursive=FALSE)

#save filenames per cohort
BR_WB_files <- grep("BR_WB", files_with_unknown, value=TRUE)
BR_MG_files <- grep("BR_MG", files_with_unknown, value=TRUE)
NL_MG_files <- grep("NL_MG", files_with_unknown, value=TRUE)
Biopsy_files <- grep("Biopsy_", files_with_unknown, value=TRUE)

BR_WB_files <- grep("BR_WB", files_without_unknown, value=TRUE)
BR_MG_files <- grep("BR_MG", files_without_unknown, value=TRUE)
NL_MG_files <- grep("NL_MG", files_without_unknown, value=TRUE)
Biopsy_files <- grep("Biopsy_", files_without_unknown, value=TRUE)


pathogens <- ""
#make a vector of all pathogens
for (x in files_with_unknown) {
  data <- read.table(x, sep = ",")[1] # load file
  data <- unlist(data)
  print(as.character(data))
  pathogens <- unique(c(pathogens, as.character(data)))
}

for (x in files_without_unknown) {
  data <- read.table(x, sep = "\t")[1] # load file
  data <- unlist(data)
  print(as.character(data))
  pathogens <- unique(c(pathogens, as.character(data)))
}


pathogens <- pathogens[which(pathogens != "")]


#function to plot the mean of every group
plot_mean <- function(file,desiredName, legendPos, fileSeperator){
  #get the filename, and basename without extension 
  # filename <- tools::file_path_sans_ext(file)
  filename <- tools::file_path_sans_ext(BR_MG_files)
  splitted <- strsplit(filename, "/")[[1]]
  basename <- tail(splitted[[8]])
  #create new dataframe
  df <- data.frame(matrix(ncol = 1, nrow = length(pathogens)))
  print(df)
  #set rownames en colnames 
  rownames(df) <- pathogens
  colnames(df) <- "bp"
  df[which(is.na(df)),1] <-  0
  for (x in file) {
    data <- read.table(x, sep = "\t")# load file
    newdf <- data[match(rownames(df), data[,1]),]
    newdf[which(is.na(newdf[,2])),2]  <- 0
    df <- df + newdf[,2]
    df[!grepl("REVERSE", df$Name),]
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
    theme(axis.text.x = element_text(size=9, angle=90)) + scale_fill_manual(values=hmcol)
  # geom_text(aes(label = rownames(df)), size = 3, hjust = 0.5, vjust = 3, position =     "stack")
}


#create PDF
pdf("Documents/mean_pathogenFiles.pdf")

#plot_mean(BR_MG_files, "BR_MG_files", "none", ",")
#plot_mean(BR_WB_files, "BR_WB_files", "none", ",")
#plot_mean(NL_MG_files, "NL_MG_files", "none", ",")
#plot_mean(Biopsy_files, "Biopsy_files", "none", ",")

plot_mean(BR_MG_files, "BR_MG_files", "none", "\t")
plot_mean(BR_WB_files, "BR_WB_files", "none", "\t")
plot_mean(NL_MG_files, "NL_MG_files", "none", "\t")
plot_mean(Biopsy_files, "Biopsy_files", "none", "\t")

dev.off()


pdf("Documents/mean_pathogenFiles_legend.pdf")
#plot_mean(BR_MG_files, "BR_MG", "right", ",")
#plot_mean(BR_WB_files, "BR_WB", "right", ",")
#plot_mean(NL_MG_files, "NL_MG", "right", ",")
#plot_mean(Biopsy_files, "Biopsy", "right", ",")

plot_mean(BR_MG_files, "BR_MG", "right", "\t")
plot_mean(BR_WB_files, "BR_WB", "right", "\t")
plot_mean(NL_MG_files, "NL_MG", "right", "\t")
plot_mean(Biopsy_files, "Biopsy", "right", "\t")

dev.off()
