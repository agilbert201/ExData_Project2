## Exploratory Data Analysis Project 2
## Plot 4
## Answer the question:
##   Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?

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

## An inner_join in dplyr will only return matched rows. So we can subset SCC by EI.Sectors that match
## to "comb" and "coal". Then join to NEI to get all data rows that match.

## Filter SCC by EI.Sector's with Comb and Coal (i.e. combustion related Coal emissions)
only_coal <- filter(SCC, grepl("(?=.*Comb)(?=.*Coal)", EI.Sector, perl = TRUE))
## tide up only_coal to make join better
only_coal_s <- select(only_coal, SCC, Short.Name, EI.Sector)
only_coal_j <- mutate(only_coal_s, SCC = as.character(SCC))

## Do the join
coal_comb_data <- inner_join(NEI, only_coal_j, by=c('SCC'))

## Show each source contribution to annual total
png(file = "plot4.png", bg = "white")
p <- ggplot(sum_coal_comb_data_by_year, aes(x = year, y = total, fill = year))
            
p + geom_bar(stat = "identity") +
    labs(title = "Total Combustible Coal Emmissions (US)", x = "Year", y = expression("Total " * PM[2.5])) +
    guides(fill = guide_legend(title = "Year", override.aes = c("1", "2", "3", "4"))) +
    scale_fill_continuous(breaks = sum_coal_comb_data_by_year$year) +
    scale_y_continuous(labels = comma) +
    scale_x_continuous(breaks = sum_coal_comb_data_by_year$year)
    #scale_x_continuous(breaks=distinct_years$year)
dev.off()

