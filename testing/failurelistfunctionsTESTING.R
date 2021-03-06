#Character Clean up function
#This function is used to clean up the raw data to enable easy manipulation
clean_up <- function(){
        #converts failure reasons to lower case
        not_passed$Failure_Reason <- tolower(not_passed$Failure_Reason)
        #turns accidental double spaces into single spaces
        not_passed$Failure_Reason <- gsub("  ", " ", not_passed$Failure_Reason)
        #removes any extra space at the beginning or end of notes
        not_passed$Failure_Reason <- str_trim(not_passed$Failure_Reason)
        not_passed
}

#None Failure removal
#Intended to remove most sequences that did not actually failed by have notes in their
#failure Reason section.
not_failed <- function(){
        #changes any notes with the letters "see" to NA
        not_passed$Failure_Reason <- gsub("ms n", NA, not_passed$Failure_Reason)
        #changes any notes that are NA to "Ms NOT Okay"
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "Ms NOT Okay"
        #etc #etc #etc
        not_passed$Failure_Reason <- gsub("ms o", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "Ms Okay"
        
        not_passed$Failure_Reason <- gsub("assig", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "Reassigned"
        
        not_passed$Failure_Reason <- gsub("yield", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason <- gsub("yeild", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason <- gsub("no dn", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "Low Yield"
        
        not_passed$Failure_Reason <- gsub("see", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"

        
        not_passed$Failure_Reason <- gsub("extra material", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("archive material", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("collection", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("stellaris o", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("pass", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("wobble o", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("wobbles o", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("recheck", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("relot", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("re-lot", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        
        not_passed$Failure_Reason <- gsub("comb", NA, not_passed$Failure_Reason)
        not_passed$Failure_Reason[is.na(not_passed$Failure_Reason)] <- "REMOVED"
        #removes any that have NA for the failure reason.
        not_passed
}
 # this function is used to remove specific failure reasons from the data
reason_remover <- function(dataframe, reason) {
        dataframe$Failure_Reason <- gsub(reason, NA, dataframe$Failure_Reason)
        filter(dataframe, !is.na(Failure_Reason))
}

#Failure aggregation
#Used to attempt to provide common failure reason notes to divergent failure reason notes.
failure_aggregation <- function(){
        # finds anything with the characters "ms n" and changes the note to NA
       
        
        only_failed$Failure_Reason <- gsub("base", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Base-swap"
        
        only_failed$Failure_Reason <- gsub("wrong m", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Wrong Mass"
        
        only_failed$Failure_Reason <- gsub("flush", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Flushed"
        
        only_failed$Failure_Reason <- gsub("3 stel", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("every sample", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("all samples failed", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("stellaris f", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("more then three", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("more than 3", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Stellaris failures"
        
        only_failed$Failure_Reason <- gsub("extra tet", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Extra TET coupled"
        
        only_failed$Failure_Reason <- gsub("bhq3", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("bhq-3", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor BHQ3 coupling"
        
        only_failed$Failure_Reason <- gsub("bhq2", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("bhq-2", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor BHQ2 coupling"
        
        only_failed$Failure_Reason <- gsub("bhq1", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("bhq-1", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor BHQ1 coupling"
        
        only_failed$Failure_Reason <- gsub("tet", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor TET"
        
        only_failed$Failure_Reason <- gsub("extra fam", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Extra FAM coupled"
        
        only_failed$Failure_Reason <- gsub("fam", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor FAM"
        
        only_failed$Failure_Reason <- gsub("biotin", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor Biotin Coupling"
        
        only_failed$Failure_Reason <- gsub("contamin", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Contamination"
        
        only_failed$Failure_Reason <- gsub("fluor", "Poor Fluorescense", only_failed$Failure_Reason)
        
        only_failed$Failure_Reason <- gsub("impurity", "ImPurity", only_failed$Failure_Reason)
        
        only_failed$Failure_Reason <- gsub("purity", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor Purity"
        
        only_failed$Failure_Reason <- gsub("n-", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "N- failure"
        
        only_failed$Failure_Reason <- gsub("syn", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Synthesis Failure"
        
        only_failed$Failure_Reason <- gsub("colum", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Column Issue"
        
        only_failed$Failure_Reason <- gsub("flp", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("no pro", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "No FLP"
        
        only_failed$Failure_Reason <- gsub("dmt", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "DMT left on"
        

        
        only_failed$Failure_Reason <- gsub("depur", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Depurination"
        
        only_failed$Failure_Reason <- gsub("mmt", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "MMT left on"
        
        only_failed$Failure_Reason <- gsub("phosp", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor Phosphate Coupling"
        
        only_failed$Failure_Reason <- gsub("poor j", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Poor Joe coupling"
        
        only_failed$Failure_Reason <- gsub("incom", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("acetyl", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("benz", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("cyano", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("deprot", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Incomplete Deprotection"
        
        only_failed$Failure_Reason <- gsub("dye", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Dye failure"
        
        only_failed$Failure_Reason <- gsub("scram", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Plate Scrambled"
        
        only_failed$Failure_Reason <- gsub("yield", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("yeild", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason <- gsub("no dn", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Low Yield"
        

        only_failed$Failure_Reason <- gsub("-1", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-2", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-3", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-4", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-5", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-6", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-7", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-8", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("-9", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+1", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+2", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+3", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+4", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+5", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+6", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason  <- gsub("+7", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+8", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason <- gsub("+9", NA, only_failed$Failure_Reason, fixed=TRUE)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Impurity Present"
        only_failed
        
}

test_write_out <- function(variablename, outputname="test.csv"){
        class(variablename) <- "data.frame"
        write.csv(variablename,
                   file=outputname, 
                   row.names=FALSE,)
}