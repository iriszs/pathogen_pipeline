library(ggplot2)
library(edgeR)
library(scales)

#get files
files <- list.files(path="/media/imgorter/6CEC0BDEEC0BA186/imgorter/barplot_data/pileup/combined/bp_per_pathogen/with_Phylum", pattern="*.txt", full.names=T, recursive=FALSE)

#create color palette
hmcol <- colorRampPalette(c("magenta2", "dodgerblue3", "white", "tan1", "firebrick3")) (n=15)

###############################################################################################
#create empty dataframe
completeDF <- data.frame(pathogen=character(),
                         bp=numeric(), 
                         sample=character(), 
                         cpm=numeric(),
                         phylum=character(),
                         stringsAsFactors=FALSE) 
###############################################################################################

pathogens <- ""

#create a vector of pathogen names
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
  basename <- tail(splitted[[11]])
  #combine the dataframe per file to one dataframe
  data <- cbind(data, rep(basename, nrow(data)))
  #set the colnames of the dataframe
  colnames(data) <- c("pathogen", "bp", "phylum", "sample")
  #perform a CPM on the basepair data to normalize
  data$cpm <- cpm(data$bp)
  completeDF <- rbind(completeDF, data)
  #completeDF <- completeDF[!grepl("Escherichia coli", completeDF$pathogen), ]
  
  
}

#plot
ggplot(completeDF,aes(x = sample, y = cpm, fill = phylum)) +
  geom_bar(position = "fill",stat = "identity") +
  scale_y_continuous(labels = percent_format()) + theme(legend.position = "right") +
  theme(axis.text.x = element_text(size=9, angle=90)) + scale_fill_manual(values=hmcol)


