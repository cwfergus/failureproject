x <- grep("-1", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE)
x <- append(x, grep("-2", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("-3", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("-4", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("-5", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("-6", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("-7", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("-8", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("-9", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+1", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+2", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+3", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+4", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+5", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+6", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+7", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+8", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))
x <- append(x, grep("+9", clean_failure_reassign_msokay$Failure_Reason, fixed=TRUE))

test <- clean_failure_reassign_msokay[x,]



test$Failure_Reason <- gsub("wrong mass", "", test$Failure_Reason)
test$Failure_Reason <- gsub("ts", "", test$Failure_Reason)
test$Failure_Reason <- gsub(":", "", test$Failure_Reason)
test$Failure_Reason <- gsub("(", "", test$Failure_Reason, fixed=TRUE)
test$Failure_Reason <- gsub(")", "", test$Failure_Reason, fixed=TRUE)
test$Failure_Reason <- gsub("adduc", "", test$Failure_Reason, fixed=TRUE)
test$Failure_Reason <- gsub("ImPurity", "", test$Failure_Reason, fixed=TRUE)

test$Failure_Reason <- str_trim(test$Failure_Reason)


Impurity_info <-
        test %>% #data to pull from
        group_by(Failure_Reason, Five_Prime_mod, Three_Prime_mod) %>% #group by seqID, 5'mod, 3'
        summarise_each(funs(n())) %>% #collapse the data by seqID, so no duplicates
        select(Failure_Reason, Five_Prime_mod, Three_Prime_mod, Sequence)

class(Impurity_info) <- "data.frame"

write.csv(Impurity_info,
          file="Impurity_infotest.csv",
          row.names=FALSE,
          na = "")