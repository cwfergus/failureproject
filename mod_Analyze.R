# Mod failure analysis

mod_counts <-
        raw_tbl_df %>%
        group_by(Five_Prime_mod, Three_Prime_mod) %>%
        summarize(times_made = n()) %>%
        arrange(desc(times_made))

mod_failure_counts <-
        clean_failure %>%
        group_by(Five_Prime_mod, Three_Prime_mod) %>%
        summarize(number_of_failures = n()) %>%
        arrange(desc(number_of_failures))

mod_FR_raw <- merge(mod_counts, mod_failure_counts, all.x=TRUE)

mod_FR_raw$number_of_failures[is.na(mod_FR_raw[,4])] <- 0

mod_FR <-
        mod_FR_raw %>%
        mutate(failure_rate = number_of_failures/times_made) %>%
        arrange(desc(failure_rate)) %>%
        filter(failure_rate != 1)

###

mod5_counts <-
        raw_tbl_df %>%
        group_by(Five_Prime_mod) %>%
        summarize(times_made = n()) %>%
        arrange(desc(times_made))

mod5_failure_counts <-
        clean_failure %>%
        group_by(Five_Prime_mod) %>%
        summarize(number_of_failures = n()) %>%
        arrange(desc(number_of_failures))

mod5_FR_raw <- merge(mod5_counts, mod5_failure_counts, all.x=TRUE)

mod5_FR_raw$number_of_failures[is.na(mod5_FR_raw[,3])] <- 0

mod5_FR <-
        mod5_FR_raw %>%
        mutate(failure_rate = number_of_failures/times_made) %>%
        arrange(desc(failure_rate)) %>%
        filter(failure_rate != 1)

###

mod3_counts <-
        raw_tbl_df %>%
        group_by(Three_Prime_mod) %>%
        summarize(times_made = n()) %>%
        arrange(desc(times_made))

mod3_failure_counts <-
        clean_failure %>%
        group_by(Three_Prime_mod) %>%
        summarize(number_of_failures = n()) %>%
        arrange(desc(number_of_failures))

mod3_FR_raw <- merge(mod3_counts, mod3_failure_counts, all.x=TRUE)

mod3_FR_raw$number_of_failures[is.na(mod3_FR_raw[,3])] <- 0

mod3_FR <-
        mod3_FR_raw %>%
        mutate(failure_rate = number_of_failures/times_made) %>%
        arrange(desc(failure_rate)) %>%
        filter(failure_rate != 1)


###

class(mod_FR) <- "data.frame"
class(mod5_FR) <- "data.frame"
class(mod3_FR) <- "data.frame"

write.xlsx(mod_FR,
           file=outputname,
           sheetName="Both Mod Failure Rate",
           row.names=FALSE,
           append=TRUE)

write.xlsx(mod5_FR,
           file=outputname,
           sheetName="Five Prime Mod Failure Rate",
           row.names=FALSE,
           append=TRUE)

write.xlsx(mod3_FR,
           file=outputname,
           sheetName="Three Prime Mod Failure Rate",
           row.names=FALSE,
           append=TRUE)
