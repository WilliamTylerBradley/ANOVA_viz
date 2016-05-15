# This file is for testing out a visualization on ANOVA

library(ggplot2)
library(plyr)

mu_1<--5
mu_2<-0
mu_3<-2.5

sd<-2.5

n<-90
n<-n/3

data<-rbind(data.frame(trt=rep('Trt 1',n),values=rnorm(n=n,mean=mu_1,sd=sd)),
            data.frame(trt=rep('Trt 2',n),values=rnorm(n=n,mean=mu_2,sd=sd)),
            data.frame(trt=rep('Trt 3',n),values=rnorm(n=n,mean=mu_3,sd=sd)))
data

# http://stackoverflow.com/questions/1376967/using-stat-function-and-facet-wrap-together-in-ggplot2-in-r
grid <- with(data, seq(min(values)-sd(values), max(values)+sd(values), length = 100))
normaldens <- ddply(data, "trt", function(df) {
  data.frame( 
    values = grid,
    density = dnorm(grid, mean(df$values), sd(df$values))
  )
})

## Plots
## Use color=NA to make things disappear
## This way you don't have to worry about fixing the scales and everything
# Plain data
ggplot(data=data, aes(values)) +
  geom_density() +
  geom_line(aes(y = density), data = normaldens, colour = NA) +
  stat_function(fun=dnorm, color=NA, args=list(mean=mean(data$values), sd=sd(data$values)))  +
  facet_wrap(~trt, ncol=1)

# Data with Null
ggplot(data=data, aes(values)) +
  geom_density() +
  geom_line(aes(y = density), data = normaldens, colour = NA) +
  stat_function(fun=dnorm, color="blue", args=list(mean=mean(data$values), sd=sd(data$values)))  +
  facet_wrap(~trt, ncol=1)

# Comparison
ggplot(data=data, aes(values)) +
  geom_density(color=NA) +
  geom_line(aes(y = density), data = normaldens, colour = "red") +
  stat_function(fun=dnorm, color="blue", args=list(mean=mean(data$values), sd=sd(data$values)))  +
  facet_wrap(~trt, ncol=1)

# Graphs are good
# Now, summary stats

aov(values ~ trt, data)

sum_of_squares<-function(data){
  sum( (data-mean(data))^2 )
}

sum((data$values-mean(data$values))^2)
sum_of_squares(data$values)


sse_1<-ddply(data, "trt", summarise, SSE=sum_of_squares(values))
sse<-sum(sse_1$SSE)

means<-ddply(data, "trt", summarise, values=mean(values))
sum_of_squares(means$values)



dt_trt<-nlevels(data$trt)-1
dt_e<-fds

# Backup, get this instead

trt1<-rnorm(30)
trt1<-(trt1-mean(trt1))/sd(trt1)
trt1<-trt1*2.5+5
trt2<-rnorm(30)
trt2<-(trt2-mean(trt2))/sd(trt2)
trt2<-trt2*2.5+0
trt3<-rnorm(30)
trt3<-(trt3-mean(trt3))/sd(trt3)
trt3<-trt3*2.5-5

data<-data.frame(trt=c(rep(1,30),rep(2,30),rep(3,30)),
                 values=c(trt1,trt2,trt3))
#data
aov(values ~ trt, data)
