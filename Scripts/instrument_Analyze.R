#Instrument Failure Rate Counting

save_these=ls() #generates a list of variables to keep at end of script

##### Instrument Failure Rate #####
# The below section generates a table showing the Failure rate for a specific Instrument

inst_count <- 
        clean_raw %>% #take clean raw data
        group_by(Instrument_Name) %>% #group via Instrument Name
        summarize(Sequences_Made = n()) #Counts the # of items in each group


fail_inst_count <-
        clean_failure_msokay %>% #take failures + ms okay sequences
        group_by(Instrument_Name) %>% #Group via Instrument Name
        summarize(Sequences_Failed = n()) #Count # of seqs in each group
#merge together the tow instrument counts, all and failed.
all_inst_counts <- merge(inst_count, fail_inst_count, by="Instrument_Name", all.x=TRUE)       
#replace NA's with 0's for failure rate math
all_inst_counts$Sequences_Failed[is.na(all_inst_counts$Sequences_Failed)] <- 0

inst_counts_final <- 
        all_inst_counts %>% #take all intrument counts
        #add a column that is the failure rate
        mutate(Failure_Rate = Sequences_Failed/Sequences_Made) %>% 
        arrange(desc(Failure_Rate)) #sort largest to smallest failure rate
##### Instrument + Location Failure Rate ####
# The below section generates a table that shows the failure rate for each location in each machine



#Generate vector of row numbers in the raw data
allspots <- 1:nrow(clean_raw)
#Find the row numbers with Super Sams as the instruments
supersamspots <- grep("SAM", clean_raw$Instrument_Name)
#Remove the super sam rows from the all rows
notSSspots <- allspots[!allspots %in% supersamspots]

#Duplicate the raw data so we can mess with it
all_inst_select_loc <- clean_raw

#remove the location field for all machines other than super sams.
#Done using the notSSspots vector made above
for (i in notSSspots) {
        all_inst_select_loc[i, "Location"] <- NA
}

inst_loc_count <- 
        all_inst_select_loc %>% #take now modified raw data
        group_by(Instrument_Name, Location) %>% #Group via Insturment and Location
        summarize(Sequences_Made = n()) #Count number of items per group

#repeate above location removal but only for failed sequences
failedspots <- 1:nrow(clean_failure_msokay) 
failedsupersamspots <- grep("SAM", clean_failure_msokay$Instrument_Name)
failednotSSspots <- failedspots[!failedspots %in% failedsupersamspots]

fail_inst_select_loc <- clean_failure_msokay

for (i in failednotSSspots) {
        fail_inst_select_loc[i, "Location"] <- NA
}

fail_inst_loc_count <- 
        fail_inst_select_loc %>%
        group_by(Instrument_Name, Location) %>%
        summarize(Sequences_Failed = n())

#make inclusive table with failure counts and made counts
all_inst_loc_counts<- merge(inst_loc_count, fail_inst_loc_count, all.x =TRUE)
#replace NA's with 0's to make it look better
all_inst_loc_counts$Sequences_Failed[is.na(all_inst_loc_counts$Sequences_Failed)] <- 0


inst_loc_counts_final <- 
        all_inst_loc_counts %>% #take the inclusive intstrument location coutns
        mutate(Failure_Rate = Sequences_Failed/Sequences_Made) %>% #Add failure rate column
        arrange(desc(Failure_Rate)) # Sort via failure rate

##### Failure Types per instrument ####
# the below area generates a table which shows the number of a specific failure per instrument

inst_fail_reasons_final <- 
        clean_failure_msokay %>% #take all failed+MS Okay sequences
        group_by(Instrument_Name, Failure_Reason) %>% #group via Inst name & Failure R
        summarize(Number_Failed = n()) %>% #count # of items in each group
        arrange(desc(Number_Failed))

class(inst_fail_reasons_final) <- "data.frame" #switch to data frame for xlsx writeout

##### Failure Reasons and SSID for each Instrument ####
#The below section generates a table showing the SSIDs for each Failure reason and Instrument combination. It also shows
# the number of failures for the combination, but not each SSID

SSID_inst<- 
        clean_failure_msokay %>%
        group_by(Instrument_Name, Failure_Reason, Sequence_Set) %>%
        summarise_each(funs(n())) %>%
        within(Instrument_and_Reason <- paste(Instrument_Name, Failure_Reason, sep = " "))


SSIDtable <- data.frame(Instrument_and_Reason = NA, Failed_Sequence_Sets = NA)

picker <-
        inst_fail_reasons_final %>%
        within(Instrument_and_Reason <- paste(Instrument_Name, Failure_Reason, sep = " "))


pick_list <- picker$Instrument_and_Reason

for (i in 1:length(pick_list)) {
        pick <- pick_list[[i]]
        spots <- grep(pick, SSID_inst$Instrument_and_Reason)
        sequence_sets <- (SSID_inst$Sequence_Set[spots])
        sequence_sets <- str_c(sequence_sets, collapse = " ")
        row <- append(pick, sequence_sets)
        SSIDtable[i,] <- row
}


SSIDtable <- merge(SSIDtable, picker)

fail_inst_SSID_final <- 
        SSIDtable %>%
        select(Instrument_and_Reason, Number_Failed, Failed_Sequence_Sets) %>%
        arrange(desc(Number_Failed))

##### Data Write out ####

instoutputname <- paste(outputname, "_instrument", ".xlsx", sep="")
if (data_size == 1) {
        write.xlsx(inst_counts_final,
                   instoutputname,
                   sheetName="Instrument Failure Counts",
                   row.names=FALSE,
                   append=TRUE)
        
        write.xlsx(inst_loc_counts_final,
                   instoutputname,
                   sheetName="Instrument + Location Failure Counts",
                   row.names=FALSE,
                   append=TRUE)
        
        write.xlsx(inst_fail_reasons_final,
                   instoutputname,
                   sheetName="Instrument Failure Reasons",
                   row.names=FALSE,
                   append=TRUE)
        write.xlsx(fail_inst_SSID_final,
                   instoutputname,
                   sheetName="Instrument, Failure, SSID's",
                   row.names=FALSE,
                   append=TRUE)
} else {
        write.xlsx(inst_counts_final,
                   outputnamexlsx,
                   sheetName="Instrument Failure Counts",
                   row.names=FALSE,
                   append=TRUE)
        
        write.xlsx(inst_loc_counts_final,
                   outputnamexlsx,
                   sheetName="Instrument + Location Failure Counts",
                   row.names=FALSE,
                   append=TRUE)
        
        write.xlsx(inst_fail_reasons_final,
                   outputnamexlsx,
                   sheetName="Instrument Failure Reasons",
                   row.names=FALSE,
                   append=TRUE) 
        write.xlsx(fail_inst_SSID_final,
                   outputnamexlsx,
                   sheetName="Instrument, Failure, SSID's",
                   row.names=FALSE,
                   append=TRUE)
}

##### Enviornment Cleanup ####
# The below section removes script specific variables

full_list <- ls()
delete <- full_list[!full_list %in% save_these]
rm(list=delete, delete, full_list)

##### Testing Area ####
clean_failure_msokay$Synthesis_Date <- as.Date(clean_failure_msokay$Synthesis_Date, format = "%m/%d/%Y")
clean_raw$Synthesis_Date <- as.Date(clean_raw$Synthesis_Date, format = "%m/%d/%Y")

inst_synDate_count <-
        clean_raw %>%
        group_by(Instrument_Name, Synthesis_Date) %>%
        summarize(Number_Made = n()) 

fail_inst_synDate_count <- 
        clean_failure_msokay %>%
        group_by(Instrument_Name, Synthesis_Date) %>%
        summarize(Number_Failed = n())

all_inst_synDate_counts <- merge(inst_synDate_count, fail_inst_synDate_count, all.x = TRUE)


inst_synDate_count$Instrument_Name <- as.factor(inst_synDate_count$Instrument_Name)
fail_inst_synDate_count$Instrument_Name <- as.factor(fail_inst_synDate_count$Instrument_Name)
#qplot(Synthesis_Date, Number_Made, data=inst_synDate_count, facets=.~Instrument_Name)

plotbase <- ggplot(fail_inst_synDate_count, aes(Synthesis_Date, Number_Failed))

plotbase + geom_point(aes(color=Instrument_Name))

plotbase + geom_point(aes(color=Instrument_Name)) + facet_wrap(~Instrument_Name, scale ="free")

class(clean_failure_msokay) <- "data.frame"

split <- split(clean_failure_msokay, clean_failure_msokay$Instrument_Name)

mgm3 <- split$MGM3
mgm3 <- select(mgm3, Synthesis_Date)
counts <- table(mgm3$Synthesis_Date)

barplot(counts, main = "Failures per Day on MGM3", names.arg=c("3/3", "3/4", "3/5", "3/6", "3/7", "3/10", "3/11", "3/12", "3/13", "3/17", "3/18", "3/19", "3/20", "3/21", "3/24", "3/25", "3/27", "3/28", "3/31"))

