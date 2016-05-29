library(shiny)

shinyUI(fluidPage(
  
  verticalLayout(
    titlePanel("ANOVA"),
    
    helpText("This section will discuss ANOVA"),
    
    sidebarLayout(
      sidebarPanel(
        helpText("This will have the inputs section."),
        
         sliderInput(inputId = "overall_sd", 
                     label = "Standard Deviation",
                     min = 1,
                     max = 5,
                     value = 2.5,
                     step=.1)
      ),
          
      mainPanel(
        helpText("This will have the graphs"), 
        
        plotOutput("plot"),
        
        helpText("This will have the table"),
        
        tableOutput('anova_table'),
        
        textOutput("text")
        

        
      )
    ),
    
    helpText("Some more help text here.")
  )  
))
