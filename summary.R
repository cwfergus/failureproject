# Data Summary

seq_amount <- nrow(raw_tbl_df)
not_passed_amount <- nrow(not_passed)
failures_reassign_msokay_amount <- nrow(clean_failure_reassign_msokay)
failures_msokay_amount <- nrow(clean_failure_msokay)
failed_amount <- nrow(clean_failure)

data_summary <- function () {
        Catagory <- c("Total number of sequences analyzed:",
                      "---",
                      "Not passed amount:",
                      "Percent Not Passed",
                      "---",
                      "Total number of failures and reassigns found:",
                      "Percent failures, reassigns, and Ms Okays:",
                      "---",
                      "# of Reassigns:",
                      "# of Ms Okays",
                      "---",
                      "Total failed:",
                      "Percent Failed")
        Result <- c(seq_amount, 
                    " ",
                    not_passed_amount,
                    not_passed_amount/seq_amount*100,
                    " ",
                    failures_reassign_msokay_amount,
                    failures_reassign_msokay_amount/seq_amount*100,
                    " ",
                    failures_reassign_msokay_amount-failures_msokay_amount,
                    failures_msokay_amount-failed_amount,
                    " ",
                    failed_amount,
                    failed_amount/seq_amount*100)
        data.frame(Catagory, Result)
}

summary <- data_summary()

write.xlsx(summary,
           file=outputname, 
           sheetName="summary",
           row.names=FALSE,
           append=FALSE)
