#Sequence ID failure DATA script


seqID_counts <-
        raw_tbl_df %>%
        group_by(sequence_ID) %>%
        summarize(times_made = n()) %>%
        arrange(desc(times_made))

seqID_failure_counts <-
        clean_failure %>%
        group_by(sequence_ID) %>%
        summarize(number_of_failures = n()) %>%
        arrange(desc(number_of_failures))

seqID_Mods <-
        clean_failure %>%
        group_by(sequence_ID, Five_Prime_mod, Three_Prime_mod) %>%
        summarise_each(funs(n())) %>%
        select(sequence_ID, Five_Prime_mod, Three_Prime_mod)

seqID_FR_raw <- merge(seqID_counts, seqID_failure_counts, by="sequence_ID")

seqID_FR_raw_Mods <- merge(seqID_FR_raw, seqID_Mods, by="sequence_ID")

seqID_FR_Mods <-
        seqID_FR_raw_Mods %>%
        mutate(failure_rate = number_of_failures/times_made) %>%
        arrange(desc(failure_rate)) %>%
        select(c(1,2,3,6,4,5)) %>%
        filter(failure_rate != 1)
        
seqID_10percent <- quantile(seqID_FR_Mods$failure_rate, probs=0.9)

seqID_top10percent <- filter(seqID_FR_Mods, failure_rate>= seqID_10percent)

class(seqID_top10percent) <- "data.frame"

#testing region

