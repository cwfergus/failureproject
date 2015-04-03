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
        only_failed$Failure_Reason <- gsub("ms n", NA, only_failed$Failure_Reason)
        #changes any notes that are NA to "Ms NOT Okay"
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Ms NOT Okay"
        #etc #etc #etc
        only_failed$Failure_Reason <- gsub("ms o", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Ms Okay"
        
        only_failed$Failure_Reason <- gsub("assig", NA, only_failed$Failure_Reason)
        only_failed$Failure_Reason[is.na(only_failed$Failure_Reason)] <- "Reassigned"
        
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

inst_raw_clean <- function(dataset){
        dataset$Instrument_Name <- gsub("/", " ", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("-", "", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("#", "", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("H-6", "H6", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("XPP", "X", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("XP", "X", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub(" PLATINUM", "", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub(" GOLD", "", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("IIII", "4", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("III", "3", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("II", "2", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("I", "1", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("MM ", "MM", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("MGM ", "MGM", dataset$Instrument_Name)
        dataset$Instrument_Name <- gsub("SAM 12", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 12"
        dataset$Instrument_Name <- gsub("SAM 11", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 11"
        dataset$Instrument_Name <- gsub("SAM 10", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 10"
        dataset$Instrument_Name <- gsub("SAM 9", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 9"
        dataset$Instrument_Name <- gsub("SAM 8", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 8"
        dataset$Instrument_Name <- gsub("SAM 7", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 7"
        dataset$Instrument_Name <- gsub("SAM 6", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 6"
        dataset$Instrument_Name <- gsub("SAM 5", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 5"
        dataset$Instrument_Name <- gsub("SAM 4", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 4"
        dataset$Instrument_Name <- gsub("SAM 3", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 3"
        dataset$Instrument_Name <- gsub("SAM 2", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 2"
        dataset$Instrument_Name <- gsub("SAM 1", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM 1"
        dataset
}

Inst_name_adjust <- function(dataset2){
        dataset2$Instrument_Name <- gsub("H6", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "h6"
        
        dataset2$Instrument_Name <- gsub("MM12", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm12"
        dataset2$Instrument_Name <- gsub("MM11", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm11"
        dataset2$Instrument_Name <- gsub("MM10", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm10"
        dataset2$Instrument_Name <- gsub("MM9", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm9"
        dataset2$Instrument_Name <- gsub("MM8", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm8"
        dataset2$Instrument_Name <- gsub("MM7", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm7"
        dataset2$Instrument_Name <- gsub("MM6", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm6"
        dataset2$Instrument_Name <- gsub("MM5", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM5"
        dataset2$Instrument_Name <- gsub("MM4", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm4"
        dataset2$Instrument_Name <- gsub("MM3", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM3"
        dataset2$Instrument_Name <- gsub("MM2", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM2"
        dataset2$Instrument_Name <- gsub("MM1", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "mm1"
        
        dataset2$Instrument_Name <- gsub("MGM12", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM12"
        dataset2$Instrument_Name <- gsub("MGM11", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM11"
        dataset2$Instrument_Name <- gsub("MGM10", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM10"
        dataset2$Instrument_Name <- gsub("MGM9", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM9"
        dataset2$Instrument_Name <- gsub("MGM8", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM8"
        dataset2$Instrument_Name <- gsub("MGM7", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM7"
        dataset2$Instrument_Name <- gsub("MGM6", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM6"
        dataset2$Instrument_Name <- gsub("MGM5", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM5"
        dataset2$Instrument_Name <- gsub("MGM4", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM4"
        dataset2$Instrument_Name <- gsub("MGM3", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM3"
        dataset2$Instrument_Name <- gsub("MGM2", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM2"
        dataset2$Instrument_Name <- gsub("MGM1", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "MGM1"
        
        
        dataset2$Instrument_Name <- gsub("X14", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x14"
        dataset2$Instrument_Name <- gsub("X13", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x13"
        dataset2$Instrument_Name <- gsub("X12", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x12"
        dataset2$Instrument_Name <- gsub("X11", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x11"
        dataset2$Instrument_Name <- gsub("X10", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x10"
        dataset2$Instrument_Name <- gsub("X9", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x9"
        dataset2$Instrument_Name <- gsub("X8", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x8"
        dataset2$Instrument_Name <- gsub("X7", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x7"
        dataset2$Instrument_Name <- gsub("X6", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x6"
        dataset2$Instrument_Name <- gsub("X5", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x5"
        dataset2$Instrument_Name <- gsub("X4", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x4"
        dataset2$Instrument_Name <- gsub("X3", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x3"
        dataset2$Instrument_Name <- gsub("X2", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x2"
        dataset2$Instrument_Name <- gsub("X1", NA, dataset2$Instrument_Name)
        dataset2$Instrument_Name[is.na(dataset2$Instrument_Name)] <- "x1"
        
        
        dataset2
}
        