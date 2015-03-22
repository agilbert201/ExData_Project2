## Exploratory Data Analysis Project 2
## Plot 6
## Answer the question:
##  Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources 
##  in Los Angeles County, California (fips == 06037). Which city has seen greater changes over time in motor 
##  vehicle emissions?

## Parent data set is assumed to be in "data" subdir

require(dplyr)
require(ggplot2)
require(scales)

## Read in datasets
NEI <- readRDS(file.path("data", "summarySCC_PM25.rds"))
SCC <- readRDS(file.path("data", "Source_Classification_Code.rds"))

## NOTE - On how data is selected
## For purposes of this graph I have relied on the EI.Sector groups supplied by the EPA.
## Please see http://www.epa.gov/ttn/chief/net/2008neiv3/2008_neiv3_tsd_draft.pdf for more information.
## Section 2.1, Table 3
