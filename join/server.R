library(shiny)
library(mosaic)
source("helpers.R")

datasets <- list( Galton = Galton, 
                  Heightweight = Heightweight,
                  SwimRecords = SwimRecords,
                  TenMileRace = TenMileRace,
                  "Maternal Death Rates" = CIAdata(2223),
                  "Obesity Rates" = CIAdata(2228),
                  "GDP" = CIAdata(2001),
                  "Electrical Production" = CIAdata(2232),
                  "Roadways (km)" = CIAdata(2085))


shinyServer(
  function(input, output, session) {
    
    tab1 <- reactive({
      datasets[[ input$tab1 ]]
    })
    
    tab2 <- reactive({
      datasets[[ input$tab2 ]]
    })    
    
    tab1n <- reactive({
      input$tab1n
    })    
    
    tab2n <- reactive({
      input$tab2n
    })   
    
    output$tab1name <- renderText({ 
      paste("1st Table:", input$tab1)
    })
    
    output$tab2name <- renderText({ 
      paste("2nd Table:", input$tab2)
    })
    
    
    output$tab1Table <- renderText({
      updateRadioButtons(session, "tab1var", choices = names(tab1()))
      helper = tableHelp(tab1(), tab2(), tab1n(), tab2n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, left, 
                        default="left", by = "none"))
    })
    
    
    output$tab2Table <- renderText({
      updateRadioButtons(session, "tab2var", choices = names(tab2()))
      helper = tableHelp(tab1(), tab2(), tab1n(), tab2n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, right, 
                        default="right", by = "none"))
    })    
  
    
    output$tab1Tab <- renderText({ 
      helper = tableHelp(tab1(), tab2(), tab1n(), tab2n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, left, 
                        default="left", by = "none"))
    })
    
    
    output$tab2Tab <- renderText({  
      helper = tableHelp(tab1(), tab2(), tab1n(), tab2n())      
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, right, 
                        default="right", by = "none"))
    })
    
    
    output$joinTab <- renderText({       
      helper = joinHelp(tab1(), tab2(), tab1n(), tab2n(), 
                     input$tab1var, input$tab2var, input$join)
        
      left = helper$left
      right = helper$right
      join = helper$join
      by = helper$by
      
      HTML(fancierTable(left, right, join, 
                        default="none", by=by))
    })
    
  }
)
