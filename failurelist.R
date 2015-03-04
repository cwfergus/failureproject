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
                       "Three_Prime_mod", 
                       "sequence",
                       "sequence_ID")
raw_tbl_df <- tbl_df(rawdata)

not_passed <- filter(raw_tbl_df, !is.na(Failure_Reason))

not_passed <- clean_up()

only_failed <- not_failed()

clean_failure_reassign_msokay <- failure_aggregation()

clean_failure_msokay <- reason_remover(clean_failure_reassign_msokay, "Reassigned")

clean_failure <- reason_remover(clean_failure_msokay, "Ms Okay")

reason_counts <-
        clean_failure %>%
        group_by(Failure_Reason) %>%
        summarize(number_of_failures = n()) %>%
        arrange(desc(number_of_failures), Failure_Reason)

failure_list <- 
        only_failed %>%
        arrange(Failure_Reason)

source('seqID_Analyze.R')

date <- Sys.Date()
countedname <- paste("Reason Counts for", date, sep=" ")
seqname <- paste("Sequence ID counts for", date, sep=" ")
listname <- paste("Failure list for", date, sep=" ")

class(reason_counts) <- "data.frame"
class(failure_list) <- "data.frame"


write.xlsx(reason_counts,
           file=outputname, 
           sheetName=countedname,
           row.names=FALSE,
           append=TRUE)

write.xlsx(seqID_top10percent,
           file=outputname, 
           sheetName=seqname,
           row.names=FALSE,
           append=TRUE)


#write.xlsx(failure_list, 
 #          outputname,
  #         sheetName=listname,
   #        row.names=FALSE,
    #       append=TRUE)

source('bothmod_Analyze.R')

#rm(list=ls())



