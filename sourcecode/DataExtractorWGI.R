options(java.parameters = "-Xmx8000m") # Java Stack full bugfix
library(xlsx)

DataExtractorWGI <- new.env()

DataExtractorWGI$extract <- function(url)
{
	DataExtractorWGI$init()
	DataExtractorWGI$politicalStability <- DataExtractorWGI$extractPage(url, 2, "psnv")
	DataExtractorWGI$governmentEffectiveness <- DataExtractorWGI$extractPage(url, 3, "ge")
	DataExtractorWGI$ruleOfLaw <- DataExtractorWGI$extractPage(url, 5, "rol")
	return(DataExtractorWGI$mergeByCountryAndYear())
}

DataExtractorWGI$init <- function()
{
	DataExtractorWGI$colIndex <- c( 1, seq(from = 3, to = 999, by = 6))
}

DataExtractorWGI$extractPage <- function(url, sheetIndex, prefix)
{
	year <- read.xlsx(url, sheetIndex = sheetIndex, head = FALSE, rowIndex = 14, colIndex = DataExtractorWGI$colIndex)
	data <- read.xlsx(url, sheetIndex = sheetIndex, startRow = 15, colIndex = DataExtractorWGI$colIndex)
	names(data) <- year
	names(data)[1] <- "country"
	return(data)
}

DataExtractorWGI$splitByYear <- function(dataToSplit, dataName)
{
	data <- data.frame()
	for( inxCol in 2:length(dataToSplit) )
	{
		year <- names(dataToSplit)[inxCol]
		country <- as.character(dataToSplit[,1])
		tmp <- cbind(country, year, dataToSplit[,inxCol])
		names(tmp) <- c("country", "year", dataName)
		data <- rbind(data, tmp)
	}
	return(data)
}

DataExtractorWGI$mergeByCountryAndYear <- function()
{
	politicalStability <- DataExtractorWGI$splitByYear(DataExtractorWGI$politicalStability, "politicalStability")
	governmentEffectiveness <- DataExtractorWGI$splitByYear(DataExtractorWGI$governmentEffectiveness, "governmentEffectiveness")
	ruleOfLaw <- DataExtractorWGI$splitByYear(DataExtractorWGI$ruleOfLaw, "ruleOfLaw")
	
	data <- merge(politicalStability, governmentEffectiveness, by = c("country", "year"))
	data <- merge(data, ruleOfLaw, by = c("country", "year"))
	
	# Format.
	data <- data.frame(lapply(data, as.character), stringsAsFactors=FALSE)
	names(data) <- c("country", "year", "politicalStability", "governmentEffectiveness", "ruleOfLaw")
	data$country <- tolower(data$country)
	data$year <- as.numeric(data$year)
	data$politicalStability <- as.numeric(data$politicalStability)
	data$governmentEffectiveness <- as.numeric(data$governmentEffectiveness)
	data$ruleOfLaw <- as.numeric(data$ruleOfLaw)
	
	return(data)
}
