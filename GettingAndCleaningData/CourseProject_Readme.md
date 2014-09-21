Getting and Cleaning Data: Course Project Readme file
========================================================
README might say, "Read these files in, combined them in this way, subsetted this using that, transformed these variables, changed an ordered list to a dataframe, wrote data-frame out using write.table". The README is much more concerned with how to use the computer to do the work and to look at the work.

The R code can be run so long as it is the same directory containing the UCI HAR Dataset directory which contains the datafiles.
We read in the training sets using read.table and combine the Subject_training and Y_training to the features dataset using cbind.
Similarly we create the test set and combing using rbind.


This is an R Markdown document. Markdown is a simple formatting syntax for authoring web pages (click the **Help** toolbar button for more details on using R Markdown).

When you click the **Knit HTML** button a web page will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:

```{r}
summary(cars)
```

You can also embed plots, for example:

```{r fig.width=7, fig.height=6}
plot(cars)
```

