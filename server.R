# Need to change this so that
# data is set at the beginning (rnorm)
# and changing inputs changes the sd/means (don't call rnorm)

set_dataframe<-function(m1, m2, m3, sd, n){
  trt1<-rnorm(30)
  trt1<-(trt1-mean(trt1))/sd(trt1)
  trt1<-trt1*sd+5
  trt2<-rnorm(30)
  trt2<-(trt2-mean(trt2))/sd(trt2)
  trt2<-trt2*sd+0
  trt3<-rnorm(30)
  trt3<-(trt3-mean(trt3))/sd(trt3)
  trt3<-trt3*sd-5
  data<-data.frame(trt=c(rep(1,30),rep(2,30),rep(3,30)),
                   values=c(trt1,trt2,trt3))
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
  
  library(ggplot2)
  library(plyr)
  
  
  output$text <- renderText({ 
    paste("You have selected", input$overall_sd)
  })
  
  data<-reactive({
    set_dataframe(5, 0, -5, input$overall_sd, 30)
  })
  

  
  ## Plots
  ## Use color=NA to make things disappear
  ## This way you don't have to worry about fixing the scales and everything
  # Plain data
  output$plot <- renderPlot({
    ggplot(data=data(), aes(values)) +
      geom_density() +
      geom_line(aes(y = density), data = set_grid(data()), colour = 'red') +
      stat_function(fun=dnorm, color='blue', args=list(mean=mean(data()$values), sd=sd(data()$values)))  +
      facet_wrap(~trt, ncol=1)
  })
        
  # Graphs are good
  # Now, summary stats
  
  output$anova_table<-renderTable(
    data.frame(summary(aov(values ~ trt, data()))[[1]])
  )
  
  
  }
)