start_dataframe<-function(m1, m2, m3, sd, n){
  trt1<-rnorm(n)
  trt1<-(trt1-mean(trt1))/sd(trt1)
  trt1<-trt1*sd+m1
  trt2<-rnorm(n)
  trt2<-(trt2-mean(trt2))/sd(trt2)
  trt2<-trt2*sd+m2
  trt3<-rnorm(n)
  trt3<-(trt3-mean(trt3))/sd(trt3)
  trt3<-trt3*sd+m3
  data<-data.frame(trt=c(rep(1,n),rep(2,n),rep(3,n)),
                   values=c(trt1,trt2,trt3))
  data$trt<-as.factor(data$trt)
  return(data)
}

adjust_dataframe<-function(m1, m2, m3, sd, data){
  
  data1<-data[data$trt==1,]
  data1$values<-(data1$values-mean(data1$values))/sd(data1$values)
  data1$values<-data1$values*sd+m1

  data2<-data[data$trt==2,]
  data2$values<-(data2$values-mean(data2$values))/sd(data2$values)
  data2$values<-data2$values*sd+m2
  
  data3<-data[data$trt==3,]
  data3$values<-(data3$values-mean(data3$values))/sd(data3$values)
  data3$values<-data3$values*sd+m3
  
  data<-rbind(data1, data2, data3)
  data$trt<-as.factor(data$trt)
  return(data)
}

start_data<-start_dataframe(0, 0, 0, 2.5, 30)  

data<-adjust_dataframe(0, 0, 5, 2.5, start_data)

data.frame(summary(aov(values ~ trt, start_data))[[1]])
data.frame(summary(aov(values ~ trt, data))[[1]])

m1<-mean(data$values[data$trt==1])
m2<-mean(data$values[data$trt==2])
m3<-mean(data$values[data$trt==3])

ss1<-sum( (data$values[data$trt==1] - m1)^2 )
ss2<-sum( (data$values[data$trt==2] - m2)^2 )
ss3<-sum( (data$values[data$trt==3] - m3)^2 )

ss1+ss2+ss3



