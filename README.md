Failure Project<br>
Cameron Ferguson<br>
2/25/15<br>
---
#Script Summary
<br>
This script takes a raw .tab file (exported from filemaker), reads the data into R, performs several analyses, and returns an excel file.<br>
To see information on the raw file, the type of analysese, or the excel file, check out their respective sections in this readme.<br>
<br>
---
#How To Run
<br>
This assumes you have already exported the data correctly. If you have yet to export the data, please pause here, and check out the <b>export</b> section before continuing.

The excel file currently has the following sheets, each of which represents a slightly different analysis <br>
1) <b>summary</b>: contains summary info the analyses. <br>
2) <b>Top Failure Reasons</b>: contains a table of the failure reasons and the number of times each occurs<br>
3) <b>Top 2 percent of SeqID failures </b>: contains a table with each sequence ID, their respective mods, and their failure rate, for the top 2 percent of failure rate.<br>
4) <b>Both Mod Failure Rate</b>: contains a table with mod pairs and their failure rate<br>
5) <b>
<br>
Data source is the filemaker export data, process described in CodeBook

