# Need to move these function to a helper file
# and clean up reactivity

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
  data$trt<-as.factor(data$trt) # DON'T FORGET THIS!
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
  data$trt<-as.factor(data$trt) # DON'T FORGET THIS!
  
  return(data)
}

set_grid<-function(data){
  # http://stackoverflow.com/questions/1376967/using-stat-function-and-facet-wrap-together-in-ggplot2-in-r
  grid <- with(data, seq(min(values)-sd(values), max(values)+sd(values), length = 100))
  normaldens <- ddply(data, "trt", function(df) {
    data.frame( 
      values = grid,
      density = dnorm(grid, mean(df$values), sd(df$values))
    )
  })
  return(normaldens)
}


shinyServer(function(input, output) {
  
  # Do these go here?
  library(ggplot2)
  library(plyr)
  
    
  start_data<-reactive({
    start_dataframe(5, 0, -5, 2.5, input$n_size)
  })    
  
  data<-reactive({
    adjust_dataframe(input$mean_1, input$mean_2, input$mean_3, input$overall_sd, start_data())
  })
  

  
  # Plots
  # Use color=NA to make things disappear
  # This way you don't have to worry about fixing the scales and everything
  output$plot <- renderPlot({
    
    trt_color <- reactive({
      if (input$show_trt) {
        return("red")
      }
      else {
        return(NA)
      }
    })
    
    overall_color <- reactive({
      if (input$show_overall) {
        return("blue")
      }
      else {
        return(NA)
      }
    })
    
    ggplot(data=data(), aes(values)) +
      geom_density() +
      geom_line(aes(y = density), data = set_grid(data()), colour = trt_color()) +
      stat_function(fun=dnorm, color=overall_color(), args=list(mean=mean(data()$values), sd=sd(data()$values)))  +
      facet_wrap(~trt, ncol=1)
  })
        
  # Graphs are good
  # Now, summary stats
  
  output$anova_table<-renderTable(
    data.frame(summary(aov(values ~ trt, data()))[[1]])
  )
  
  
  }
)