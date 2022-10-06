library(readr)
install.packages("ggplot2")
library(ggplot2)
install.packages("scatterplot3d", dependencies = TRUE)
library(scatterplot3d)
install.packages("rgl")
library(rgl)
#-------------------- Reading the data into R ---------------------------
#   n = number of vertices
#   p = arc probability (0 <= p <= 1)
#   r = maximum range of capacity
#   s = random seed 
#   f = output file name

# my EDA data 

df <- read.csv(file = "/Users/tiagodelgado/mei-proj/resultsEDAv1.csv", header=TRUE)

df$n_vert

df$prob

df$range

df$seed

df$Dinic_time

df$EK_time

df$MPM_time

#------------------------ Data Visualization ---------------------------------

summary(df)

#------------------------ Linear Regression ---------------------------------

lr.out = (lm(df$Dinic_time~df$n_vert)) #relatório

summary(lr.out) #relatório

lr.out = (lm(sqrt(df$Dinic_time)~df$n_vert)) #relatório

summary(lr.out) #relatório

lr.out = lm(log(df$Dinic_time)~df$n_vert) #relatório

summary(lr.out) #relatório

plot(lm(log(df$Dinic_time)~df$n_vert)) #relatório

plot(df$n_vert, df$Dinic_time)

myline <- lm(df$Dinic_time~df$n_vert)
abline(myline, lwd=2)
summary(myline)

boxplot(df$Dinic_time)

plot(density(df$Dinic_time), col="red")

qqnorm(as.vector(df$Dinic_time))
qqline(as.vector(df$Dinic_time))

plot(df$n_vert, df$EK_time)
plot(df$n_vert, df$MPM_time)



