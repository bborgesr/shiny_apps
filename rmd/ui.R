library(shiny)

shinyUI(
  bootstrapPage(
    tags$head(
      tags$title('An R Notebook in Shiny'),
      tags$script(src = 'http://ajaxorg.github.io/ace/build/src-min-noconflict/ace.js',
                  type = 'text/javascript', charset = 'utf-8'),
      tags$link(rel = 'stylesheet', type = 'text/css', href = 'ace-shiny.css'),
      tags$script(src = 'http://yandex.st/highlightjs/7.3/highlight.min.js', type = 'text/javascript'),
      tags$script(src = 'http://yandex.st/highlightjs/7.3/languages/r.min.js', type = 'text/javascript'),
      tags$link(rel = 'stylesheet', type = 'text/css',
                href = 'http://yandex.st/highlightjs/7.3/styles/github.min.css'),
      tags$script(src = 'https://c328740.ssl.cf1.rackcdn.com/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML',
                  type = 'text/javascript')
    ),

    div(id = 'notebook', title = 'Compile notebook: F4\nInsert chunk: Ctrl+Alt+I',
        paste(readLines(file.choose()), collapse = '\n')),
    
    tags$textarea(id = 'nbSrc', style = 'display: none;'),
    tags$script(src = 'ace-shiny.js', type = 'text/javascript'),
     htmlOutput('nbOut')
  )

)