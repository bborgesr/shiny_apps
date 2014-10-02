A couple shiny apps
=====

This repository includes two Shiny Apps:
- **dplyr_app**: an app to help you understand and visualize the process of data manipulations in R (using the `dplyr` package). (_Note_: You will need steady internet access in order to be able to run this app successfully.)

- **rmd**: an app that lets you interactively type an RMarkdown document and immediately visualize the compiled version of the document (side by side display). When you run this app, the first thing that will happen is a window popping up, prompting you to select an Rmd document. (_Note_: this app was very very heavily borrowed from Yihui Xie's brilliant `knitr` package.)

In order to run the apps, you'll first need to install and load the `Shiny` package (you will only need to do this once):

```{r}
install.packages("shiny_apps")
require(shiny)
```

Once this is done, you can run any of the apps as many times as you want with only one line of code. For example, for the `dataOp` app, type:

```{r}
shiny::runGitHub("shiny", "bborgesr", subdir = "dplyr_app")
```

Similarly, for the `rmd` apps

```{r}
shiny::runGitHub("shiny", "bborgesr", subdir = "rmd")
```

=====

**About me:**
My name is Barbara and I'm a rising senior in Stats and CS at Macalester College. I love computational statistics and using R to transform complicated things into beautiful things (especially through visualization). In fact, the inspiration for these very apps is to help people understand and visualize some really cool data concepts (joining, grouping, summarizing...). I hope this proves right! If you have any suggestions, feel free to contact me at barb.b.ribeiro@gmail.com

