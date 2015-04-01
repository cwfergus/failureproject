#Instrument Failure Rate Counting

save_these=ls()

raw_inst_count <- 
        raw_tbl_df %>%
        group_by(Instrument_Name) %>%
        summarize(Sequences_made = n())

fail_inst_count <-
        clean_failure %>%
        group_by(Instrument_Name) %>%
        summarize(Sequences_failed = n())

inst_counts_raw <- merge(raw_inst_count, fail_inst_count, by="Instrument_Name", all.x=TRUE)
        
inst_counts_raw$Sequences_failed[is.na(inst_counts_raw$Sequences_failed)] <- 0

inst_counts <- mutate(inst_counts_raw, failure_rate = Sequences_failed/Sequences_made)


raw_inst_loc_count <- 
        raw_tbl_df %>%
        group_by(Instrument_Name, Location) %>%
        summarize(Sequences_made = n())

fail_inst_loc_count <- 
        clean_failure %>%
        group_by(Instrument_Name, Location) %>%
        summarize(Sequences_failed = n())

inst_loc_counts_raw <- merge(raw_inst_loc_count, fail_inst_loc_count, all.x =TRUE)

inst_loc_counts_raw$Sequences_failed[is.na(inst_loc_counts_raw$Sequences_failed)] <- 0

inst_loc_counts <- mutate(inst_loc_counts_raw, failure_rate = Sequences_failed/Sequences_made)
        
inst_failure_info <- 
        clean_failure %>%
        group_by(Instrument_Name, Location, Failure_Reason) %>%
        summarize(Failed_reasons = n())

class(inst_failure_info) <- "data.frame"

instoutputname <- paste(outputname, "_instrument", ".xlsx", sep="")

write.xlsx(inst_counts,
           instoutputname,
           sheetName="Instrument Failure Counts",
           row.names=FALSE,
           append=TRUE)

write.xlsx(inst_loc_counts,
           instoutputname,
           sheetName="Instrument + Location Failure Counts",
           row.names=FALSE,
           append=TRUE)

write.xlsx(inst_failure_info,
           instoutputname,
           sheetName="Instrument Failure Reasons",
           row.names=FALSE,
           append=TRUE)




full_list <- ls()
delete <- full_list[!full_list %in% save_these]
rm(list=delete, delete, full_list)

