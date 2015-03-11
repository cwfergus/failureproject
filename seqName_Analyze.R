#Updated 3/10/15

seqName_counts <-
        raw_tbl_df %>% #the data to pull from
        group_by(Sequence_Name) %>% #group the data by sequence ID
        summarize(times_made = n()) %>% #Count each time a unique Sequence ID exists and
        #make a new variable with that info
        arrange(desc(times_made)) #arrange via the number of times made

seqName_failure_counts <-
        clean_failure %>% #the data to pull from
        group_by(Sequence_Name) %>% #group by sequence ID
        summarize(number_of_failures = n()) %>% #count each time a SeqID exists and
        #make a new variable w/ that info
        arrange(desc(number_of_failures)) #arrange via the number of failures

seqName_Mods <-
        raw_tbl_df %>% #data to pull from
        group_by(Sequence_Name, Five_Prime_mod, Three_Prime_mod) %>% #group by seqID, 5'mod, 3'
        summarise_each(funs(n())) %>% #collapse the data by seqID, so no duplicates
        select(Sequence_Name, Five_Prime_mod, Three_Prime_mod) #select just certain variables

seqName_FR_raw <- merge(seqName_counts, seqName_failure_counts, by="Sequence_Name", all.x=TRUE)

seqName_FR_raw_Mods <- merge(seqName_FR_raw, seqName_Mods, by="Sequence_Name")
seqName_FR_raw_Mods$number_of_failures[is.na(seqName_FR_raw_Mods$number_of_failures)] <- 0




seqName_FR_Mods <-
        seqName_FR_raw_Mods %>% #data to use
        mutate(failure_rate = number_of_failures/times_made) %>% #add new variable that is
        #the number of failures variable / times made
        arrange(desc(number_of_failures)) %>% #arrange by this new Failure Rate variable
        select(c(1,4,5,2,3,6))  # Reorder the columns to look better
        
# converts to regular Data.Frame
class(seqName_FR_Mods) <- "data.frame"
#Writes out in two ways depending on data size
if (data_size == 1) {#if Large
        outputname2 <- paste("seqName", outputname, ".csv", sep="") #.csv file
        write.csv(seqName_FR_Mods, #uses write.csv as way faster
                  file=outputname2,
                  row.names=FALSE,
                  na = "")
        
} else { #else small data:
        write.xlsx(seqName_FR_Mods,#data file
                   file=outputnamexlsx, #file name specified by user in failurelist.R
                   sheetName="Sequence Name Failure Rate", #sheet name
                   row.names=FALSE,#prevent row names
                   append=TRUE)#allow it to append to existing excel file.
}



#write out the data to the excel file


