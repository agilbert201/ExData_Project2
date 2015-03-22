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

## An inner_join in dplyr will only return matched rows. So we can subset SCC by EI.Sectors that match
## to motor vehicles.

only_vehicles <- filter(SCC, grepl("(?=^Mobile)(?=.*Vehicles)", EI.Sector, perl = TRUE))
only_vehicles_s <- select(only_vehicles, SCC, Short.Name, EI.Sector)
only_vehicles_j <- mutate(only_vehicles_s, SCC = as.character(SCC))

## Filter to Baltimore and LA
baltimore_and_la <- filter(NEI, fips == "24510" | fips == "06037")

## Do the join
baltimore_and_la_vehicle_data <- inner_join(baltimore_and_la, only_vehicles_j, by=c('SCC'))
## Note relying on 06037 sorting before 24510
with_city <- mutate(baltimore_and_la_vehicle_data, city = factor(fips, labels = c("LA", "Baltimore")))

## Group and Summarise
by_year_and_city <- group_by(with_city, year, city)
year_and_city_sums <- summarise(by_year_and_city, total = sum(Emissions))
distinct_years <- distinct(select(year_and_city_sums))

p <- ggplot(year_and_city_sums, aes(x=year, y=total, group=city, color=city))
p <- p + geom_line()
p <- p + labs(title = "Motor Vehicle Emission Trends (Baltimore vs LA)", x = "Year", y = expression("Total " * PM[2.5]))
p <- p + guides(color = guide_legend("City"))
p <- p + scale_x_continuous(breaks=distinct_years$year)

