library(shiny)


shinyUI(fluidPage(
  
  titlePanel("Visualizing a Join"),
  
  fluidRow(
    p("An app to help you understand and visualize the process 
      of joining two data frames in R")),
  
  tabsetPanel(
    
    tabPanel("Data Selection", 
             fluidRow(
               
               br(),
               
               column(2,
                      selectInput("tab1", label = "Select the 1st table to join",
                                  choices = list("Galton", 
                                                 "Heightweight", 
                                                 "SwimRecords", 
                                                 "TenMileRace",
                                                 "Maternal Death Rates",
                                                 "Obesity Rates",
                                                 "GDP",
                                                 "Electrical Production",
                                                 "Roadways (km)")),
                      
                      numericInput("tab1n", label = "Enter the number of rows to display",
                                   value = 4)
               ),
               
               column(9,
                      htmlOutput("tab1Table"),
                      align = "center")
             ),
             
             br(),
             br(),
             
             fluidRow(
               
               br(),
               
               column(2,
                      selectInput("tab2", label = "Select the 2nd table to join",
                                  choices = list("Galton", 
                                                 "Heightweight", 
                                                 "SwimRecords",
                                                 "TenMileRace",
                                                 "Maternal Death Rates",
                                                 "Obesity Rates",
                                                 "GDP",
                                                 "Electrical Production",
                                                 "Roadways (km)")),
                      
                      numericInput("tab2n", label = "Enter the number of rows to display",
                                   value = 4)
               ),
               
               column(9,
                      htmlOutput("tab2Table"),
                      align = "center")             
             )
    ),
    
    
    
    tabPanel("Join",
             
             fluidRow(
               
               column(4, h5(textOutput("tab1name"))),
               
               column(4, h5(textOutput("tab2name")))
               
               ),
             
             
             fluidRow(
               
               column(4,                      
                      selectInput("tab1var", label = "Select the 1st table variable",
                                  choices = list(1, 2)
                      )
               ),
               
               column(4,                      
                      selectInput("tab2var", label = "Select the 2nd table variable",
                                  choices = list(1, 2)
                      )
               ),
               
               column(4,                      
                      selectInput("join", label = "Select the type of join you want",
                                  choices = list("Inner Join", "Left Outer Join",
                                                 "Right Outer Join", "Full Outer Join",
                                                 "Cross Join")
                      )
               )
             ),
             
             
             fluidRow(
               
               column(4, htmlOutput("tab1Tab")),
               
               column(4, htmlOutput("tab2Tab")),
               
               column(4, htmlOutput("joinTab"))
             )
    ) 
  ))
)