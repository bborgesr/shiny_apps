library(shiny)

shinyUI(fluidPage(
  
  titlePanel("Visualizing data manipulation operations"),
  
  tabsetPanel(
    
    tabPanel("Data Selection",             
             
             #              ## Hide errors:
             #              tags$style(type="text/css",
             #                         ".shiny-output-error { visibility: hidden; }",
             #                         ".shiny-output-error:before { visibility: hidden; }"
             #              ),
             
             actionButton("moreButtonDS", "more/less info"),
             
             htmlOutput("moreInfoDS"),
             
             br(),
             
             fluidRow( 
               
               column(1),
               
               column(2,
                      selectInput("tab1", label = strong("Select the 1st table to join"),
                                  choices = list("Galton", 
                                                 "Dimes", 
                                                 "SwimRecords", 
                                                 "TenMileRace",
                                                 "Maternal Death Rates",
                                                 "Obesity Rates",
                                                 "GDP",
                                                 "Electrical Production",
                                                 "Roadways (km)"))
               ),
               
               column(1, 
                      numericInput("tab1n", label = "No. rows",
                                   value = 4)),
               
               column(3),
               
               column(2,
                      selectInput("tab2", label = strong("Select the 2nd table to join"),
                                  choices = list("Galton", 
                                                 "Dimes", 
                                                 "SwimRecords",
                                                 "TenMileRace",
                                                 "Maternal Death Rates",
                                                 "Obesity Rates",
                                                 "GDP",
                                                 "Electrical Production",
                                                 "Roadways (km)"))),
               
               column(1, 
                      numericInput("tab2n", label = "No. rows",
                                   value = 4)),
               column(2)
             ),
             
             br(),
             
             fluidRow(                  
               column(6,
                      htmlOutput("tab1DS"),
                      align = "center"),
               
               column(6,
                      htmlOutput("tab2DS"),
                      align = "center")             
             )
    ),
    
    
    tabPanel("Filter and Select",
             
             actionButton("moreButtonFS", "more/less info"),
             
             htmlOutput("moreInfoFS"),
             
             br(),
             
             fluidRow(
               
               column(4, strong("Your dataset")),
               
               column(4, strong("Filter")),
               
               column(4, strong("Select"))
               
             ),
             
             fluidRow(
               
               column(4, textOutput("tabnameFS")),
               
               column(4,
                      textInput("filterCondition", 
                                label = "Enter the condition(s) to filter by")),
               
               column(4,
                      textInput("selectCondition", 
                                label = "Enter the condition(s) to select by"))
             ),
             
             fluidRow(
               
               column(4, br()),
               
               column(4, p(em(strong("ex:")), 
                           span("i", style = "color:white"),
                           "sex=='F', state=='NY'")),
               
               column(4, p(em(strong("ex:")), 
                           span("i", style = "color:white"),
                           "wage, starts_with('countr')"))
             ),
             
             fluidRow(
               
               column(4, htmlOutput("tabFS")),
               
               column(4, htmlOutput("tabFilter")),
               
               column(4, htmlOutput("tabSelect"))
             )
    ),
    
    tabPanel("Mutate",
             
             actionButton("moreButtonM", "more/less info"),
             
             htmlOutput("moreInfoM"),
             
             br(),
             
             fluidRow(
               
               column(4, strong("Your dataset")),
               
               column(4, strong("Mutate")),
               
               column(4)
               
             ),
             
             
             fluidRow(
               
               column(4, textOutput("tabnameM")),
               
               column(4,
                      textInput("mutateCondition", 
                                label = "Create the new columns(s)")),
               
               column(4)
             ),
             
             fluidRow(
               
               column(4, br()),
               
               column(4, p(em(strong("ex:")), 
                           span("i", style = "color:white"),
                           "sumFM = father + mother")),
               
               column(4)
             ),
             
             fluidRow(
               
               column(4, htmlOutput("tabM")),
               
               column(4, htmlOutput("tabMutate")),
               
               column(4)
             )
    ),
    
    tabPanel("Group_by and Summarise",
             
             actionButton("moreButtonGS", "more/less info"),
             
             htmlOutput("moreInfoGS"),
             
             br(),
             
             fluidRow(
               
               column(4, strong("Your dataset")),
               
               column(4, p(strong("Group_by"), 
                           "(made visual with",
                           strong("arrange"), ")")),
               
               column(4, strong("Summarise"))
               
             ),          
             
             fluidRow(
               
               column(4, textOutput("tabnameGS")),
               
               column(4, selectInput("group", 
                                     multiple = TRUE,
                                     label = "Select the variable(s) you want to group-by",
                                     choices = list(1,2))),
               
               column(4,
                      textInput("summar",
                                label = ("Enter the expression(s) to summarize by")),
                      
                      p(em(strong("ex:")), 
                        span("i", style = "color:white"),
                        "mean(wage), n(), max(height)"))
             ),
             
             fluidRow(
               column(4, htmlOutput("tabGS")),
               
               column(4, htmlOutput("tabGroup")),
               
               column(4, htmlOutput("tabSummar"))
               
             )
    ), 
    
    tabPanel("Join",
             
             actionButton("moreButtonJ", "more/less info"),
             
             htmlOutput("moreInfoJ"),
             
             fluidRow(
               
               column(4, h5(textOutput("tab1nameJ"))),
               
               column(4, h5(textOutput("tab2nameJ")))
               
             ),
             
             fluidRow(
               
               column(4,                      
                      selectInput("tab1varJ", label = "Select the 1st table variable",
                                  choices = list(1, 2)
                      )
               ),
               
               column(4,                      
                      selectInput("tab2varJ", label = "Select the 2nd table variable",
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
               
               column(4, htmlOutput("tab1J")),
               
               column(4, htmlOutput("tab2J")),
               
               column(4, htmlOutput("joinTab"))
             )
    )
  )
))