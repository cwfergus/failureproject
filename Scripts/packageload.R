#Loads Required packages for the Failure Data Script
if (require(dplyr)==FALSE){
        install.packages("dplyr")
        library(dplyr)
} else {
        library(dplyr)
}
if (require(xlsx)==FALSE){
        install.packages("xlsx")
        library(xlsx)
} else {
        library(xlsx)
}
if (require(stringr)==FALSE) {
        install.packages("stringr")
        library(stringr)
} else {
        library(stringr)
}
if (require(zoo)==FALSE) {
        install.packages("zoo")
        library(zoo)
} else {
        library(zoo)
}
if (require(ggplot2)==FALSE) {
        install.packages("ggplot2")
        library(ggplot2)
} else {
        library(ggplot2)
}
if (require(scales)==FALSE) {
        install.packages("scales")
        library(scales)
} else {
        library(scales)
}