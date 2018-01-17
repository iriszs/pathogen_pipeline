#script to create excel file with the basepairs per pathogen. if pathogen not present, 0 bp.


files_without_unknown <- list.files(path="/media/imgorter/1TB_Seagate/Plot_data/barplot/bp_per_pathogen/without_unknown/", pattern = "*.txt", full.names=TRUE, recursive=FALSE)

pathogens <- ""

#create pathogen list
for (x in files_without_unknown) {
  data <- read.table(x, sep = "\t")[1] # load file
  data <- unlist(data)
  print(as.character(data))
  pathogens <- unique(c(pathogens, as.character(data)))
}

#create dataframe with pathogen, origin samplename and number of bp
for (x in files_without_unknown){
  filename <- tools::file_path_sans_ext(x)
  splitted <- strsplit(filename, "/")[[1]]
  basename <- tail(splitted[[10]])

  rownames(df) <- pathogens
  colnames(df) <- basename
  df[which(is.na(df)),1] <-  0
  data <- read.table(x, sep = "\t")# load file
  newdf <- data[match(rownames(df), data[,1]),]
  newdf[which(is.na(newdf[,2])),2]  <- 0
  df <- df + newdf[,2]
  df[!grepl("REVERSE", df$Name),]
  df$pathogens <- pathogens
  filelocation <- paste("/media/imgorter/1TB_Seagate/Plot_data/Heatmap/xlsx/", basename, ".xlsx", sep="")
  print(filelocation)
  write.xlsx(df, filelocation)
  print(names(df))
  print(names(all))
  print(identical(names(all), names(df) ))
  #all <- rbind(all, df)
  
}

