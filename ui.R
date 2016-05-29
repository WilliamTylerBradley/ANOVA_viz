# Need to clean up the look
# and add explanatory text

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
                     step=.1),
        
        sliderInput(inputId = "mean_1", 
                    label = "First Mean",
                    min = -5,
                    max = 5,
                    value = 5,
                    step=1),
        
        sliderInput(inputId = "mean_2", 
                    label = "Second Mean",
                    min = -5,
                    max = 5,
                    value = 0,
                    step=1),
        
        sliderInput(inputId = "mean_3", 
                    label = "Third Mean",
                    min = -5,
                    max = 5,
                    value = -5,
                    step=1),
        
        sliderInput(inputId = "n_size", 
                    label = "Sample size for each group",
                    min = 15,
                    max = 45,
                    value = 30,
                    step=5),
        
        checkboxInput("show_trt", "Show group normal", 
                      value = TRUE),
        
        checkboxInput("show_overall", "Show overall normal", 
                      value = TRUE)

      ),
      
          
      mainPanel(
        helpText("This will have the graphs"), 
        
        plotOutput("plot"),
        
        helpText("This will have the table"),
        
        tableOutput('anova_table')

        

        
      )
    ),
    
    helpText("Some more help text here.")
  )  
))
