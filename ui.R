library(shiny)

shinyUI(fluidPage(
  
  verticalLayout(
    titlePanel("ANOVA"),
    
    helpText("This section will discuss ANOVA"),
    
    
    
    sidebarLayout(
      sidebarPanel(
        helpText("This will have the inputs section.")
      ),
          
      mainPanel(
        helpText("This will have the graphs"),        
        helpText("This will have the table")
      )
    ),
    
    helpText("Some more help text here.")
  )  
))
