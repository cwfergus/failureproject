if (require(dplyr)==FALSE){
        install.packages(dplyr)
        library(dplyr)
} else {
        library(dplyr)
}
if (require(xlsx)==FALSE){
        install.packages("xlsx")
        library(xlsx)
} else {
        library(xlsx)
}
if (require(stringr)==FALSE) {
        install.packages("stringr")
        library(stringr)
} else {
        library(stringr)
}
source('failurelistfunctions.R')

filename <- readline("What is the data file called?... ")
filename <- paste(filename, ".tab", sep="")

outputname <- readline("What is the output file called?...  ")
outputname <- paste(outputname, ".xlsx", sep="")

rawdata <- read.table(filename, 
                      sep="\t", 
                      stringsAsFactors=FALSE, 
                      na.strings = c("", " "),
                      quote="",
                      comment.char="")

colnames(rawdata) <- c("Failure_Reason", 
                       "Five_Prime_mod", 
                       "sequence_ID")
raw_tbl_df <- tbl_df(rawdata)

not_passed <- filter(raw_tbl_df, !is.na(Failure_Reason))

not_passed <- clean_up()

only_failed <- not_failed()

clean_failure_reassign_msokay <- failure_aggregation()

clean_failure_msokay <- reason_remover(clean_failure_reassign_msokay, "Reassigned")

clean_failure <- reason_remover(clean_failure_msokay, "Ms Okay")

Failurelist_by_Reason <-
        clean_failure %>%
        group_by(Failure_Reason) %>%
        summarize(number_of_failures = n()) %>%
        arrange(desc(number_of_failures), Failure_Reason)

source('summary.R')

date <- Sys.Date()
countedname <- paste("Reason Counts for", date, sep=" ")

class(Failurelist_by_Reason) <- "data.frame"

write.xlsx(Failurelist_by_Reason,
           file=outputname, 
           sheetName=countedname,
           row.names=FALSE,
           append=TRUE)

source('seqID_Analyze.R')

source('bothmod_Analyze.R')

rm(list=ls())



