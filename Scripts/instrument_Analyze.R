#Instrument Failure Rate Counting

save_these=ls()

#Cleans up instrument field, making divergent names more similar
raw_inst_count <- inst_raw_clean(raw_tbl_df)
#Adjust intrument names to remove certain charactersitic ex) C1 or C9
name_adj_inst_count <- Inst_name_adjust(raw_inst_count)

inst_count <- 
        name_adj_inst_count %>%
        group_by(Instrument_Name) %>%
        summarize(Sequences_made = n())

raw_fail_inst_count <- inst_raw_clean(clean_failure_msokay)
fail_name_adju_inst_count <- Inst_name_adjust(raw_fail_inst_count)

fail_inst_count <-
        fail_name_adju_inst_count %>%
        group_by(Instrument_Name) %>%
        summarize(Sequences_failed = n())

inst_counts_final <- merge(inst_count, fail_inst_count, by="Instrument_Name", all.x=TRUE)       
inst_counts_final$Sequences_failed[is.na(inst_counts_final$Sequences_failed)] <- 0
inst_counts_final <- mutate(inst_counts_final, failure_rate = Sequences_failed/Sequences_made)
inst_counts_final <- arrange(inst_counts_final, desc(failure_rate))

raw_inst_count_adjust <- raw_inst_count
raw_inst_count_adjust$Instrument_Name <- gsub(" C", " c", raw_inst_count_adjust$Instrument_Name)
raw_inst_count_adjust$Instrument_Name <- gsub("C", " c", raw_inst_count_adjust$Instrument_Name)

inst_loc_count <- 
        raw_inst_count_adjust %>%
        group_by(Instrument_Name, Location) %>%
        summarize(Sequences_made = n())

raw_fail_inst_count_adjust <- raw_fail_inst_count
raw_fail_inst_count_adjust$Instrument_Name <- gsub(" C", " c", raw_fail_inst_count_adjust$Instrument_Name)
raw_fail_inst_count_adjust$Instrument_Name <- gsub("C", " c", raw_fail_inst_count_adjust$Instrument_Name)

fail_inst_loc_count <- 
        raw_fail_inst_count_adjust %>%
        group_by(Instrument_Name, Location) %>%
        summarize(Sequences_failed = n())

inst_loc_counts_raw <- merge(inst_loc_count, fail_inst_loc_count, all.x =TRUE)
inst_loc_counts_raw$Sequences_failed[is.na(inst_loc_counts_raw$Sequences_failed)] <- 0
inst_loc_counts_final <- mutate(inst_loc_counts_raw, failure_rate = Sequences_failed/Sequences_made)
inst_loc_counts_final <- arrange(inst_loc_counts_final, desc(failure_rate))

inst_failure_info <- 
        fail_name_adju_inst_count %>%
        group_by(Instrument_Name, Failure_Reason) %>%
        summarize(Number_failed = n())

class(inst_failure_info) <- "data.frame"
Instrument_Failure_Reasons <- arrange(inst_failure_info, desc(Number_failed))

SSIDInst<- 
        fail_name_adju_inst_count %>%
        group_by(Instrument_Name, Failure_Reason, Sequence_Set) %>%
        summarise_each(funs(n())) %>%
        within(Combined <- paste(Instrument_Name, Failure_Reason, sep = " "))


SSIDtable <- data.frame(Instrument_and_Reason = NA, Failed_Sequence_Sets = NA)

picker <-
        inst_failure_info %>%
        within(Combined <- paste(Instrument_Name, Failure_Reason, sep = " "))


pick_list <- picker$Combined

for (i in 1:length(pick_list)) {
        pick <- pick_list[[i]]
        spots <- grep(pick, SSIDInst$Combined)
        sequence_sets <- (SSIDInst$Sequence_Set[spots])
        sequence_sets <- str_c(sequence_sets, collapse = " ")
        row <- append(pick, sequence_sets)
        SSIDtable[i,] <- row
}

merger <- within(inst_failure_info, Instrument_and_Reason <- paste(Instrument_Name, Failure_Reason, sep = " "))

SSIDtable <- merge(SSIDtable, merger)
SSIDtable <- select(SSIDtable, Instrument_and_Reason, Number_failed, Failed_Sequence_Sets)
Instrument_Failure_SSID <- arrange(SSIDtable, desc(Number_failed))

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
        
        write.xlsx(Instrument_Failure_Reasons,
                   instoutputname,
                   sheetName="Instrument Failure Reasons",
                   row.names=FALSE,
                   append=TRUE)
        write.xlsx(Instrument_Failure_SSID,
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
        
        write.xlsx(Instrument_Failure_Reasons,
                   outputnamexlsx,
                   sheetName="Instrument Failure Reasons",
                   row.names=FALSE,
                   append=TRUE) 
        write.xlsx(Instrument_Failure_SSID,
                   outputnamexlsx,
                   sheetName="Instrument, Failure, SSID's",
                   row.names=FALSE,
                   append=TRUE)
}



full_list <- ls()
delete <- full_list[!full_list %in% save_these]
rm(list=delete, delete, full_list)

