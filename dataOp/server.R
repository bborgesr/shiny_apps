library(shiny)
library(mosaic)
library(RCurl)
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
        or '?name_of_dataset' (ex: <code>?Galton</code>) for
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
      HTML(beigeTable(df=helper))
    })
    
    output$tab2DS <- renderText({
      helper = tableHelp(tab2(), tab2n())
      HTML(beigeTable(df=helper))
    })    
    
    
    
    ## Filter and Select
    
    output$moreInfoFS <- renderText({
      if (input$moreButtonFS %% 2 == 0) {""}
      else {"<strong><em>Filter</em></strong> allows you to choose a
            subset of rows. For example, you might only be interest in 
            the rows in which sex == 'F'. <strong><em>Select</em></strong>
            allows you to choose a subset of columns. For example, you
            might only be interested in the columns that start with the
            letters 'countr'. Separate multiple conditions with commas."}
      })
    
    output$tabnameFS <- renderText({ 
      input$tab1
    })
    
    output$tabFS <- renderText({ 
      helper = tableHelp(tab1(), tab1n())
      HTML(beigeTable(df=helper))
    })
    
    output$tabFilter <- renderText({
      helper = tableHelp(tab1(), tab1n())
      validate(
        need(
          class(
            try(
              HTML(filterTable(df=helper, conditions=input$filterCondition))
            )) != "try-error", "Filter statement incomplete or invalid")
      )
      HTML(filterTable(df=helper, conditions=input$filterCondition))
    })
    
    output$tabSelect <- renderText({
      helper = tableHelp(tab1(), tab1n())
      validate(
        need(
          class(
            try(
              HTML(selectTable(df=helper, conditions=input$selectCondition))
            )) != "try-error", "Select statement incomplete or invalid")
      )
      HTML(selectTable(df=helper, conditions=input$selectCondition))
    })
    
    
    
    ## Mutate
    
    output$moreInfoM <- renderText({
      if (input$moreButtonM %% 2 == 0) {""}
      else {"<strong><em>Mutate</em></strong> allows you to add new columns
            to your dataset. For example, in the <code>Galton</code> dataset
            you might be interested in adding a column that is the sum
            of the mother's and the father's height: <code>sumFM = 
            father + mother</code> or you might simply be interested
            in adding a column that assigns a unique number to each row:
            <code>id = 1:4</code> (if you have four rows). 
            Separate multiple conditions with commas."}
      })
    
    output$tabnameM <- renderText({ 
      input$tab1
    })
    
    output$tabM <- renderText({ 
      helper = tableHelp(tab1(), tab1n())
      HTML(beigeTable(df=helper))
    })
    
    output$tabMutate <- renderText({
      helper = tableHelp(tab1(), tab1n())
      validate(
        need(
          class(
            try(
              HTML(mutateTable(df=helper, conditions=input$mutateCondition))
            )) != "try-error", "Mutate statement incomplete or invalid")
      )      
      HTML(mutateTable(df=helper, conditions=input$mutateCondition))
    })
    
    
    
    ## Group_by and Summarise
    
    output$moreInfoGS <- renderText({
      if (input$moreButtonGS %% 2 == 0) {""}
      else {"All of the data operations presented so far have been applied
            to the whole dataset. However, we can use the <strong><em>group_by
            </em></strong> function to group our data before we apply any of these
            operations. The usefulness of <em>group_by</em> is particularly 
            obvious when we use it before the <strong><em>summarise</em></strong>
            function, which reduces each group to a single row. For example, in
            the <code>Galton</code> dataset, we might be interested in grouping
            by sex, and then calculating the average height for each group. It's
            worth noting that once you apply <em>group_by</em> to your dataset,
            it won't appear to change anything at all. In order to visualize this, we
            will use another operation, <strong><em>arrange</em></strong>, which
            re-orders the rows according to the desired groups. Separate multiple
            conditions with commas."}
      })
    
    output$tabnameGS <- renderText({
      updateSelectInput(session, "group", choices = names(tab1()),
                        selected=names(tab1())[1])
      input$tab1
    })
    
    output$tabGS <- renderText({
      helper = tableHelp(tab1(), tab1n())
      HTML(normalTable(df=helper, group=input$group))
    })
    
    output$tabGroup <- renderText({
      helper = tableHelp(tab1(), tab1n())
      validate(
        need(
          class(
            try(
              HTML(normalTable(df=helper, group=input$group, order=TRUE))
            )) != "try-error", "Please select one or more variables to group by")
      ) 
      HTML(normalTable(df=helper, group=input$group, order=TRUE))
    })
    
    output$tabSummar <- renderText({       
      helper = tableHelp(tab1(), tab1n())
      validate(
        need(
          class(
            try(
              HTML(summarTable(df=helper, group=input$group, conditions=input$summar))
            )) != "try-error", "Summarise statement incomplete or invalid")
      ) 
      HTML(summarTable(df=helper, group=input$group, conditions=input$summar))
    })
    
    
    
    
    ## Join
    
    output$moreInfoJ <- renderText({
      if (input$moreButtonJ %% 2 == 0) {""}
      else {'<strong> <em>Join</em> </strong> is the most complicated
            of the data operations presented here (all of which have
            been unary -- i.e. they are only applied to one data
            table). <em>Join</em>, on the other hand, is a binary 
            operation -- that is it requires two data tables. <em>Join</em>
            merges the two tables according to a common variable 
            speficied by you. In this section, I diverge a little from
            <code>dplyr</code> as I present the
            <a href="http://www.techonthenet.com/sql/joins.php">most common
            SQL joins</a> (inner join, left, right and full outer joins),
            rather than those given by <code>dplyr</code> `s <em>join</em>
            function. The only other option provided here is the cross join
            (also called cartesian product) which joins each row on the
            first table to all the other rows in the second table (rather
            than based on a common variable). For this section, I reccomend
            using two of CIA World Factbook datasets and joining on the
            <code>country</code> variable.'}
      })
    
    output$tab1nameJ <- renderText({ 
      updateSelectInput(session, "tab1varJ", 
                        choices = names(tab1()),
                        selected = names(tab1())[1])
      paste("1st Table:", input$tab1)
    })
    
    output$tab2nameJ <- renderText({ 
      updateSelectInput(session, "tab2varJ", 
                        choices = names(tab2()),
                        selected = names(tab2())[1])
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
      
      validate(
        need(
          class(
            try(
              HTML(fancierTable(left, right, join, default="none", by=by))
            )) != "try-error", "Unable to join (if you are trying to do an inner join, check that at least one column matches in the selected variable)")
      )
      HTML(fancierTable(left, right, join, 
                        default="none", by=by))
    })
    
      }
    )
