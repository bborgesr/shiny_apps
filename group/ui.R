library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Visualizing 'Group by' and 'Summarise'"),
  
  fluidRow(
    p("Welcome to this great app!")),
  
  br(),
  br(),
  
  fluidRow(
    
    column(4,
           h5("Select the dataset"),
           selectInput("tab", label = "",
                       choices = list("Galton", "Heightweight", 
                                      "SwimRecords", "TenMileRace")),           
           numericInput("tabn", label = "Enter the number of rows to display",
                        value = 4),
           br(),
           br()
    ),
    
    column(4,                      
           h5("Select the variable(s) you want to group-by"),
           checkboxGroupInput("group", label = "",
                       choices = list(1,2))
    ),
    
    column(4,
           h5("Enter the expression(s) to summarize by"),
           "(separated by commas)",
           textInput("summar", label="")
    )    
  ),
  
  fluidRow(
    column(4, htmlOutput("tabTable")),
    
    column(4, htmlOutput("groupTab")),
    
    column(4, htmlOutput("summarTab"))
    
  )
))