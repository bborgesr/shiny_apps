library(shiny)
library(mosaic)
library(dplyr)
source("helpers.R")

datasets <- list( Galton = Galton, Heightweight = Heightweight,
                  SwimRecords = SwimRecords, TenMileRace = TenMileRace)

shinyServer(
  function(input, output, session) {
    
    tab <- reactive({
      datasets[[ input$tab ]]
    })
    
    update <- reactive({
      updateCheckboxGroupInput(session, "group", choices = names(tab()),
                               selected=names(tab())[1])
    })
    
    tabn <- reactive({
      input$tabn
    })    
    
    summar <- reactive({
      input$summar
    })    
    
    output$tabTable <- renderText({
      update()
      helper = tableHelp(tab(), tabn())
      HTML(fancierTable(df=helper, group=input$group))
    })

    output$groupTab <- renderText({
      helper = tableHelp(tab(), tabn())
      HTML(fancierTable(df=helper, group=input$group, order=TRUE))
    })
    
    output$summarTab <- renderText({       
      helper = tableHelp(tab(), tabn())
      HTML(summarTable(df=helper, group=input$group, conditions=input$summar))
    })
  }
)
