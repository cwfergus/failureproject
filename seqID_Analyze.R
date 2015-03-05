#Sequence ID failure DATA script
#The script generates the Sequence ID failure rate sheet in the final excel file
#It requires the failurelist.R script to have run before it.

#Generates a list of the unique sequence ID's and the number of times made
seqID_counts <-
        raw_tbl_df %>% #the data to pull from
        group_by(sequence_ID) %>% #group the data by sequence ID
        summarize(times_made = n()) %>% #Count each time a unique Sequence ID exists and
                                        #make a new variable with that info
        arrange(desc(times_made)) #arrange via the number of times made

#Generates a list of the unique sequence ID's and the number of times failed
seqID_failure_counts <-
        clean_failure %>% #the data to pull from
        group_by(sequence_ID) %>% #group by sequence ID
        summarize(number_of_failures = n()) %>% #count each time a SeqID exists and
                                                #make a new variable w/ that info
        arrange(desc(number_of_failures)) #arrange via the number of failures

#Generates a list of the unique sequence ID's and their modifications
seqID_Mods <-
        raw_tbl_df %>% #data to pull from
        group_by(sequence_ID, Five_Prime_mod, Three_Prime_mod) %>% #group by seqID, 5'mod, 3'
        summarise_each(funs(n())) %>% #collapse the data by seqID, so no duplicates
        select(sequence_ID, Five_Prime_mod, Three_Prime_mod) #select just certain variables

#merge the made counts and failure counts by sequence ID
seqID_FR_raw <- merge(seqID_counts, seqID_failure_counts, by="sequence_ID")
#Add each sequence ID's mods
seqID_FR_raw_Mods <- merge(seqID_FR_raw, seqID_Mods, by="sequence_ID")
#Create a new failure rate vairalbe, reorder the columns, filter out bad data, and reorder
seqID_FR_Mods <-
        seqID_FR_raw_Mods %>% #data to use
        mutate(failure_rate = number_of_failures/times_made) %>% #add new variable that is
                                                #the number of failures variable / times made
        arrange(desc(failure_rate)) %>% #arrange by this new Failure Rate variable
        select(c(1,2,3,6,4,5)) %>% # Reorder the columns to look better
        filter(failure_rate != 1) #remove bad data, ie failure rate =1 (not likely!)

# find the value that represents the highest 2% cut off for failure_rate
seqID_FR_2percent <- quantile(seqID_FR_Mods$failure_rate, probs=0.98) 
#removes all seqID's with a failure_rate lower than the 2% cut off
seqID_FR_top2percent <- filter(seqID_FR_Mods, failure_rate>= seqID_FR_2percent)
#convert the data frame to a normal data frame
class(seqID_FR_top2percent) <- "data.frame"
#write out the data to the excel file
write.xlsx(seqID_FR_top2percent,#data file
           file=outputname, #file name specified by user in failurelist.R
           sheetName="Top 2 percent of SeqID failures", #sheet name
           row.names=FALSE,#prevent row names
           append=TRUE)#allow it to append to existing excel file.


