Failure List
Cameron Ferguson
last updated: 4/15/15
Version: 0.1.7.0
-------------------------------------------------------------------------------------
Most Recent UPDATE:
Added a graphing to the Instrument Analysis. A new script provides a pdf file that shows failure rate for each machine split out by machine class, all over time. Which is why Synthesis Start Date must now be included as an export field.

-------------------------------------------------------------------------------------
Script Summary

This collection of scripts take a raw .tab file (exported from filemaker), reads the data into R, performs several analyses, and returns the requested excel files

To see information on the raw file, the script layouts, or the excel files, check out their respective sections in this readme.

For information into the actual raw data, the different precursor files, the assumptions made in analysis, and the final data see the Codebook

------------------------------------------------------------------------------------------
How To Run

This assumes you have already exported the data correctly. If you have yet to export the data, please pause here, and check out the raw file section before continuing.

1) Set your working directory to the location of the scripts/raw data
	a) To do this write setwd("script location path") or use file>Change dir...
		- script location path example: setwd("C:/Users/cferguson/Desktop/Failure_List")
	b) If you have not typed in the path correctly you will get an error. If you have changed to an incorrect directory you won't get an error till the next step

2) Source the failuredata.R script with the following command:
	source('failuredata.R')

3) Enter the data file name. If it is not in the same folder as the script, you must put a path. You can add the extension or not.
	ex) If your data (lastyear.tab) is saved in a folder (called data) that is within the same folder as the script your filename would be: data/lastyear
	ex) If the data is just saved in the same folder your filename would be: lastyear

4) Enter the name you want the output file to be called. 
	If you want it saved in a different folder, make it a path.
	ex) Saved in the same folder as the script: lastyearanalysis
	ex) Saved in the data folder, where the input file is: data/lastyearanalysis

5) Specify which analysis you want, by typing the number corresponding to your choice and hitting enter. You will always be given the Summary page.

5) Wait a maximum of 2 min. If the file/s has not appeared at the chosen location, and no errors have appeared, something is wrong!	

6) Open the excel file/s and enjoy the data! 

--------------------------------------------------------------------------------------
Raw File

The Raw File is the data file that you will feed into R in order to get the excel file. It is exported from Filemaker, and has the extension .tab. You must either remember the location of the Raw File or save it to the same location as the R script in order for the script to work.

To generate the Raw File
	1) Search however you want.
	2) Go to the Custom Oligo Tracking details view
	3) Hit File>Export Records...
	4) Save the data in the same folder as the script, or at least remember where you put it. You must also remember the name you choose.
	5)Select the following Fields from the box on the left, and MOVE them to the box on the right.
                a)Synthesis Instrument
                b)Synthesis Deck Position
                c)Sequence Set ID
                d)Synthesis Start Date
	6)Using the drop down field in the top left, change to related tables: Sets SSID Track
	7) Select the following Fields from the box on the left, and move them to the box on the right.          
                a)Sets SSID Track::Sequence ID
        	b)Sets SSID Track::Sequence Name
                c)Sets SSID Track::Sequence
		d)Sets SSID Track::Five Mod
		e)Sets SSID Track::Three Mod
                f)Sets SSID Track::Notes
	8) Reorder the fields on the right to the following order
		a)Sets SSID Track::Sequence ID
		b)Sets SSID Track::Sequence Name
                c)Sets SSID Track::Sequence
		d)Sets SSID Track::Five Mod
		e)Sets SSID Track::Three Mod
                f)Sets SSID Track::Notes
                g)Synthesis Instrument
                h)Synthesis Dec Position
                i)Sequence Set ID
                j)Synthesis Start Date
	9) Hit export
	10) Wait for filemaker to export the data. This can take up to 10 minuites!

Once filemaker has finished, you now have the raw data! Hopefully you saved this in the same folder as the script.If not I suggest you move it.If you really don't want to move it, then you need to know the file path, and you will have to enter it for the filename.

It is also possible to open this raw file in notebook. You shouldn't need to do this, but it must be nice to know you can!


----------------------------------------------------------------------------------------
Script Layouts

failurelist.R

1) The script begins by checking if the user has the required R packages, and installs them if they do not (packageload.R)

2) Next it sources some custom functions used in this script, from failurelistfunctions.R

3) Next it asks for the user to input the filename and the output name, and adds extentions to each. 

4) Next it prints out a table of options, asking the user what analysis they want

5) Now it reads in the raw data and adds column names.

6) Now the raw data is cleaned up, changing everything to Upper Case, filling down missing Instruments, Locations, and SSIDs.

7) Next it adds another column, by simply duplicating the notes field and calling it Originalnote

8) Now all sequences that do not have anything in the notes section are removed. This is assumed to remove all sequences that passed.

9) Next it that through the clean_up function, which removes extra space and converts failure reasons to lover case.

10) It runs that file through the not_failed function, which changed specific notes to REMOVED.
	-except Reassign and Ms Okay

11) Then that file is passed to the failure_aggregation function, which attempts to assign common failure notes to the sequences

12) Now the Removed notes are removed

13) Now the Reassign and then the Ms Okay notes are removed. These are both removed seperatly to enable counting, and use of Ms Okay in instrument a.

14) The clean_failure file now should contain only failures, and a large number of the failure reasons should be similar.

15) Now the Summary script is run

16) Now depending on the user's choice at the beginning, one or multiple Analysis scripts are run.

17) A final message tells the user the script is Finished

18) Finally it removes everything from memory (NOTE: I have commented this line, to enable editors to see all stages of data generation. But the final version will do this)

----
packageload.R

This script checks to see if certain packages required by this collection of scripts are installed by the User, installs them if they are not, and then loads the packages. It users a series of if required statements to download/load the packages. 

Currently 4 packages are required:
dplyr: Used to counts, group, and arrange data
xlsx : Used to write out excel files
stringr: Used to manipulate character strings to different cases, remove spaces, etc
zoo: Used to fill down items in a table.

----
failurelistfunctions.R

The failurelistfunctions.R script is a collection of custom functions, used within individual analyses.

clean_up: This functions converts all notes to lower case, converts any double spaces to a single space, and trims any extra space around notes.This is necessary to enable easy data manipulation

not_failed: This function changes specific notes to REMOVED to enable easy removal of specific sequences. The phrases have been chosen to represent notes that are frequently added but don't actually represent a failure.If new notes are found that don't represent failures another line can be easily added using copy and paste.It is assumed that the end result of this function is a file that does not contain any NON failures (except ms okay and Reassign). The function now also changes a few notes (ms okay, ms not okay, reassign) to their collected note (see failure_aggregation for details).
                	ex non-failures) recombine, wobble okay, or stellaris okay

reason_remover: This function removes specific reasons from the data. This can be used to enable singular removal of reasons, and is used in the failurelist.R script to remove Removed, Reassign, and Ms Okay notes seperately.

failure_aggregation: This function attempts to change divergent failure note for identical failures into identical notes for identical failuresIt is mostly necessary due to inconsistant failure naming, as well as occasional misspellings. Once again it is very easy to add another failure note, or failure note variation using copy and paste

test_write_out: This function is used for the testing of the data and is never naturally called in any of the scripts. Instead it is used as a diagnostic function, to enable testers to view precursors to the final data file. To run it, simply type in the R console:

write_outtest(variablename= (the precursor dataframe you want to export), outputname= (the name you want it saved as with .csv))
	
	ex) write_outtest(clean_failure, clean_failuretest.csv)

inst_raw_clean: This function does a similar job to clean_up, but on the Instrument Name field, removing certain characters and renaming others.

inst_name_adjust: This function does a similar job to failure_aggregation, but on the Instrument Name field.

----
Summary.R

The summary.R script is used to create a summary sheet, which provides basic information about the raw data analyzed, and the end results.It basically counts the numbers of rows (ie number of sequences) in precursor files. Then it creates a data frame of those numbers, using the summary function, and writes that data frame to the excel file.

----
failurereason_Analyze.R

This script begins by grouping the clean_failure data frame by Failure_Reason, couting the number of failures in each group, and reporting the failure reason and the number of occurances. This table is then written out. 

----
mod_Analyze.R

This script creates a few sheets, that show the failure rate per mod combination, per five prime mod, and per three prime mod. It works pretty similarly to the seqID_Analyze.R script, and each analysis within it is near identical.

It generates the list of all unique mod combinations, and a list of all mod combinations that failed. It merges those lists, retaining combinations that NEVER failed. Finally it calulates the failure rate, orders if by failure rate, and removes any that equal 1.

This is done for the combinations, for the five prime mod, and for the three prime mod. Each of these generates a data frame with mods and failure rates. Each of these data frames are written to the excel file.

----
seqID_Analyze.R

This script creates a sheet that shows the failure rate of specific sequence ID's and their respective modifications.

First it generates a list of all the unique sequence ID's and the number of times they each occur (ie were made) in the raw data

Next if generates a list of all the sequence ID's which failed, and the number of times they failed.

Then it makes a list of the modifications for each of the failed Sequence IDs

Next it merges the list of unique sequence ID and their occurance with the list of sequence IDs and the number of times they failed.

Next it merges in the mods of each sequence ID

Then it calculates the failure rate for each sequence ID, rearranges the columns to make more sense, and filters out any sequences with a failure rate of 1. (we believe this occurs due to "wobble" note problem, and random notes that are actually passes which escape not_failed)

Next it grabs the top 2 percent of failure rates

Finally it reads this into the excel file.

----
seqName_Analyze.R

This script works almost exactly the same as the seqID_Analyze.R script, except with Sequence Name being the grouping/counting factor. 


----
sequence_Analyze.R

Once again, it works almost exactly the same as the seqID_Analyze.R script

----
instrument_Analyze.R

This script is s does a similar analysis to the failurereason_Analyze.R script, but using the Instrument field as a result. However it also counts the number of times a machine was used as well.

It first generates a table showing the Failure Rate for each instrument, similar to the SeqID Analysis.

Next it generates a table showing the Failure Rate for each instrument, and for super sams, each position. To do this the locations for every other machine is deleted using a loop on a vector full of row numbers corresponding to non-super sam instruments. 

The third table it makes is just a list of instruments and their failure reasons.

Next is the most complicated analysis so far:
1) It makes a grouped/counted table of the instrument using adjusted names, grouped via Instrument name, Failure Reason, and SSID: SSIDinst
	This table has a column where the Instrument name and Failure reason and combined and seperated by a " "
2) It makes an empty final data table, with two columns Instrument_and_Reason and Failed_Sequence_Sets.
3) Now it takes the third final table (inst_failure_info) and merges the instrument name and failure reason columns, and makes a Picker table
4) Nower it makes a pick_list, taking just the now merged column. 
5) Now a for loop, running through every value in the pick list it:
	a) finds the column number
	b) finds the spot that that instrument/failure reason is in the SSIDinst table
	c) using the spots, it grabs the sequence sets corresponding to those instruments/failure reasons
	d) it then combines all the sequence sets into one character string, with a " " seperating each
	e) Finally it appends the sequence sets and the 'pick' (the intrument name/ reason combined column)
	f) Now it slots this into the empty final data table
6) Next the counted fields are added to give a number failed per instrument per failure

Now all of these tables are written out as a single xlsx file.

----
instrument_graphing.R

Generates a pdf file with several plots, all depicting failure rate over time by machine, broken down by machine class.

The script begins by converting fields to dates and factors ...

ILL FINISH THIS SECTION LATER.

--------------------------------------------------------------------------------------------------------
Final File(s)
	
The final file or files that are written out depends on the Users choice at the beginning. They can choose to either run every analysis on the data or just one. If they choose everything then a collection of xlsx and csv files will be written out depending on wether the analysis included multiple tabs or not. The one that is just their choosen name is a summary document, the others will all contain a _analysisname tag.

If the user chooses to run a specific analysis the final file will contain a summary tab, made using summary.R and the analysis tab/s. 

Excel files can be easily manipulated/sorted and played with. Also a large number of people know how to work with them. This is why excel files were choosen as the final format. 

-----------------------------------------------------------------
UPDATES

0.1.6.6
Made several internal changes to the way the script works, just to clean it up and make it easier to read. Names of functions, variables, and columns were changed. Some of the processes were shorterened, as I had missed obvious things in my rush to complete the Instrument Analysis.

0.1.6.5
Added a Sequence Set analysis view for the Instrument Analysis, showing the sequence sets that have failed on a given instrument. Be aware of the new export order/fields in 0.1.6

0.1.6.4
Added a new user input, allowing the User to specify what analysese they want, so that it doesn't just give all the excel files every time. If you choose all analysese you get all of them as seperate files, if you choose a specific one, you get the summary page and then your choosen analysis

0.1.6.1
Made adjustments to the Instrument Analysis script, to better group instruments

0.1.6.0
Made some major adjustments in the last few weeks, none which were added to read me so here goes...
Biggest change: NEW EXPORT ORDER. See RAW file, export section for details. Added an instrument analysis script/file. this is still a major work in progress, and will be the head of changes. I also cleaned up the main script, moving package loading to its own script, removed the Failure Reason analysis part to its own script for consistancy, added some new clean up functions for the failuredatafunctions script, for the instrument analysis. I also added a RAW export, that contains the original note and the changed note or the word removed, to enable people to easily check my work.

0.1.5.0
Added a Sequence Analysis document, as the seqName was not as unique as I thought: Its customer choice! Which means it can be duplicated or redone or copied. Moved all but main script to their own folder, and changed name of main script. This just makes the directory cleaner and easier for end user work. 

0.1.4.0
Added Sequence Information to the SeqName and SeqID files. REQUIRES NEW EXPORT. Also changed wording on a few thing: output save for SeqName and SeqID is now outputname_SeqName, changed summary script for more accurate description of numbers. 

0.1.3.2
Killed package install bug, updated README, updated script to be chatty, updated filename input to be less suscipable to user input error, clarified output file readline

0.1.3.1
Changed the order of the individual analyze scripts, to more accuratly represent usage. Mod now comes first. And updated README

0.1.3.0
Added a Data Size option to menu, and dramatically increased performance using write.csv instead of write.xlsx for LARGE data sets. This does however cause multiple final files to be made.

0.1.2.0
Export items and order is different, in order to make a more logical export order, and
enable the new seqName sheet. See Raw File section, exporting step 11