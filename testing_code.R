# This file is for testing out a visualization on ANOVA

library(ggplot2)
library(plyr)

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
  geom_density(fill="black") +
  geom_line(aes(y = density), data = normaldens, colour = "red") +
  stat_function(fun=dnorm, color=NA, args=list(mean=mean(data$values), sd=sd(data$values)))  +
  facet_wrap(~trt, ncol=1)

# Graphs are good
# Now, summary stats

anova_table<-data.frame(summary(aov(values ~ trt, data))[[1]])

#### Looks good
## Input list:                 _
#   Overall Standard Deviation  |
#   Trt 1 Mean                  |- Sliders?
#   Trt 2 Mean                  |
#   Trt 3 Mean                 _|
#   N, (needs to be a multiple of three)
#   Options for showing the different distributions - Check boxes
#   Option for resetting the data - action button
#
## Output list:
#   Input option list - Next to inputs
#   Graphs
#   Anova Table
#   Texts explaining everything