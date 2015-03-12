#Updated 3/10/15

#Failure List function
print("Script is attempting to load required packages, will install if not available.")

#The below portion checks for exsistance of packages, and either downloads or loads them
if (require(dplyr)==FALSE){
        install.packages("dplyr")
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

#Sourcing the unqiue functions that are used in this script
source('failurelistfunctions.R')
#Makes user aware of any changes, and asks for acknowledgement.
print("This Script was updated on 3/9/15, New export order is needed")
readline("Please read the readme, and then hit enter...")
readline("This Script was updated on 3/11/15, New export order is needed
Please read the readme, and then hit enter...")

#Asks the user for the name of the raw data file, and appends the name with its extension
filename <- readline("What is the data file called?... ")
filename <- paste(filename, ".tab", sep="")

#Asks the user for their desired output name, and appends the name with the xlsx extension
outputname <- readline("What is the output file called?...  ")
outputnamexlsx <- paste(outputname, ".xlsx", sep="")

#Asks the size of the data, to prevent over loading system + speed up
data_size <- readline("Is this a year or more of data? If so, multiple excel files will be made
                      enter 1 (for yes) or 2 (for no)... ")

print("Script is Running, please wait. May take up to 5 min for large data sets")
announcement <- "Script is Running, please wait. May take up to 5 min for large data sets"
print(announcement)

#reads in the raw data file
rawdata <- read.table(filename, #user specified name
                      sep="\t", #says that variables are seperated by TABS
                      stringsAsFactors=FALSE, #prevents characters being turned into factors
                      na.strings = c("", " "), #causes empty variables to be turned into NA's
                      quote="", #prevents Quoting
                      comment.char="") #prevents reading in # as a comment, not a variable

#appends colnames to the data frame
colnames(rawdata) <- c("Sequence_ID", 
                       "Sequence_Name", 
                       "Five_Prime_mod",
                       "Three_Prime_mod",
                       "Failure_Reason")
# converts the data frame to the special tbl_df class, necessary for use with DPLYR functions
raw_tbl_df <- tbl_df(rawdata)
#removes any observations that contain an NA in the Failure_Reason Variable.
not_passed <- filter(raw_tbl_df, !is.na(Failure_Reason))
#Cleans up the data, removing extra blank space and changing all notes to lower case.
not_passed <- clean_up()
#Removes not failed sequences, that contain notes, using the not_failed function
#see failurelistfunctions.R for details
only_failed <- not_failed()
#Aggregates the failure reasons, to enable correct grouping, using the failure_aggregation
#function. See failurelistfunctions.R for details
clean_failure_reassign_msokay <- failure_aggregation()
#Removes all Reassign notes from the data
clean_failure_msokay <- reason_remover(clean_failure_reassign_msokay, "Reassigned")
#removes all MS Okay notes from the data
clean_failure <- reason_remover(clean_failure_msokay, "Ms Okay")
#Groups, counts, and orders the data. Causes removal of all varialbes except Failure Reason
#and the new number_of_failures column
Failurelist_by_Reason <-
        clean_failure %>% #runs the following functions on the clean_failure data frame
        group_by(Failure_Reason) %>% # groups the data frame by failure_reason
        summarize(number_of_failures = n()) %>% #counts the number of times a failure_reason
                                                # occurs, writes new variable w/ data
        arrange(desc(number_of_failures), Failure_Reason) # arranges the data
#Generates the summary excel sheet. see summary.R for details
source('summary.R')
#converts the data back to a normal data frame, from its previous tbl_df class
class(Failurelist_by_Reason) <- "data.frame"
#writes out the data to an excel sheet
write.xlsx(Failurelist_by_Reason,#the data
           file=outputnamexlsx, #the users specified outputname with the .xlsx extension
           sheetName="Top Failure Reasons",#the sheet name
           row.names=FALSE, #It won't try to add row names
           append=TRUE) # It will add this sheet to an exsisting file if necessary.

#Generates the mod analysis sheets, see the mod_analyze.R script for details.
source('mod_Analyze.R')
#Generates the seqID sheets, see the seqID_Analyze.R script for details
source('seqID_Analyze.R')
#Generates the seqName Sheet, see seqName_Analyze.R script for details.
source('seqName_Analyze.R')

print("Finished! Check the folder for your excel files!")

#Removes everything from R memory.
#rm(list=ls())



