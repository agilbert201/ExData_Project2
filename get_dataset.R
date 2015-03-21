##
## Support function to retrieve and unzip the data set
##

dataset.url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
dataset.zipfile <- file.path("data", "exdata-data-NEI_data.zip")
dataset.txtfileOne <- file.path("data", "summarySCC_PM25.rds")
#dataset.txtfileTwo <- file.path("data", "Source_Classification_Code.rds")

GetDataSet <- function() {
    ## Verifiy data dir exists and data files are present.
    
    if (!file.exists("data")) {
        dir.create("data")
    }
    if (!file.exists(dataset.zipfile)) {
        download.file(dataset.url, dataset.zipfile, method = "curl")
    }
    if (!file.exists(dataset.txtfileOne)) {
        unzip(dataset.zipfile, exdir = "data")
    }
}
