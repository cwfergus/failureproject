#Instrument Graphing

##### Data Generation ####

clean_failure_msokay$Synthesis_Date <- as.Date(clean_failure_msokay$Synthesis_Date, format = "%m/%d/%Y")
clean_raw$Synthesis_Date <- as.Date(clean_raw$Synthesis_Date, format = "%m/%d/%Y")

inst_synDate_count <-
        clean_raw %>%
        group_by(Instrument_Name, Synthesis_Date) %>%
        summarize(Sequences_Made = n()) 

fail_inst_synDate_count <- 
        clean_failure_msokay %>%
        group_by(Instrument_Name, Synthesis_Date) %>%
        summarize(Sequences_Failed = n())
inst_synDate_count$Instrument_Name <- as.factor(inst_synDate_count$Instrument_Name)
fail_inst_synDate_count$Instrument_Name <- as.factor(fail_inst_synDate_count$Instrument_Name)

all_inst_synDate_counts <- merge(inst_synDate_count, fail_inst_synDate_count, all.x = TRUE)
all_inst_synDate_counts$Sequences_Failed[is.na(all_inst_synDate_counts$Sequences_Failed)] <- 0

inst_Date_final <-
        all_inst_synDate_counts %>%
        mutate(Failure_Rate = Sequences_Failed/Sequences_Made*100)


##### Every Machine Dashboard Plotting ####

# 
# plotbase <- ggplot(inst_Date_final, aes(Synthesis_Date, Failure_Rate, label=Sequences_Made))
# 
# plotbase + 
#         geom_point(aes(color=Instrument_Name)) + 
#         facet_wrap(~Instrument_Name) + 
#         stat_smooth(method="loess", se=FALSE, aes(color=Instrument_Name)) + 
#         geom_text(vjust=-2, size=2)

##### Select by Instrument list, divide by instrument class Dashboard Plotting ####

read.table('Internaldata/instrumentlist.tab', sep="\t", header=TRUE) -> instrumentlist

as.character(instrumentlist[,1]) -> instrumentlistvector

inst_Date_final[inst_Date_final$Instrument_Name %in% instrumentlistvector,] -> selectinst

merge(selectinst, instrumentlist) -> merged

split(merged, merged$Instrument_Class) -> split

levels(merged$Instrument_Class) -> list

outputnamepdf <- paste(outputname, "_instrumentplots.pdf", sep="")
pdf(file=outputnamepdf)
for (i in 1:length(split)) {
        data_frame <- as.data.frame(split[i])
        colnames(data_frame) <- c("Instrument_Name",
                                   "Synthesis_Date",
                                   "Sequences_Made",
                                   "Sequences_Failed",
                                   "Failure_Rate",
                                   "Instrument_Class")
        plotbase <- ggplot(data_frame, aes(Synthesis_Date, Failure_Rate, label=Sequences_Made))
        plotname <- list[i]
        plotoutname <- paste( plotname, ".pdf", sep ="")
        titlename <- paste(plotname, "Failure Rate over time", sep = " ")
        plot<-plotbase + 
                geom_point(aes(color=Instrument_Name)) +
                facet_wrap(~Instrument_Name) +
                geom_text(vjust=-0.5 , size=2) + 
                coord_cartesian(ylim=-5:110) + 
                geom_line(aes(color=Instrument_Name)) + 
                scale_x_date(labels=date_format("%m/%d")) + 
                labs(title=titlename, x = "Synthesis Start Date", y = "Failure Percentage")
        print(plot)
}
dev.off()
  
##### Year long instrument graphing, showing avg failure rate ####
# read.table('Internaldata/instrumentlist.tab', sep="\t", header=TRUE) -> instrumentlist
# 
# as.character(instrumentlist[,1]) -> instrumentlistvector
# 
# inst_Date_final[inst_Date_final$Instrument_Name %in% instrumentlistvector,] -> selectinst
# 
# merge(selectinst, instrumentlist) -> merged
# 
# split(merged, merged$Instrument_Name) -> split
# 
# levels(merged$Instrument_Name) -> list
# 
# outputnamepdf <- paste(outputname, "_instrumentplots.pdf", sep="")
# pdf(file=outputnamepdf)
# for (i in 1:length(split)) {
#         data_frame <- as.data.frame(split[i])
#         if (nrow(data_frame) > 0) {
#                 colnames(data_frame) <- c("Instrument_Name",
#                                           "Synthesis_Date",
#                                           "Sequences_Made",
#                                           "Sequences_Failed",
#                                           "Failure_Rate",
#                                           "Instrument_Class")
#                 plotbase <- ggplot(data_frame, aes(Synthesis_Date, Failure_Rate, label=Sequences_Made))
#                 plotname <- list[i]
#                 plotoutname <- paste( plotname, ".pdf", sep ="")
#                 titlename <- paste(plotname, "Failure Rate over time", sep = " ")
#                 plot<-plotbase + 
#                         geom_point(aes(color=Instrument_Name)) +
#                         facet_wrap(~Instrument_Name) +
#                         coord_cartesian(ylim=-5:110) + 
#                         stat_smooth(aes(color=Instrument_Name), method="lm") + 
#                         scale_x_date(breaks = date_breaks("months"), labels=date_format("%b")) + 
#                         labs(title=titlename, x = "Synthesis Start Date", y = "Failure Percentage")
#                 print(plot)
#         }
# }
# dev.off()

##### Select by Instrument List, Dashboard plotting ####        
# read.table('Internaldata/instrumentlist.tab', sep="\t", header=TRUE) -> instrumentlist
# 
# as.character(instrumentlist[,1]) -> instrumentlistvector
# 
# inst_Date_final[inst_Date_final$Instrument_Name %in% instrumentlistvector,] -> selectinst
# 
# plotbase <- ggplot(selectinst, aes(Synthesis_Date, Failure_Rate, label=Sequences_Made))
# plotbase + 
#         geom_point(aes(color=Instrument_Name)) +
#         facet_wrap(~Instrument_Name) +
#         geom_text(vjust=-0.5 , size=4) + 
#         coord_cartesian(ylim=-5:110) + 
#         geom_line(aes(color=Instrument_Name)) + 
#         scale_x_date(labels=date_format("%m/%d")) + 
#         labs(title="Failure Rate by Machine Over time", 
#              x = "Synthesis Start Date", 
#              y = "Failure Percentage")
# dev.off()

##### Select by number sequences made Dashboard Plotting ####
# instrument_list <-
#         inst_Date_final %>%
#         group_by(Instrument_Name) %>%
#         summarize(Sum_Seq_Made = sum(Sequences_Made)) %>%
#         filter(Sum_Seq_Made >= 10)
# 
# as.character(instrument_list$Instrument_Name) -> instrument_list
# 
# inst_Date_final[inst_Date_final$Instrument_Name %in% instrument_list,] -> select_inst
# 
# plotbase <- ggplot(select_inst, aes(Synthesis_Date, Failure_Rate, label=Sequences_Made))
# 
# plotbase +
#         geom_point(aes(color=Instrument_Name)) +
#         facet_wrap(~Instrument_Name) +
#         stat_smooth(method="loess", se=FALSE, aes(color=Instrument_Name)) +
#         geom_text(vjust=-2, size=3)

##### Mulitpage Plotting ####
# library(plyr)
# library(gridExtra)
# 
# p <- 
#         plotbase + 
#         geom_point(aes(color=Instrument_Name)) +
#         geom_smooth(method="loess", se=FALSE) + 
#         expand_limits(y=c(0,100)) + 
#         geom_text(vjust=2, size=4)
# plots <- dlply(inst_Date_final, "Instrument_Name", "%+%", e1 = p)
# ml = do.call(marrangeGrob, c(plot, list(nrow=1, ncol=1)))
# ggsave("multipage.pdf", ml)