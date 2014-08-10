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
    
    ## Data Selection
    
    output$moreInfoDS <- renderText({
      if (input$moreButtonDS %% 2 == 0) {""}
      else {
      "This app is meant to help you understand and visualize the process 
      of data manipulation. Each tab presents a different data manipulation
      operation, all of which come from the package <code>dplyr</code>. For
      now, select two data sources that you will use throughout the next
      tabs (you can always come back and change your data). Only the first
      dataset will be used for all operations, with the exception of join,
      which will use both datasets. <br><br>    
      The first 4 datasets are part of the <code>mosaic</code>
      package. In your console, type
      <code>(data(package='mosaic')</code> for general information
      or '?name_of_dataset' (ex: <code>?Galton</code> for
      detailed information about a particular dataset. The
      remaining 5 datasets are from the
      <a href = https://www.cia.gov/library/publications/the-world-factbook/rankorder/rankorderguide.html> 
      CIA World Factbook</a> and include information for several countries."}
    })
    
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
    
    output$tab1DS <- renderText({
      helper = tableHelp(tab1(), tab1n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, left, 
                        default="left", by = "none"))
    })
    
    output$tab2DS <- renderText({
      helper = tableHelp(tab1(), tab2(), tab1n(), tab2n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, right, 
                        default="right", by = "none"))
    })    
    
    
    ## Filter and Select
    
    output$moreInfoFS <- renderText({
      if (input$moreButtonFS %% 2 == 0) {""}
      else {"<strong><em>Filter</em></strong> allows you to choose a
            subset of rows. For example, you might only be interest in 
            the rows in which sex == 'F'. <strong><em>Select</em></strong>,
            allows you to choose a subset of columns. For example, you
            might only be interested in the columns that start with the
            letters 'countr'. Separate multiple conditions with commas."}
    })
    
    output$tabnameFS <- renderText({ 
      input$tab1
    })
    
    output$tabFS <- renderText({ 
      helper = tableHelp(tab1(), tab2(), tab1n(), tab2n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, left, 
                        default="left", by = "none"))
    })
    
    ## Mutate
    
    output$moreInfoM <- renderText({
      if (input$moreButtonM %% 2 == 0) {""}
      else {"<strong><em>Mutate</em></strong> allows you to add new columns
      to your dataset. For example, in the <code>Galton</code> dataset
      you might be interested in adding a column that is the average
      of the mother's and the father's height: <code>averageFM =
      mean(father, mother)</code> or you might simply be interested
      in adding a column that assigns a unique number to each row:
      <code>id = 1:nrow(Galton)</code> Separate multiple conditions
      with commas."}
    })
    
    output$tabnameM <- renderText({ 
      input$tab1
    })
    
    output$tabM <- renderText({ 
      helper = tableHelp(tab1(), tab2(), tab1n(), tab2n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, left, 
                        default="left", by = "none"))
    })
    
    
    ## Group_by and Summarise
    
    output$moreInfoGS <- renderText({
      if (input$moreButtonGS %% 2 == 0) {""}
      else {"All of the data operations presented so far have been applied
      to the whole dataset. However, we can use the <strong><em>group_by
      </em></strong> function to group our data before we apply any of these
      operations. The usefulness of <em>group_by</em> is particularly 
      obvious when we use before the <strong><em>summarise</em></strong>
      function, which reduces each group to a single row. For example, in
      the <code>Galton</code> dataset, we might be interested in grouping
      by sex, and then calculating the average height for each group. It's
      worth noting that once you apply <em>group_by</em> to your dataset,
      it does not appear to change at all. In order to visualize this, we
      will another operation, <strong><em>arrange</em></strong> which
      re-orders the rows according the desired groups. Separate multiple
      conditions with commas."}
    })
    
    output$tabGS <- renderText({
      updateCheckboxGroupInput(session, "group", choices = names(tab1()),
                               selected=names(tab1())[1])
      helper = tableHelp(tab1(), tab1n())
      HTML(normalTable(df=helper, group=input$group))
    })
    
    output$tabGroup <- renderText({
      helper = tableHelp(tab1(), tab1n())
      HTML(normalTable(df=helper, group=input$group, order=TRUE))
    })
    
    output$tabSummar <- renderText({       
      helper = tableHelp(tab1(), tab1n())
      HTML(summarTable(df=helper, group=input$group, conditions=input$summar))
    })
    
    
    ## Join
    
    output$moreInfoJ <- renderText({
      if (input$moreButtonJ %% 2 == 0) {""}
      else {'<strong> <em>Join</em> </strong> is the more complicated
            of the data operations presented here (all of which have
            been unary so far -- i.e. they are only applied to one data
            table). <em>Join</em> On the other hand, is a binary 
            operation, that is it requires to data tables. <em>Join</em>
            merges the two tables according to a common variable 
            speficied by you. In this section, I diverge a little from
            <code>dplyr</code> as I present the
            <a href="http://www.techonthenet.com/sql/joins.php">most common
            SQL joins</a> (inner join, left, right and full outer joins),
            rather than those given by <code>dplyr</code> `s <em>join</em>
            function. The only other option provided here is the cross join
            (also called cartesian product) which joins each row on the
            first table to all the other rows in the second table (rather
            than based on common variable). For this section, I reccomend
            using two of CIA World Factbook datasets and joining on the
            <code>country</code> variable.'}
      })
    
    output$tab1nameJ <- renderText({ 
      updateRadioButtons(session, "tab1varJ", choices = names(tab1()))
      paste("1st Table:", input$tab1)
    })
    
    output$tab2nameJ <- renderText({ 
      updateRadioButtons(session, "tab2varJ", choices = names(tab2()))
      paste("2nd Table:", input$tab2)
    })
    
    output$tab1J <- renderText({ 
      helper = joinTableHelp(tab1(), tab2(), tab1n(), tab2n())
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, left, 
                        default="left", by = "none"))
    })
    
    output$tab2J <- renderText({  
      helper = joinTableHelp(tab1(), tab2(), tab1n(), tab2n())      
      left = helper$left
      right = helper$right
      HTML(fancierTable(left, right, right, 
                        default="right", by = "none"))
    })
    
    output$joinTab <- renderText({       
      helper = joinHelp(tab1(), tab2(), tab1n(), tab2n(), 
                     input$tab1varJ, input$tab2varJ, input$join)
        
      left = helper$left
      right = helper$right
      join = helper$join
      by = helper$by
      
      HTML(fancierTable(left, right, join, 
                        default="none", by=by))
    })
    
  }
)
