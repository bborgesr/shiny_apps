library(mosaic)


tableHelp <- function(tab, n) {  
  set.seed(1993)
  result <- tab[sample(nrow(tab), n), ]
  return (result)
}


cellCol <- function(df, group) {    
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



fancierTable = function(df, group, order = c(FALSE, TRUE)) {
 
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

  for (i in 1:length(group) ) {
    df[[ group[[i]] ]] <- as.factor(df[[ group[[i]] ]])
  }

  cells <- data.frame()
  cellColFun <- cellCol(df, group)
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
  
  df_header_row <- header_html(c(names(df)))
  df_rows <- sapply(split(cells, 1:nrow(df)), row_html)
  collapse_cells <- paste0(c(df_header_row, df_rows), collapse='')    
  full_table <- paste0('<table class=\"data table table-bordered table-condensed\">', 
                       collapse_cells, '</table>')
  
  return(full_table)
}


summarTable <- function(df, group, conditions) {
  exp <- strsplit(conditions, ",")
  exp <- exp[[1]]
  cellColFun <- cellCol(df, group)
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
  fancierTable(df, name, order=TRUE)
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

