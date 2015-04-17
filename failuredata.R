#Updated 4/1/15

#Failure List function
print("Script is attempting to load required packages, will install if not available.")

#The below portion checks for exsistance of packages, and either downloads or loads them
source('Scripts/packageload.R')

#Sourcing the unqiue functions that are used in this script
source("Scripts/failurelistfunctions.R")
#Makes user aware of any changes, and asks for acknowledgement.
readline("This Script was updated on 4/1/15, New export order/info is needed
Please read the readme, and then hit enter...")

#Asks the user for the name of the raw data file, and appends the name with its extension
filename <- readline("What is the data file called?... ")
if (str_sub(filename, start=-4)!=".tab") {
        filename <- paste(filename, ".tab", sep="")  
}


#Asks the user for their desired output name, and appends the name with the xlsx extension
outputname <- readline("What do you want the output file called? (don't add extension)...  ")
outputnamexlsx <- paste(outputname, ".xlsx", sep="")
outputnamerawcsv <- paste(outputname, "_raw", ".csv", sep="")

Analysis_files <- c("Everything", "Failure Reason", 
                    "Modification Analysis", "Sequence ID Analysis", 
                    "Sequence Name Analysis", "Sequence Analysis", 
                    "Instrument Analysis", "Failure Change comparison")

Analysis_files <- data.frame(Analysis_files)

print(Analysis_files)
datachoice <- readline("Enter the number of what analysis you want... ")


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
                       "Sequence",
                       "Five_Prime_mod",
                       "Three_Prime_mod",
                       "Failure_Reason",
                       "Instrument_Name",
                       "Location",
                       "Sequence_Set",
                       "Synthesis_Date")
if (datachoice == 1 | datachoice == 8){
        data_size = 1
} else {
        data_size = 2
}

rawdata <-data.frame(lapply(rawdata, function(v){
        if (is.character(v)) {
                return(as.character(toupper(v)))
        } else return(v)
}))

rawdata$Instrument_Name <- na.locf(rawdata$Instrument_Name, na.rm=FALSE)
rawdata$Location <- na.locf(rawdata$Location, na.rm=FALSE)
rawdata$Sequence_Set <- na.locf(rawdata$Sequence_Set, na.rm=FALSE)
rawdata$Synthesis_Date <- na.locf(rawdata$Synthesis_Date)
rawdata <- mutate(rawdata, originalnote = Failure_Reason)
# converts the data frame to the special tbl_df class, necessary for use with DPLYR functions

raw_tbl_df <- tbl_df(rawdata)

clean_raw <- 
        raw_tbl_df %>%
        note_clean_up() %>%
        inst_raw_clean() %>%
        inst_name_adjust()
        

#removes any observations that contain an NA in the Failure_Reason Variable.
not_passed <- filter(clean_raw, !is.na(Failure_Reason))
#Cleans up the data, removing extra blank space and changing all notes to lower case.

#Removes not failed sequences, that contain notes, using the not_failed function
#see failurelistfunctions.R for details
only_failed <- not_failed(not_passed)

#Aggregates the failure reasons, to enable correct grouping, using the failure_aggregation
#function. See failurelistfunctions.R for details
everything_wnotes <- failure_aggregation(only_failed)

clean_failure_reassign_msokay <- reason_remover(everything_wnotes, "REMOVED")

#Removes all Reassign notes from the data
clean_failure_msokay <- reason_remover(clean_failure_reassign_msokay, "Reassigned")
#removes all MS Okay notes from the data
clean_failure <- reason_remover(clean_failure_msokay, "Ms Okay")

#Generates the summary excel sheet. see summary.R for details
source('Scripts/summary.R')
# 
if (datachoice == 2 | datachoice == 1) {
        source('Scripts/failurereason_Analyze.R')
}
if (datachoice == 3 | datachoice == 1) {
        source('Scripts/mod_Analyze.R')
}
if (datachoice == 4 | datachoice == 1) {
        source('Scripts/seqID_Analyze.R')  
} 
if (datachoice == 5 | datachoice == 1) {
        source('Scripts/seqName_Analyze.R')
} 
if (datachoice == 6 | datachoice == 1) {
        source('Scripts/sequence_Analyze.R')
} 
if (datachoice == 7 | datachoice == 1) {
        source('Scripts/instrument_Analyze.R')
        source('Scripts//instrumentgraphing.R')
} 
if (datachoice == 8 | datachoice == 1) {
        write.csv(everything_wnotes, file=outputnamerawcsv)
}


print("Finished! Check the folder for your excel files!")

#Removes everything from R memory.
#rm(list=ls())



