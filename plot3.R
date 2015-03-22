## Exploratory Data Analysis Project 2
## Plot 3
## Answer the question:
##   Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
##   which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
##   Which have seen increases in emissions from 1999–2008? Use the ggplot2 plotting system to make a 
##   plot answer this question.

## Parent data set is assumed to be in "data" subdir

require(dplyr)
require(ggplot2)

## Read in datasets
NEI <- readRDS(file.path("data", "summarySCC_PM25.rds"))
SCC <- readRDS(file.path("data", "Source_Classification_Code.rds"))

## NOTE there is only one pollutant in the data set, PM25-PRI
## to prove this one can run 'distinct(select(NEI, Pollutant))'

## Filter to Baltimore MD
baltimore_only <- filter(NEI, fips == "24510")

## Group by year and summarise each type
by_year_and_type <- group_by(baltimore_only, year, type)
year_and_type_sums <- summarise(by_year_and_type, total = sum(Emissions))
distinct_years <- distinct(select(year_and_type_sums))

## Show each source contribution to annual total
png(file = "plot3.png", bg = "white", width = 600)
p <- ggplot(year_and_type_sums, aes(x=year, y=total, group=type, color=type))
p + geom_line() +
    labs(title = "Totals By Source Type (Baltimore)", x = "Year", y = expression("Total " * PM[2.5])) +
    guides(color = guide_legend("Type")) +
    scale_x_continuous(breaks=distinct_years$year)
dev.off()
