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

## Group and Summarise
by_year_and_sector <- group_by(coal_comb_data, year, EI.Sector)
year_and_sector_sums <- summarise(by_year_and_sector, total = sum(Emissions))
distinct_years <- distinct(select(year_and_sector_sums))

png(file = "plot4.png", bg = "white", width = 800)
p1 <- ggplot(year_and_sector_sums, aes(x = year, y = total, fill = EI.Sector))
p1 <- p1 + geom_bar(stat = "identity")
p1 <- p1 + labs(title = "Total Combustible Coal Emissions (US)", x = "Year", y = expression("Total " * PM[2.5]))
p1 <- p1 + scale_y_continuous(labels = comma)
p1 <- p1 + scale_x_continuous(breaks = year_and_sector_sums$year)
p1 <- p1 + guides(fill = guide_legend("Sector"))
p1
dev.off()

