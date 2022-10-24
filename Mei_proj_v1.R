library(readr)
install.packages("ggplot2")
library(ggplot2)
install.packages("scatterplot3d", dependencies = TRUE)
library(scatterplot3d)
install.packages("rgl")
library(rgl)
#-------------------- Reading the data into R ---------------------------
#   n_vert = number of vertices
#   prob = arc probability (0 <= p <= 1)
#   range = maximum range of capacity
#   seed = random seed
#   _time = time in secs

# my EDA data 

df <- read.csv(file = "/Users/tiagodelgado/mei-proj/resultsEDAv1.csv", header=TRUE)

df$n_vert

df$prob

df$range

df$seed

df$Dinic_time

df$EK_time

df$MPM_time

#------------------------ Data Summary --------------------------------------

summary(df)

#------------------------ Linear Regression ---------------------------------


lr.out = ((df$Dinic_time)~df$n_vert+df$prob*df$n_vert) # sabemos que o algo Dinic é quadratico 

summary(lr.out) 

lr.out = (lm(log(df$Dinic_time)~df$n_vert+df$prob*df$n_vert)) # sabemos que o algo Dinic é quadratico 

summary(lr.out) 

lr.out = (lm(log(df$EK_time)~df$n_vert+df$prob*df$n_vert)) # sabemos que o algo EK é quadratico 

summary(lr.out) 

lr.out = (lm(log(df$MPM_time)~df$n_vert+df$prob*df$n_vert)) #  sabemos que o algo MPM é cubico 

summary(lr.out) 

#------------------------ Data Visualization ---------------------------------

plot(df$Dinic_time~df$n_vert)
plot(df$EK_time~df$n_vert)
plot(df$MPM_time~df$n_vert)

scatterplot3d(df$Dinic_time~df$n_vert+df$prob*df$n_vert)

scatterplot3d(df$EK_time~df$n_vert+df$prob*df$n_vert)

scatterplot3d(df$MPM_time~df$n_vert+df$prob*df$n_vert)

plot(df)

myline <- lm(df$Dinic_time~df$n_vert)
abline(myline, lwd=2)
summary(myline)

boxplot(df$Dinic_time)
boxplot(df$EK_time)
boxplot(df$MPM_time)

plot(density(df$Dinic_time), col="red")

qqnorm(as.vector(df$Dinic_time))
qqline(as.vector(df$Dinic_time))


plot(density(df$Dinic_time),col="red",main = 'dinic.ccp cpu time  Density ') # relatório

plot(density(df$EK_time),col="red",main = 'EK.cpp cpu time Density ') # relatório

plot(density(df$MPM_time),col="red",main = 'MPM.cpp cpu time Density ') # relatório

hist(df$Dinic_time,prob=TRUE, breaks=10)
lines(density(df$Dinic_time), lwd = 2)

hist(df$Dinic_time, nbins = "FD", col = "grey", prob = TRUE, 
     ylab = "Density", main = "Dinic.cpp Histogram w/ Density line ")
rug(df$Dinic_time)
lines(density(df$Dinic_time) ,col = "red",lwd = 2)

hist(df$n_vert,freq=TRUE, breaks=15)
lines(df$n_vert, col="blue")

boxplot(df$Dinic_time~df$n_vert) # relatorio
boxplot(df$EK_time~df$n_vert) # relatorio
boxplot(df$MPM_time~df$n_vert) # relatorio


boxplot(df$Dinic_time~df$prob,
        col = rainbow(ncol(trees)))

par(mfrow = c(1, ncol(trees)))
invisible(lapply(1:ncol(trees), function(i) boxplot(trees[, i])))

#----QQ-PLOT--------------  

qqnorm(df$Dinic_time,
       col="red", lwd=1, pch=20,
       ylab = 'Time in sec',
       main = 'Dinic.cpp Time performance')
qqline(df$Dinic_time)

qqnorm(df$EK_time,
       col="red", lwd=1, pch=20,
       ylab = 'Time in sec',
       main = 'EK.cpp Time performance')

qqnorm(df$MPM_time,
       col="red", lwd=1, pch=20,
       ylab = 'Time in sec',
       main = 'MPM.cpp Time performance')




