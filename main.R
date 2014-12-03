library(jsonlite)

sandbox <- new.env()

sandbox$init <- function()
{
	sandbox$loadingRawData()
	sandbox$ExtractingYears()
	sandbox$ExtractingRawDataPerYear()
	sandbox$ConvertToDataFramePerYear()
}

sandbox$loadingRawData <- function()
{
	urlRawData <- "./armsglobedata.json"
	sandbox$rawData <- fromJSON(urlRawData)	
}

sandbox$ExtractingYears <- function()
{
	sandbox$years <- sandbox$rawData$timeBins$t
}

sandbox$ExtractingRawDataPerYear <- function()
{
	sandbox$rawDataPerYear <- sandbox$rawData$timeBins$data
}

sandbox$ConvertToDataFramePerYear <- function()
{
	sandbox$dataPerYear <- list()
	for( inxYear in 1:length(sandbox$years) )
	{
		rawDataThisYear <- sandbox$rawDataPerYear[[inxYear]]
		dataThisYear <- data.frame(i = rawDataThisYear$i, wc = rawDataThisYear$wc, e = rawDataThisYear$e, v = rawDataThisYear$v)
		sandbox$dataPerYear[[inxYear]] <- dataThisYear
	}
}

sandbox$init()

## Show summaries.
sandbox$years
str(sandbox$dataPerYear[[1]])
summary(sandbox$dataPerYear[[1]])
