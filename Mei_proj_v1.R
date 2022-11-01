library(readr)
install.packages("ggplot2")
library(ggplot2)
install.packages("scatterplot3d", dependencies = TRUE)
library(scatterplot3d)
install.packages("rgl", dependencies = TRUE)
library(rgl)
options(rgl.printRglwidget = TRUE)
#-------------------- Reading the data into R ---------------------------
#   n_vert = number of vertices
#   prob = arc probability (0 <= p <= 1)
#   range = maximum range of capacity
#   seed = random seed
#   _time = time in secs

# my EDA data 

df <- read.csv(file = "/Users/tiagodelgado/mei-proj/resultsEDAv3.csv", header=TRUE)

df$n_vert

df$prob

df$range

df$seed

df$Dinic_time

df$EK_time

df$MPM_time

df$A

#------------------------ Data Summary --------------------------------------
summary(df)

summary(df$Dinic_time)
summary(df$EK_time)
summary(df$MPM_time)

#------------------------ Linear Regression ---------------------------------

lr.out = lm((df$Dinic_time)~df$A+df$n_vert) 
summary(lr.out)

lr.out = lm((df$Dinic_time)~df$A+I(df$n_vert^2))  
summary(lr.out)

lr.out = lm((df$Dinic_time)~df$A+I(df$n_vert^3)) 
summary(lr.out)

#------------------------ Transformation ---------------------------------

lr.out = lm(log(df$Dinic_time)~df$A+df$n_vert)
summary(lr.out)

lr.out = lm(log(df$Dinic_time)~df$A+I(df$n_vert^2))
summary(lr.out)

lr.out = lm(log(df$Dinic_time)~df$A+I(df$n_vert^3))
summary(lr.out)

#------------------------ Data Visualization ---------------------------------

plot(df$Dinic_time~df$A, xlab = 'A', ylab = 'Dinic_time',
     main = 'Dinic.cpp')

plot(df$Dinic_time~df$n_vert, xlab = 'n_vert', ylab = 'Dinic_time',
     main = 'Dinic.cpp')

plot(df$EK_time~df$n_vert, xlab = 'n_vert', ylab = 'Dinic_time',
     main = 'EK.cpp')

plot(df$MPM_time~df$n_vert, xlab = 'n_vert', ylab = 'Dinic_time',
     main = 'MPM.cpp')

plot(df$EK_time~df$A, xlab = 'A', ylab = 'EK_time',
     main = 'EK.cpp')

plot(df$MPM_time~df$A, xlab = 'A', ylab = 'MPM_time',
     main = 'MPM.cpp')

plot(lm((df$Dinic_time)~df$A+df$n_vert)) 

plot(lm((df$Dinic_time)~df$A+I(df$n_vert^2)))

plot(lm((df$Dinic_time)~df$A+I(df$n_vert^3)))

plot3d(x = df$A, y =df$prob, z =df$Dinic_time,
       xlab = 'n_vertices', ylab = 'prob', zlab = 'cpu_time',
       main = 'Dinic.cpp')

scatterplot3d(x = df$n_vert, y =df$prob, z =df$Dinic_time,
              xlab = 'n_vert', ylab = 'prob', zlab = 'cpu_time',
              main = 'Dinic.cpp',angle=25)

scatterplot3d(x = df$A, y =df$prob, z =df$EK_time,
              xlab = 'A', ylab = 'prob', zlab = 'cpu_time',
              main = 'EK.cpp')

scatterplot3d(x = df$A, y =df$prob, z =df$MPM_time,
              xlab = 'A', ylab = 'prob', zlab = 'cpu_time',
              main = 'MPM.cpp')

plot(df)

myline <- lm(df$Dinic_time~df$n_vert)
abline(myline, lwd=2)
summary(myline)

boxplot(log(df$Dinic_time))
boxplot(df$EK_time)
boxplot(df$MPM_time)

boxplot(df$Dinic_time~df$n_vert) 
boxplot(df$EK_time~df$n_vert) 
boxplot(df$MPM_time~df$n_vert) 

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

boxplot(df$EK_time~df$n_vert, data = df,
        varwidth = TRUE, las = 1)

boxplot(df$Dinic_time~df$n_vert,
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

