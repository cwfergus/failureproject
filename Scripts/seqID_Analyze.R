#Updated 3/10/15

#Sequence ID failure DATA script
#The script generates the Sequence ID failure rate sheet in the final excel file
#It requires the failurelist.R script to have run before it.

save_these=ls()


#Generates a list of the unique sequence ID's and the number of times made
seqID_counts <-
        clean_raw %>% #the data to pull from
        group_by(Sequence_ID) %>% #group the data by sequence ID
        summarize(times_made = n()) %>% #Count each time a unique Sequence ID exists and
                                        #make a new variable with that info
        arrange(desc(times_made)) #arrange via the number of times made

#Generates a list of the unique sequence ID's and the number of times failed
seqID_failure_counts <-
        clean_failure %>% #the data to pull from
        group_by(Sequence_ID) %>% #group by sequence ID
        summarize(number_of_failures = n()) %>% #count each time a SeqID exists and
                                                #make a new variable w/ that info
        arrange(desc(number_of_failures)) #arrange via the number of failures

#Generates a list of the unique sequence ID's and their modifications
seqID_info <-
        clean_raw %>% #data to pull from
        group_by(Sequence_ID, Five_Prime_mod, Three_Prime_mod, Sequence) %>% #group by seqID, 5'mod, 3'
        summarise_each(funs(n())) %>% #collapse the data by seqID, so no duplicates
        select(Sequence_ID, Five_Prime_mod, Three_Prime_mod, Sequence) #select just certain variables

#merge the made counts and failure counts by sequence ID
seqID_FR_raw <- merge(seqID_counts, seqID_failure_counts, by="Sequence_ID", all.x=TRUE)
#Add each sequence ID's info
seqID_FR_raw_info <- merge(seqID_FR_raw, seqID_info, by="Sequence_ID", all.x=TRUE)

seqID_FR_raw_info$number_of_failures[is.na(seqID_FR_raw_info$number_of_failures)] <- 0
#Create a new failure rate vairalbe, reorder the columns, filter out bad data, and reorder
seqID_FR_info <-
        seqID_FR_raw_info %>% #data to use
        mutate(failure_rate = number_of_failures/times_made) %>% #add new variable that is
                                                #the number of failures variable / times made
        arrange(desc(number_of_failures)) %>% #arrange by this new Failure Rate variable
        select(c(1,4,5,2,3,7,6))  # Reorder the columns to look better



#convert the data frame to a normal data frame
class(seqID_FR_info) <- "data.frame"

#Writes out in two different ways depending on Data Size. 
if (data_size == 1) { #if large:
        outputname3 <- paste(outputname, "_seqID", ".csv", sep="") #.csv ext
        write.csv(seqID_FR_info, #uses write.csv as it is WAY faster
                  file=outputname3,
                  row.names=FALSE,
                  na = "") #converts NA's to blank boxes
} else { #if small data file:
        write.xlsx(seqID_FR_info,#data file
                   file=outputnamexlsx, #file name specified by user in failurelist.R
                   sheetName="Sequence ID Failure Rate", #sheet name
                   row.names=FALSE,#prevent row names
                   append=TRUE)#allow it to append to existing excel file.

}

full_list <- ls()
delete <- full_list[!full_list %in% save_these]
rm(list=delete, delete, full_list)

