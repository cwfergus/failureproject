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

seqID_merged <- merge(seqID_counts, seqID_failure_counts, by="sequence_ID")

seqID_fail_rate <-
        seqID_merged %>%
        mutate(failure_rate = number_of_failures/times_made) %>%
        arrange(desc(failure_rate)) %>%
        filter(failure_rate != 1)
        
modlist <- 
        clean_failure %>%
        group_by(sequence_ID)%>%
        select(sequence_ID, Five_Prime_mod, Three_Prime_mod)



seqID_10percent <- quantile(seqID_fail_rate$failure_rate, probs=0.9)

seqID_top10percent <- filter(seqID_fail_rate, failure_rate>= seqID_10percent)

class(seqID_top10percent) <- "data.frame"

#testing region

seqID_failure_counts <-
        clean_failure %>%
        group_by(sequence_ID, Five_Prime_mod, Three_Prime_mod) %>%
        summarise_each(funs(n()))