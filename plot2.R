## Exploratory Data Analysis Project 2
## Plot 2
## Answer the question:
##  Have total emissions from PM2.5 decreased in the Baltimore City, Maryland (fips == 24510) from 1999 to 2008?
##  Use the base plotting system to make a plot answering this question.

## Parent data set is assumed to be in "data" subdir

require(dplyr)

## Read in datasets
NEI <- readRDS(file.path("data", "summarySCC_PM25.rds"))
SCC <- readRDS(file.path("data", "Source_Classification_Code.rds"))

## NOTE there is only one pollutant in the data set, PM25-PRI
## to prove this one can run 'distinct(select(NEI, Pollutant))'

## Filter to Baltimore MD
baltimore_only <- filter(NEI, fips == "24510")

## Group by year and summarise total emissions
by_year <- group_by(baltimore_only, year)
emissions_by_year <- summarise(by_year, totalpm25 = sum(Emissions))

## Create Bar Chart with Total PM25 By Year
png(file = "plot2.png", bg = "white")
barplot(emissions_by_year$totalpm25, names = emissions_by_year$year, main = "Total By Year (Baltimore Only)",
        xlab="Year", ylab=expression("Total " * PM[2.5]), col=c("blue"), yaxt="n")
my.axis <-paste(axTicks(2) / 1000,"K",sep=" ")
axis(2,at=axTicks(2), labels=my.axis)
dev.off();
