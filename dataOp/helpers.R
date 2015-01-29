library(mosaic)
library(mosaicData)
##library(DCFdevel)
library(dplyr)
library(RCurl)

tableHelp <- function(tab, n) {  
  set.seed(1993)
  result <- tab[sample(nrow(tab), n), ]
  return (result)
}


normalCellCol <- function(df, group) {    
  lst <- list()
  for (i in 1:length(group)) {
    lst[[i]] <- df[[ group[[i]] ]]
  }     
  args = list()
  args$lst <- lst
  args$drop <- TRUE    
  args$sep <- " : "
  df$grouping = do.call(interaction, args)
  
  groupLevels <- levels(df$grouping)
  rain <- rainbow(length(groupLevels))
  colors <- c()
  for (i in 1:length(groupLevels)) {
    colors[i] <- rain[i]
  } 
  names(colors) <- groupLevels
  colors <- col2rgb(colors)
  return(list(colors, df))
}


header_html <- function(table_cell) paste0('<th>', table_cell, '</th>')    

cell_html <- function(table_cell, col) {
  cellStyle <- paste0("style='text-align:center;background-color:", 
                      col, "'", collapse='')
  paste0('<td ', cellStyle, '>', table_cell, '</td>')    
}  

row_html <- function(cells) {
  collapse_cells <- paste0(cells, collapse='')                                   
  collapse_cells <- paste0('<tr>', collapse_cells, '</tr>')
  collapse_cells 
}

end_table <- function(df, cells) {
  df_header_row <- header_html(c(names(df)))
  df_rows <- sapply(split(cells, 1:nrow(df)), row_html)
  collapse_cells <- paste0(c(df_header_row, df_rows), collapse='')    
  full_table <- paste0('<table class=\"data table table-bordered table-condensed\">', 
                       collapse_cells, '</table>')
  full_table
}

normalTable = function(df, group, order = c(FALSE, TRUE)) {  
  for (i in 1:length(group) ) {
    df[[ group[[i]] ]] <- as.factor(df[[ group[[i]] ]])
  }
  
  cells <- data.frame()
  cellColFun <- normalCellCol(df, group)
  colors <- cellColFun[[1]]
  df <- cellColFun[[2]]
  
  if (order==TRUE) {
    df <- arrange(df, grouping)
  }
  
  for (i in 1:nrow(df)) {
    for (j in 1:ncol(df)) {
      
      level <- df[i, "grouping"]
      col <- colors[,level]
      col <- paste0("rgba(", col[1], ",", col[2], ",", col[3], ",", "0.3)", 
                    collapse='')
      cell <- cell_html(df[i,j], col)      
      cells[i,j] <- cell
    }
  }
  
  colNum <- grep('grouping', names(df))
  cells <- cells[,-colNum]
  df <- df[,-colNum]
  return(end_table(df,cells))
}


summarTable <- function(df, group, conditions) {
  exp <- strsplit(conditions, ",")
  exp <- exp[[1]]
  cellColFun <- normalCellCol(df, group)
  df <- cellColFun[[2]]
  df <- df %.% group_by(grouping) %.% s_summarise(exp)
  name <- group[[1]]
  if (length(group) > 1) {
    for (i in 2:length(group)) {
      name <- paste0(name, " : ", group[[i]])
    } 
  }  
  colnames(df)[which(names(df) == "grouping")] <- name
  df[,sapply(df, is.numeric)] <-round(df[,sapply(df, is.numeric)],2)
  normalTable(df, name, order=TRUE)
}


beigeTable = function(df) {
  cells <- data.frame() 
  for (i in 1:nrow(df)) {
    for (j in 1:ncol(df)) {   
      col <- paste0("rgba(", 234, ",", 211, ",", 168, ",", "0.3)", 
                    collapse='')
      cell <- cell_html(df[i,j], col)      
      cells[i,j] <- cell
    }
  }
  return(end_table(df,cells))
}


filterTable <- function(df, conditions) {
  exp <- strsplit(conditions, ",")
  exp <- exp[[1]]
  df <- df  %.% group_by(names(df)[1]) %.% s_filter(exp)
  df <- df[-ncol(df)]
  beigeTable(df)
}

selectTable <- function(df, conditions) {
  exp <- strsplit(conditions, ",")
  exp <- exp[[1]]
  df <- df %.% s_select(exp)
  beigeTable(df)
}

mutateTable <- function(df, conditions) {
  exp <- strsplit(conditions, ",")
  exp <- exp[[1]]
  df2 <- df  %.% group_by(names(df)[1]) %.% s_mutate(exp)
  df2 <- df2[-(ncol(df)+1)]
  beigeTable(df2)
}


## Following --> credit to Sebastian Kranz (see: https://gist.github.com/skranz/9681509)

eval.string.dplyr = function(.data, .fun.name, ...) {
  args = list(...)
  args = unlist(args)
  code = paste0(.fun.name,"(.data,", paste0(args, collapse=","), ")")
  df = eval(parse(text=code,srcfile=NULL))
  df  
}

s_summarise = function(.data, ...) {
  eval.string.dplyr(.data,"summarise", ...)
}

s_mutate = function(.data, ...) {
  eval.string.dplyr(.data,"mutate", ...)
}

s_select = function(.data, ...) {
  eval.string.dplyr(.data,"select", ...)
}

s_filter = function(.data, ...) {
  eval.string.dplyr(.data,"filter", ...)
}

##


fancierTable = function(left, right, df, default = c("none", "left", "right"),
                        by = c("none", var)){
  
  header_html <- function(table_cell) paste0('<th>', table_cell, '</th>')    
  
  side <- function(table_col_name) {
    colName <- grep(paste(by, '(\\.x|$)', sep=''), table_col_name)    
    if (by != "none" & length(colName)>0) {return("none")}
    if (default == "left") {return("left")}
    if (default == "right") {return("right")}
    ifelse (table_col_name %in% c(names(left), paste(names(left), ".x", sep="")), 
            "left", "right")
  }
  
  cell_html <- function(table_cell, colorLeft, colorRight, cellSide) {
    cellStyle <- ''
    if (cellSide == "left") {
      cellStyle <- paste0("style='text-align:center;background-color:", 
                          colorLeft, "'", collapse='')
    } else {
      if (cellSide == "right") {
        cellStyle <- paste0("style='text-align:center;background-color:", 
                            colorRight, "'", collapse='')
      } else {
        cellStyle <- paste0("style='text-align:center;font-weight:bold'",
                            collapse='')
      }
    }
    paste0('<td ', cellStyle, '>', table_cell, '</td>')    
  }  
  
  row_html <- function(cells) {
    collapse_cells <- paste0(cells, collapse='')                                   
    collapse_cells <- paste0('<tr>', collapse_cells, '</tr>')
    collapse_cells 
  }
  
  colorsL <- col2rgb(colorRampPalette(c("palevioletred4", "royalblue1",
                                        "springgreen4"))(nrow(left)))
  colorsR <- col2rgb(colorRampPalette(c("tomato2", "yellow", 
                                        "greenyellow"))(nrow(right)))
  
  cells <- data.frame()
  
  for (i in 1:nrow(df)) {
    for (j in 1:ncol(df)) {
      
      colorL <- "rgba(255,255,255,1)"
      colorR <- "rgba(255,255,255,1)"
      cellSide <- side(names(df)[j])
      
      if (cellSide == "left") {
        colNum <- grep('^rowNum(\\.x|$)', names(df))
        colorCode <- df[i, colNum]
        if (!is.na(colorCode)){
          colorL <- paste0("rgba(", colorsL[[1, colorCode]], ",", 
                           colorsL[[2, colorCode]], ",", 
                           colorsL[[3, colorCode]], ",", "0.3)", 
                           collapse='')
        }
      } else { 
        if (cellSide == "right") {
          colNum <- grep('^rowNum(\\.y|$)', names(df))
          colorCode <- df[i, colNum]
          if (!is.na(colorCode)) {
            colorR <- paste0("rgba(", colorsR[[1, colorCode]], ",", 
                             colorsR[[2, colorCode]], ",", 
                             colorsR[[3, colorCode]], ",", "0.5)",
                             collapse='')
          }
        }
      }
      
      cell <- cell_html(df[i,j], colorL, colorR, cellSide)
      
      cells[i,j] <- cell
    }
  }
  
  colNum <- grep('^rowNum(\\.x|\\.y|$)', names(df))
  cells <- cells[,-colNum]
  
  df_header_row <- header_html(c(names(df))[-colNum])
  df_rows <- sapply(split(cells, 1:nrow(df)), row_html)
  collapse_cells <- paste0(c(df_header_row, df_rows), collapse='')    
  full_table <- paste0('<table class=\"data table table-bordered table-condensed\">', 
                       collapse_cells, '</table>')
  
  return(full_table)
}


joinTableHelp <- function(tab1, tab2, n1, n2) {  
  set.seed(1993)
  left <- tab1[sample(nrow(tab1), n1), ]
  left$rowNum <- 1:nrow(left)
  
  right <- tab2[sample(nrow(tab2), n2), ]
  right$rowNum <- 1:nrow(right)
  
  return (list(left=left, right=right))
}


joinHelp <- function(tab1, tab2, n1, n2, tab1var, tab2var, joinType) {
  set.seed(1993)
  left <- tab1[sample(nrow(tab1), n1), ]
  left$rowNum = 1:nrow(left)
  
  right <- tab2[sample(nrow(tab2), n2), ]
  right$rowNum = 1:nrow(right)  
  
  result <- switch( joinType, 
                    "Inner Join"        = c(TRUE, FALSE, FALSE),
                    "Left Outer Join"   = c(TRUE, TRUE, FALSE),
                    "Right Outer Join"  = c(TRUE, FALSE, TRUE),
                    "Full Outer Join"   = c(TRUE, TRUE, TRUE),
                    "Cross Join"        = c(FALSE))
  
  if (result[1] == TRUE) {
    byx = tab1var
    byy = tab2var
    allx = result[2]
    ally = result[3]
  } 
  
  else {
    byx = NULL
    byy = NULL
    allx = TRUE
    ally = TRUE
  }
  
  newTab <- merge(x = left, y = right, by.x = byx, 
                  by.y = byy, all.x = allx, all.y = ally)
  
  by <- byx
  if (is.null(byx)) {by <- "none"}
  
  return(list(left=left, right=right, join=newTab, by=by))
  
}


CIAdata <- function (code=NULL) {
  CIA = read.csv(system.file("LocalData","CIA.csv",package='DCFdevel'), stringsAsFactors=FALSE)
  if (is.null(code)) {
    return(CIA)
  } else {
    if (code %in% CIA$Code) {
      sub <- subset(CIA, Code==code)
      url <- (paste0("https://www.cia.gov/library/publications/the-world-factbook/rankorder/rawdata_", code, ".txt"))
      table <- read.delim(url, header=FALSE, stringsAsFactors=FALSE)
      table[,1]<-NULL
      names(table) <- c("country", sub[["Name"]])
      table[[2]] = as.numeric(gsub("[^.+[:digit:] ]", "", table[[2]]))
      return(table)
    }
  }
}
