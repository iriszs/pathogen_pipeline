library(ggplot2)

#all data
data_HM <- read.csv("/media/imgorter/6CEC0BDEEC0BA186/imgorter/plot_data/dotplot/basepairs_per_origin.csv")

#data without contamination pathogens
data2 <- read.csv("/media/imgorter/6CEC0BDEEC0BA186/imgorter/plot_data/dotplot/basepairs_per_origin_without_contamination.csv")

data1 <- c(data_HM$NL_Microglia, data_HM$BR_Microglia, data_HM$BR_WholeBrain, data_HM$BR_Biopsy)
data1 <- as.data.frame(data1)
#set colnames
colnames(data1)[1] <- "basepairs"
#set origin names
data1$origin <- c(rep("NL_MG", 32), rep("BR_MG", 32), rep("BR_WB", 32), rep("BR_Biopsy", 32))

data2 <- c(data_HM$NL_Microglia, data_HM$BR_Microglia, data_HM$BR_WholeBrain, data_HM$BR_Biopsy)
data2 <- as.data.frame(data2)
#set colnames
colnames(data2)[1] <- "basepairs"
#set origin names
data2$origin <- c(rep("NL_MG", 32), rep("BR_MG", 32), rep("BR_WB", 32), rep("BR_Biopsy", 32))

#plot dotplot for the normal basepair data
plot <- ggplot(data=data1, aes(x=origin, y=basepairs)) + geom_point(na.rm = TRUE,  size=3) + 
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar", width = .5, na.rm = T) +
  stat_summary(geom = "errorbar", fun.y = mean, aes(ymin = ..y.., ymax = ..y..), na.rm = T)
plot

#plot dotplot for the basepair data without contamination
plot2 <- ggplot(data=data2, aes(x=origin, y=basepairs)) + geom_point(na.rm = TRUE,  size=3) + 
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar", width = .5, na.rm = T) +
  stat_summary(geom = "errorbar", fun.y = mean, aes(ymin = ..y.., ymax = ..y..), na.rm = T)
plot2


#combine the plots
p <- ggplot() +
  geom_point(data=data1, aes(x=origin, y=basepairs, colour="with possible contamination pathogens"), na.rm = TRUE) +
  geom_point(data=data2, aes(x=origin, y=basepairs, colour="without possible contamination pathogens"), na.rm = TRUE)
p

########################################################################################################################

########################################################################################################################

combinedData <- read.csv("/media/imgorter/6CEC0BDEEC0BA186/imgorter/plot_data/dotplot/combined.csv")

df <- c(combinedData$NL_Microglia, combinedData$NL_Microglia_no_Cont, combinedData$BR_Microglia, combinedData$BR_Microglia_no_Cont, combinedData$BR_WholeBrain, combinedData$BR_WholeBrain_no_Cont, combinedData$BR_Biopsy, combinedData$BR_Biopsy_no_Cont)
df <- as.data.frame(df)
colnames(df)[1] <- "basepairs"
df$origin <- c(rep("NL_MG_All", 32), rep("NL_MG", 32), rep("BR_MG_All", 32), rep("BR_MG", 32) ,rep("BR_WB_All", 32), rep("BR_WB", 32) ,rep("BR_Biopsy_All", 32), rep("BR_Biopsy", 32))
df$contamination <- c(rep("Yes", 32), rep("No", 32), rep("Yes", 32), rep("No", 32) ,rep("Yes", 32), rep("No", 32) ,rep("Yes", 32), rep("No", 32))

plot <- ggplot(data=df, aes(x=origin, y=basepairs, color=contamination)) + geom_point(na.rm = TRUE,  size=3) + 
  stat_summary(fun.data = "mean_cl_boot", geom = "errorbar", width = .5, na.rm = T) +
  stat_summary(geom = "errorbar", fun.y = mean, aes(ymin = ..y.., ymax = ..y..), na.rm = T) + theme(axis.text.x = element_text(size=9, angle=90))
plot

scale_color_manual(name = "Colors", values = c(df$origin = "black", "(17,19]" = "yellow", "(19, Inf]" = "red"), labels = c("<= 17", "17 < qsec <= 19", "> 19"))


