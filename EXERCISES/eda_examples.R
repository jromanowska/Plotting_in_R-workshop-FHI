#DESCRIPTION: Exemplary code with explorative data analysis
#AUTHOR: Julia Romanowska
#DATE CREATED: 2022-03-31
#DATE UPDATED: 2022-10-16

# SETUP -----
# NOTE: if you don't have these packages installed, run first in the console:
#   install.packages(c("here", "readr", "skimr", "DataExplorer", "dataReporter"))
library(readr)
library(skimr)
library(here)
library(dataReporter)
library(DataExplorer)

# READ DATA -----
# NOTE: to read data from STATA, SAS, or other proprietary statistical software,
#       check functions in {haven} R package

# didn't work:
consult_orig <- read_csv(
	here("DATA", "Konsultasjoner.csv")
)
consult_orig

# trying with TAB-delimited format (\t)
consult_orig <- read_delim(
	here("DATA", "Konsultasjoner.csv"),
	delim = "\t"
)
consult_orig #BETTER!
# why are the numbers read in as characters? try checking entire dataset
# THIS DATA SHOULD BE CLEANED!
consult_tidy <- read_delim(
	here("DATA", "Consultations_tidy_2021-09-03.txt"),
	delim = "\t"
)
consult_tidy

# SUMMARISE ----
skim(consult_tidy)

# REPORT ----
# from DataExplorer:
create_report(consult_tidy)

# from dataReporter:
makeDataReport(consult_tidy)

