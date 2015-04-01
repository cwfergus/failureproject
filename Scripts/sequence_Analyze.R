#Updated 3/10/15

save_these=ls()


sequence_counts <-
        raw_tbl_df %>% #the data to pull from
        group_by(Sequence, Five_Prime_mod, Three_Prime_mod) %>% #group the data by sequence ID
        summarize(times_made = n()) %>% #Count each time a unique Sequence ID exists and
        #make a new variable with that info
        arrange(desc(times_made)) #arrange via the number of times made

sequence_failure_counts <-
        clean_failure %>% #the data to pull from
        group_by(Sequence, Five_Prime_mod, Three_Prime_mod) %>% #group by sequence ID
        summarize(number_of_failures = n()) %>% #count each time a SeqID exists and
        #make a new variable w/ that info
        arrange(desc(number_of_failures)) #arrange via the number of failures



sequence_FR_raw <- merge(sequence_counts, sequence_failure_counts, all.x=TRUE)

sequence_FR_raw$number_of_failures[is.na(sequence_FR_raw$number_of_failures)] <- 0




sequence_FR <-
        sequence_FR_raw %>% #data to use
        mutate(failure_rate = number_of_failures/times_made) %>% #add new variable that is
        #the number of failures variable / times made
        arrange(desc(number_of_failures))#arrange by this new Failure Rate variable # Reorder the columns to look better
        
# converts to regular Data.Frame
class(sequence_FR) <- "data.frame"
#Writes out in two ways depending on data size
if (data_size == 1) {#if Large
        outputname2 <- paste(outputname, "_sequence", ".csv", sep="") #.csv file
        write.csv(sequence_FR, #uses write.csv as way faster
                  file=outputname2,
                  row.names=FALSE,
                  na = "")
        
} else { #else small data:
        write.xlsx(sequence_FR,#data file
                   file=outputnamexlsx, #file name specified by user in failurelist.R
                   sheetName="Sequence Failure Rate", #sheet name
                   row.names=FALSE,#prevent row names
                   append=TRUE)#allow it to append to existing excel file.
}

full_list <- ls()
delete <- full_list[!full_list %in% save_these]
rm(list=delete, delete, full_list)

#write out the data to the excel file


