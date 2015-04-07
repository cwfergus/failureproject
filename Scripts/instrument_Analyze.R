#Instrument Failure Rate Counting

save_these=ls()

#Cleans up instrument field, making divergent names more similar


#take adjusted instrument names table, group via I name, count number per group
inst_count <- 
        clean_raw %>% #take clean raw data
        group_by(Instrument_Name) %>% #group via Instrument Name
        summarize(Sequences_Made = n()) #Counts the # of items in each group


fail_inst_count <-
        clean_failure_msokay %>% #take failures + ms okay sequences
        group_by(Instrument_Name) %>% #Group via Instrument Name
        summarize(Sequences_Failed = n()) #Count # of seqs in each group
inst_counts_final <- 
        all_inst_counts %>% #take all intrument counts
        #add a column that is the failure rate
        mutate(Failure_Rate = Sequences_Failed/Sequences_Made) %>% 
        arrange(desc(Failure_Rate)) #sort largest to smallest failure rate
allspots <- 1:nrow(clean_raw)
supersamspots <- grep("SAM", clean_raw$Instrument_Name)
notSSspots <- allspots[!allspots %in% supersamspots]

all_inst_select_loc <- clean_raw

for (i in notSSspots) {
        all_inst_select_loc[i, "Location"] <- NA
}

inst_loc_count <- 
        all_inst_select_loc %>% #take now modified raw data
        group_by(Instrument_Name, Location) %>% #Group via Insturment and Location
        summarize(Sequences_Made = n()) #Count number of items per group

failedspots <- 1:nrow(clean_failure_msokay) 
failedsupersamspots <- grep("SAM", clean_failure_msokay$Instrument_Name)
failednotSSspots <- allspots[!allspots %in% supersamspots]

fail_inst_select_loc <- clean_failure_msokay

for (i in notSSspots) {
        fail_inst_select_loc[i, "Location"] <- NA
}

fail_inst_loc_count <- 
        fail_inst_select_loc %>%
        group_by(Instrument_Name, Location) %>%
        summarize(Sequences_Failed = n())



inst_loc_counts_final <- 
        all_inst_loc_counts %>% #take the inclusive intstrument location coutns
        mutate(Failure_Rate = Sequences_Failed/Sequences_Made) %>% #Add failure rate column
        arrange(desc(Failure_Rate)) # Sort via failure rate

inst_fail_reasons_final <- 
        clean_failure_msokay %>% #take all failed+MS Okay sequences
        group_by(Instrument_Name, Failure_Reason) %>% #group via Inst name & Failure R
        summarize(Number_Failed = n()) %>% #count # of items in each group
        arrange(desc(Number_Failed))

class(inst_fail_reasons_final) <- "data.frame" #switch to data frame for xlsx writeout
SSID_inst<- 
        clean_failure_msokay %>%
        group_by(Instrument_Name, Failure_Reason, Sequence_Set) %>%
        summarise_each(funs(n())) %>%
        within(Instrument_and_Reason <- paste(Instrument_Name, Failure_Reason, sep = " "))


SSIDtable <- data.frame(Instrument_and_Reason = NA, Failed_Sequence_Sets = NA)

picker <-
        inst_fail_info %>%
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
        select(Instrument_and_Reason, Number_failed, Failed_Sequence_Sets) %>%
        arrange(desc(Number_failed))

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



full_list <- ls()
delete <- full_list[!full_list %in% save_these]
rm(list=delete, delete, full_list)

