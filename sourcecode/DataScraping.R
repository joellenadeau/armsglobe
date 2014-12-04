DataScraping <- new.env()

# Create data directory.
if( !file.exists("../data") )
{
	dir.create("../data")
}

DataScraping$scrape <- function()
{
	# Download NISAT.
	fileUrl <- "https://raw.githubusercontent.com/dataarts/armsglobe/master/categories/All.json"
	filePath <- "../data/nisatdataset.json"
	download.file(fileUrl, destfile = filePath, mode = "wb")
	
	# Download WGI
	# WARNING: Manually download full dataset
	# http://info.worldbank.org/governance/wgi/index.aspx#home
	
	# Download WB
	source("DataScraperWB.R")
	
	datasetGDP <- DataScraperWB$loadingIndicator("6.0.GDP_current")
	write.csv(datasetGDP, "../data/datasetWB_GDB.csv")
	
	list.files("../data")
}