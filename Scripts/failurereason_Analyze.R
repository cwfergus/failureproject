#Reason Analyze

Failurelist_by_Reason <-
        clean_failure %>% #runs the following functions on the clean_failure data frame
        group_by(Failure_Reason) %>% # groups the data frame by failure_reason
        summarize(number_of_failures = n()) %>% #counts the number of times a failure_reason
        # occurs, writes new variable w/ data
        arrange(desc(number_of_failures), Failure_Reason)

class(Failurelist_by_Reason) <- "data.frame"
#writes out the data to an excel sheet
write.xlsx(Failurelist_by_Reason,#the data
           file=outputnamexlsx, #the users specified outputname with the .xlsx extension
           sheetName="Top Failure Reasons",#the sheet name
           row.names=FALSE, #It won't try to add row names
           append=TRUE)