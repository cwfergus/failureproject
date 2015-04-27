#Character Clean up function
#This function is used to clean up the raw data to enable easy manipulation
note_clean_up <- function(dataset){
        #converts failure reasons to lower case
        dataset$Failure_Reason <- tolower(dataset$Failure_Reason)
        #turns accidental double spaces into single spaces
        dataset$Failure_Reason <- gsub("  ", " ", dataset$Failure_Reason)
        #removes any extra space at the beginning or end of notes
        dataset$Failure_Reason <- str_trim(dataset$Failure_Reason)
        dataset
}

#None Failure removal
#Intended to remove most sequences that did not actually failed by have notes in their
#failure Reason section.
not_failed <- function(dataset){
        #changes any notes with the letters "see" to NA
        dataset$Failure_Reason <- gsub("ms n", NA, dataset$Failure_Reason)
        #changes any notes that are NA to "Ms NOT Okay"
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Ms NOT Okay"
        #etc #etc #etc
        dataset$Failure_Reason <- gsub("ms o", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Ms Okay"
        
        dataset$Failure_Reason <- gsub("assig", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Reassigned"
        
        dataset$Failure_Reason <- gsub("yield", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("yeild", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("no dn", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Low Yield"
        
        dataset$Failure_Reason <- gsub("see", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        
        dataset$Failure_Reason <- gsub("extra material", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("archive material", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("collection", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("stellaris o", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("pass", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("^wobble$", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("wobble o", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("wobbles o", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("recheck", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("relot", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("re-lot", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        
        dataset$Failure_Reason <- gsub("comb", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "REMOVED"
        #removes any that have NA for the failure reason.
        dataset
}
 # this function is used to remove specific failure reasons from the data
reason_remover <- function(dataframe, reason) {
        dataframe$Failure_Reason <- gsub(reason, NA, dataframe$Failure_Reason)
        filter(dataframe, !is.na(Failure_Reason))
}

#Failure aggregation
#Used to attempt to provide common failure reason notes to divergent failure reason notes.
failure_aggregation <- function(dataset){
        # finds anything with the characters "ms n" and changes the note to NA
        dataset$Failure_Reason <- gsub("ms n", NA, dataset$Failure_Reason)
        #changes any notes that are NA to "Ms NOT Okay"
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Ms NOT Okay"
        #etc #etc #etc
        dataset$Failure_Reason <- gsub("ms o", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Ms Okay"
        
        dataset$Failure_Reason <- gsub("assig", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Reassigned"
        
        dataset$Failure_Reason <- gsub("base", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Base-swap"
        
        dataset$Failure_Reason <- gsub("wrong m", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Wrong Mass"
        
        dataset$Failure_Reason <- gsub("flush", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Flushed"
        
        dataset$Failure_Reason <- gsub("3 stel", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("every sample", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("all samples failed", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("stellaris f", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("more then three", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("more than 3", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Stellaris failures"
        
        dataset$Failure_Reason <- gsub("extra tet", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Extra TET coupled"
        
        dataset$Failure_Reason <- gsub("bhq3", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("bhq-3", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor BHQ3 coupling"
        
        dataset$Failure_Reason <- gsub("bhq2", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("bhq-2", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor BHQ2 coupling"
        
        dataset$Failure_Reason <- gsub("bhq1", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("bhq-1", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor BHQ1 coupling"
        
        dataset$Failure_Reason <- gsub("tet", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor TET"
        
        dataset$Failure_Reason <- gsub("extra fam", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Extra FAM coupled"
        
        dataset$Failure_Reason <- gsub("fam", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor FAM"
        
        dataset$Failure_Reason <- gsub("biotin", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor Biotin Coupling"
        
        dataset$Failure_Reason <- gsub("contamin", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Contamination"
        
        dataset$Failure_Reason <- gsub("fluor", "Poor Fluorescense", dataset$Failure_Reason)
        
        dataset$Failure_Reason <- gsub("impurity", "ImPurity", dataset$Failure_Reason)
        
        dataset$Failure_Reason <- gsub("purity", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor Purity"
        
        dataset$Failure_Reason <- gsub("n-", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "N- failure"
        
        dataset$Failure_Reason <- gsub("syn", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Synthesis Failure"
        
        dataset$Failure_Reason <- gsub("colum", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Column Issue"
        
        dataset$Failure_Reason <- gsub("flp", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("no pro", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "No FLP"
        
        dataset$Failure_Reason <- gsub("dmt", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "DMT left on"
        

        
        dataset$Failure_Reason <- gsub("depur", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Depurination"
        
        dataset$Failure_Reason <- gsub("mmt", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "MMT left on"
        
        dataset$Failure_Reason <- gsub("phosp", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor Phosphate Coupling"
        
        dataset$Failure_Reason <- gsub("poor j", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Poor Joe coupling"
        
        dataset$Failure_Reason <- gsub("incom", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("acetyl", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("benz", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("cyano", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("deprot", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Incomplete Deprotection"
        
        dataset$Failure_Reason <- gsub("dye", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Dye failure"
        
        dataset$Failure_Reason <- gsub("scram", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Plate Scrambled"
        
        dataset$Failure_Reason <- gsub("yield", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("yeild", NA, dataset$Failure_Reason)
        dataset$Failure_Reason <- gsub("no dn", NA, dataset$Failure_Reason)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Low Yield"
        

        dataset$Failure_Reason <- gsub("-1", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-2", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-3", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-4", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-5", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-6", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-7", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-8", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("-9", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+1", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+2", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+3", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+4", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+5", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+6", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason  <- gsub("+7", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+8", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason <- gsub("+9", NA, dataset$Failure_Reason, fixed=TRUE)
        dataset$Failure_Reason[is.na(dataset$Failure_Reason)] <- "Impurity Present"
        dataset
        
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
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM_12"
        dataset$Instrument_Name <- gsub("SAM 11", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM_11"
        dataset$Instrument_Name <- gsub("SAM 10", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "SAM_10"
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

inst_name_adjust <- function(dataset){
        dataset$Instrument_Name <- gsub("H6", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "h6"
        
        dataset$Instrument_Name <- gsub("MM192", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm192"
        dataset$Instrument_Name <- gsub("MM12", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm12"
        dataset$Instrument_Name <- gsub("MM11", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm11"
        dataset$Instrument_Name <- gsub("MM10", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm10"
        dataset$Instrument_Name <- gsub("MM9", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm9"
        dataset$Instrument_Name <- gsub("MM8", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm8"
        dataset$Instrument_Name <- gsub("MM7", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm7"
        dataset$Instrument_Name <- gsub("MM6", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm6"
        dataset$Instrument_Name <- gsub("MM5", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM5"
        dataset$Instrument_Name <- gsub("MM4", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm4"
        dataset$Instrument_Name <- gsub("MM3", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM3"
        dataset$Instrument_Name <- gsub("MM2", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM2"
        dataset$Instrument_Name <- gsub("MM1", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "mm1"
        
        dataset$Instrument_Name <- gsub("MGM12", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM12"
        dataset$Instrument_Name <- gsub("MGM11", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM11"
        dataset$Instrument_Name <- gsub("MGM10", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM10"
        dataset$Instrument_Name <- gsub("MGM9", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM9"
        dataset$Instrument_Name <- gsub("MGM8", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM8"
        dataset$Instrument_Name <- gsub("MGM7", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM7"
        dataset$Instrument_Name <- gsub("MGM6", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM6"
        dataset$Instrument_Name <- gsub("MGM5", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM5"
        dataset$Instrument_Name <- gsub("MGM4", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM4"
        dataset$Instrument_Name <- gsub("MGM3", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM3"
        dataset$Instrument_Name <- gsub("MGM2", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM2"
        dataset$Instrument_Name <- gsub("MGM1", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "MGM1"
        
        
        dataset$Instrument_Name <- gsub("X14", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x14"
        dataset$Instrument_Name <- gsub("X13", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x13"
        dataset$Instrument_Name <- gsub("X12", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x12"
        dataset$Instrument_Name <- gsub("X11", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x11"
        dataset$Instrument_Name <- gsub("X10", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x10"
        dataset$Instrument_Name <- gsub("X9", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x9"
        dataset$Instrument_Name <- gsub("X8", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x8"
        dataset$Instrument_Name <- gsub("X7", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x7"
        dataset$Instrument_Name <- gsub("X6", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x6"
        dataset$Instrument_Name <- gsub("X5", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x5"
        dataset$Instrument_Name <- gsub("X4", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x4"
        dataset$Instrument_Name <- gsub("X3", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x3"
        dataset$Instrument_Name <- gsub("X2", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x2"
        dataset$Instrument_Name <- gsub("X1", NA, dataset$Instrument_Name)
        dataset$Instrument_Name[is.na(dataset$Instrument_Name)] <- "x1"
        
        
        dataset
}
        