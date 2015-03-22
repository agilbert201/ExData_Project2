## Exploratory Data Analysis Project 2
## Plot 5
## Answer the question:
##  How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

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
## to motor vehicles. Then join to Balitimore subset of NEI to get all data rows that match.

only_vehicles <- filter(SCC, grepl("(?=^Mobile)(?=.*Vehicles)", EI.Sector, perl = TRUE))
only_vehicles_s <- select(only_vehicles, SCC, Short.Name, EI.Sector)
only_vehicles_j <- mutate(only_vehicles_s, SCC = as.character(SCC))

## Filter to Baltimore MD
baltimore_only <- filter(NEI, fips == "24510")

## Do the join
baltimore_vehicle_data <- inner_join(baltimore_only, only_vehicles_j, by=c('SCC'))

## Group and Summarise
by_year_and_sector <- group_by(baltimore_vehicle_data, year, EI.Sector)
year_and_sector_sums <- summarise(by_year_and_sector, total = sum(Emissions))
distinct_years <- distinct(select(year_and_sector_sums))

label_map = c("Mobile - On-Road Diesel Heavy Duty Vehicles" = "Diesel Heavy",
              "Mobile - On-Road Diesel Light Duty Vehicles" = "Diesel Light",
              "Mobile - On-Road Gasoline Heavy Duty Vehicles" = "Gasoline Heavy",
              "Mobile - On-Road Gasoline Light Duty Vehicles" = "Gasoline Light")
png(file = "plot5.png", bg = "white", width=600)
p <- ggplot(year_and_sector_sums, aes(x=year, y=total, group=EI.Sector, color=EI.Sector))
p + geom_line() +
    labs(title = "Motor Vehicle Emission Trends (Baltimore)", x = "Year", y = expression("Total " * PM[2.5])) +
    guides(color = guide_legend("Sector")) +
    scale_color_discrete(labels = label_map) +
    scale_x_continuous(breaks=distinct_years$year)
dev.off()
