# This file is for testing out a visualization on ANOVA

library(ggplot2)
library(plyr)

mu_1<--5
mu_2<-0
mu_3<-5

sd<-2.5

n<-90
n<-n/3

data<-rbind(data.frame(trt=rep(1,n),values=rnorm(n=n,mean=mu_1,sd=sd)),
            data.frame(trt=rep(2,n),values=rnorm(n=n,mean=mu_2,sd=sd)),
            data.frame(trt=rep(3,n),values=rnorm(n=n,mean=mu_3,sd=sd)))
data

# http://stackoverflow.com/questions/1376967/using-stat-function-and-facet-wrap-together-in-ggplot2-in-r
grid <- with(data, seq(min(values), max(values), length = 100))
normaldens <- ddply(data, "trt", function(df) {
  data.frame( 
    values = grid,
    density = dnorm(grid, mean(df$values), sd(df$values))
  )
})

ggplot(data=data, aes(values)) +
  geom_density() +
  geom_line(aes(y = density), data = normaldens, colour = "red") +
  stat_function(fun=dnorm, color="blue", args=list(mean=mean(data$values), sd=sd(data$values)))  +
  facet_wrap(~trt, ncol=1)


