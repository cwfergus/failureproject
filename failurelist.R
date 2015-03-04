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


#rm(rawdata)

not_passed <- clean_up()


only_failed <- not_failed()

#rm(raw_tbl_df)

clean_failure_reassign_msokay <- failure_aggregation()


clean_failure_reassign_msokay$Failure_Reason <- gsub("Reassigned", NA, clean_failure_reassign_msokay$Failure_Reason)
clean_failure_msokay <- filter(clean_failure_reassign_msokay, !is.na(Failure_Reason))



clean_failure_msokay$Failure_Reason <- gsub("Ms Okay", NA, clean_failure_msokay$Failure_Reason)
clean_failure <- filter(clean_failure_msokay, !is.na(Failure_Reason))


reason_counts <-
        clean_failure %>%
        group_by(Failure_Reason) %>%
        summarize(number_of_failures = n()) %>%
        arrange(desc(number_of_failures), Failure_Reason)

mod_reason_counts <- 
        clean_failure %>%
        group_by(Five_Prime_mod, Three_Prime_mod) %>%
        summarize(failure_per_mod = n()) %>%
        group_by() %>%
        arrange(desc(failure_per_mod))

#rm(clean_failure)

failure_list <- 
        only_failed %>%
        arrange(Failure_Reason)

source('seqID_Analyze.R')

date <- Sys.Date()
countedname <- paste("Reason Counts for", date, sep=" ")
seqname <- paste("Sequence ID counts for", date, sep=" ")
modname <- paste("Mod Counts for", date, sep=" ")
listname <- paste("Failure list for", date, sep=" ")

class(reason_counts) <- "data.frame"
class(mod_reason_counts) <- "data.frame"
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

write.xlsx(mod_reason_counts,
           file=outputname,
           sheetName=modname,
           row.names=FALSE,
           append=TRUE)

#write.xlsx(failure_list, 
 #          outputname,
  #         sheetName=listname,
   #        row.names=FALSE,
    #       append=TRUE)


#rm(list=ls())



