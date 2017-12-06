library(ggplot2)
library(edgeR)
library(scales)


#files <- list.files(path="/media/imgorter/6CEC0BDEEC0BA186/imgorter/barplot_data/pileup/combined/bp_per_pathogen/with_unknown/CSV", pattern="*.csv", full.names=T, recursive=FALSE)
files <- list.files(path="/media/imgorter/6CEC0BDEEC0BA186/imgorter/barplot_data/pileup/combined/bp_per_pathogen", pattern="*.txt", full.names=T, recursive=FALSE)

hmcol <- colorRampPalette(c("magenta2", "dodgerblue3", "white", "tan1", "firebrick3")) (n=54)

###############################################################################################
#create empty dataframe
completeDF <- data.frame(pathogen=character(),
                         bp=numeric(), 
                         sample=character(), 
                         cpm=numeric(),
                         stringsAsFactors=FALSE) 
###############################################################################################

pathogens <- ""

for (x in files) {
  data <- read.table(x, sep = "\t")[1] # load file
  #data <- read.csv(x)[1]
  data <- unlist(data)
  print(as.character(data))
  pathogens <- unique(c(pathogens, as.character(data)))
}

pathogens <- pathogens[which(pathogens!= "")]

for (x in files){
  #some files are in txt format, some files are in csv
  data <- read.table(x, sep = "\t") # load file
  #data <- read.csv(x) # load file
  #get the filename, filename without path and filename without extension
  filename <- tools::file_path_sans_ext(x)
  splitted <- strsplit(filename, "/")[[1]]
  #the basename differs between files, because of the length of the path
  #basename <- tail(splitted[[12]])
  basename <- tail(splitted[[10]])
  #combine the dataframe per file to one dataframe
  data <- cbind(data, rep(basename, nrow(data)))
  #set the colnames of the dataframe
  colnames(data) <- c("pathogen", "bp", "sample")
  #perform a CPM on the basepair data to normalize
  data$cpm <- cpm(data$bp)
  completeDF <- rbind(completeDF, data)
  #completeDF <- completeDF[!grepl("Escherichia coli", completeDF$pathogen), ]
  
  
}


ggplot(completeDF,aes(x = sample, y = cpm, fill = pathogen)) +
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = percent_format()) + theme(legend.position = "right") +
  theme(axis.text.x = element_text(size=9, angle=90)) + scale_fill_manual(values=hmcol)


############################################################
#plot the mean for every cohort
############################################################


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
    theme(axis.text.x = element_text(size=9, angle=45)) + scale_fill_manual(values=hmcol)
  # geom_text(aes(label = rownames(df)), size = 3, hjust = 0.5, vjust = 3, position =     "stack")
}


#create PDF
pdf("Desktop/mean_pathogenFiles.pdf")

plot_mean(BR_MG_files, "BR_MG_files", "none")
plot_mean(BR_WB_files, "BR_WB_files", "none")
plot_mean(NL_MG_files, "NL_MG_files", "none")
dev.off()


pdf("Desktop/mean_pathogenFiles_legend.pdf")
plot_mean(BR_MG_files, "BR_MG_files", "right")
plot_mean(BR_WB_files, "BR_WB_files", "right")
plot_mean(NL_MG_files, "NL_MG_files", "right")
dev.off()