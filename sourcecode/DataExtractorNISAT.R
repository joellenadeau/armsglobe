library(jsonlite)

DataExtractorNISAT <- new.env()

DataExtractorNISAT$extract <- function(url)
{
	DataExtractorNISAT$loadingRawData(url)
	DataExtractorNISAT$ExtractingYears()
	DataExtractorNISAT$ExtractingRawDataPerYear()
	return(DataExtractorNISAT$ConvertToDataFramePerYear())
}

DataExtractorNISAT$loadingRawData <- function(url)
{
	DataExtractorNISAT$rawData <- fromJSON(url)	
}

DataExtractorNISAT$ExtractingYears <- function()
{
	DataExtractorNISAT$years <- DataExtractorNISAT$rawData$timeBins$t
}

DataExtractorNISAT$ExtractingRawDataPerYear <- function()
{
	DataExtractorNISAT$rawDataPerYear <- DataExtractorNISAT$rawData$timeBins$data
}

DataExtractorNISAT$ConvertToDataFramePerYear <- function()
{
	nbYears <- length(DataExtractorNISAT$years)
	data <- data.frame()
	
	for( inxYear in 1:nbYears )
	{
		rawDataThisYear <- DataExtractorNISAT$rawDataPerYear[[inxYear]]
		dataThisYear <- data.frame(i = rawDataThisYear$i, wc = rawDataThisYear$wc, e = rawDataThisYear$e, v = rawDataThisYear$v)
		year <- DataExtractorNISAT$years[inxYear]
		data <- rbind(data, cbind(dataThisYear, year))
	}
	
	data <- aggregate( v~year+i, data, sum )
	
	# Format.
	data <- data.frame(lapply(data, as.character), stringsAsFactors=FALSE)
	names(data) <- c("year", "country", "importValue")
	data$country <- tolower(data$country)
	data$year <- as.numeric(data$year)
	
	return(data)
}