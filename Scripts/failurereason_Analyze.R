#Reason Analyze

Failurelist_by_Reason <-
        clean_failure %>% #runs the following functions on the clean_failure data frame
        group_by(Failure_Reason) %>% # groups the data frame by failure_reason
        summarize(number_of_failures = n()) %>% #counts the number of times a failure_reason
        # occurs, writes new variable w/ data
        arrange(desc(number_of_failures), Failure_Reason)

class(Failurelist_by_Reason) <- "data.frame"
#writes out the data to an excel sheet
if (data_size == 1) { #if large:
        reasonoutputname <- paste(outputname, "_FailureReason", ".csv", sep="") #.csv ext
        write.csv(Failurelist_by_Reason, #uses write.csv as it is WAY faster
                  file=reasonoutputname,
                  row.names=FALSE,
                  na = "") #converts NA's to blank boxes
} else { #if small data file:
        write.xlsx(Failurelist_by_Reason,#data file
                   file=outputnamexlsx, #file name specified by user in failurelist.R
                   sheetName="Failure Reasons", #sheet name
                   row.names=FALSE,#prevent row names
                   append=TRUE)#allow it to append to existing excel file.
        
}