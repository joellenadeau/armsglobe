DataScraping <- new.env()

# Create data directory.
if( !file.exists("../data") )
{
	dir.create("../data")
}

DataScraping$scrape <- function()
{
	# Setup path.
	fileUrl <- "https://raw.githubusercontent.com/dataarts/armsglobe/master/categories/All.json"
	filePath <- "../data/nisatdataset.json"	
	
	# Download file.
	download.file(fileUrl, destfile = filePath, mode = "wb")
	
	# WARNING: Manually download full dataset
	# http://info.worldbank.org/governance/wgi/index.aspx#home
	
	list.files("../data")
}