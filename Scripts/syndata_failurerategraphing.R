clean_failure_msokay$Synthesis_Date <- as.Date(clean_failure_msokay$Synthesis_Date, format = "%m/%d/%Y")
clean_raw$Synthesis_Date <- as.Date(clean_raw$Synthesis_Date, format = "%m/%d/%Y")

synDate_count <- 
        clean_raw %>%
        group_by(Synthesis_Date) %>%
        summarize(Number_Made = n())

fail_synDate_count <-
        clean_failure_msokay %>%
        group_by(Synthesis_Date) %>%
        summarize(Number_failed = n())

synDate_count[order(synDate_count$Synthesis_Date),] -> ordered


day1 <- ordered$Synthesis_Date[1]
endDay <- ordered$Synthesis_Date[nrow(ordered)]
dates <- data.frame(Synthesis_Date =seq(day1, to = endDay, by='1 days'))

merge(dates, synDate_count, all.x=TRUE) -> test
merge(test, fail_synDate_count, all.x=TRUE) -> test
mutate(test, Failure_Rate = Number_failed/Number_Made * 100) -> test

qplot(Synthesis_Date, Failure_Rate, data = test, geom = c("smooth"))
