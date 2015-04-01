#Updated 4/1/15

# Data Summary
# This script generates the summary sheet in the final excel file. It requies the majority
#of failurelist.R to have been run prior to its opperation.

save_these=ls()

#counts the number of rows, and such the number of sequences, in the raw data
seq_amount <- nrow(raw_tbl_df)
#counts the number of rows in the not_passed data frame
not_passed_amount <- nrow(not_passed)

#counts the number of rows in the failures+reassigns+ms okay data frame
failures_reassign_msokay_amount <- nrow(clean_failure_reassign_msokay)

#counts the number of rows in the failures+ms okay data frame
failures_msokay_amount <- nrow(clean_failure_msokay)

#counts the number of rows in the failures data frame.
failed_amount <- nrow(clean_failure)


#creates a character list of names of summary information
Catagory <- c("Total number of sequences analyzed:",
              "---",
              "# of Sequences with notes:",
              "Percent with Notes",
              "---",
              "# of failures, reassigns, and Ms Okays:",
              "Percent failures, reassigns, and Ms Okays:",
              "---",
              "# of Reassigns:",
              "# of Ms Okays",
              "---",
              "# of failed sequences:",
              "Percent Failed sequences")
#creates a results list of numbers of summary information
Result <- c(seq_amount, 
            " ",
            not_passed_amount,
            not_passed_amount/seq_amount*100, #calculates not_passed %
            " ",
            failures_reassign_msokay_amount,
            failures_reassign_msokay_amount/seq_amount*100, #failures+reassign+msokay %
            " ",
            failures_reassign_msokay_amount-failures_msokay_amount,# the number of Reassigns
            failures_msokay_amount-failed_amount, #the number of ms okays
            " ",
            failed_amount,
            failed_amount/seq_amount*100) #the real failure %

# writes the two lists into a data frame
summary <- data.frame(Catagory, Result)
# writes the data frame to an excel file
write.xlsx(summary, #the data
           file=outputnamexlsx, #the user specified name w/ .xlsx (from failurelist.R)
           sheetName="summary", #the sheet name
           row.names=FALSE, #prevents attempting to assign row names
           append=TRUE) #append to an existing file.


full_list <- ls()
delete <- full_list[!full_list %in% save_these]
rm(list=delete, delete, full_list)

