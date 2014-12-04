library(jsonlite)

DataScraperWB <- new.env()

DataScraperWB$loadingCountries <- function()
{
	if( !exists("nbCountry", DataScraperWB) | !exists("countryCodes", DataScraperWB) | !exists("countryNames", DataScraperWB) )
	{
		rawData <- fromJSON("http://api.worldbank.org/country?per_page=10000&format=json")
		DataScraperWB$nbCountry <- rawData[[1]]$total
		DataScraperWB$countryCodes <- rawData[[2]]$id
		DataScraperWB$countryNames <- rawData[[2]]$name	
	}
}

DataScraperWB$loadingIndicator <- function(indicator)
{
	DataScraperWB$loadingCountries()
	
	dataset <- data.frame()
	
	for(inxCountry in 1:DataScraperWB$nbCountry)
	{
		query <- paste("http://api.worldbank.org/countries/", DataScraperWB$countryCodes[inxCountry], "/indicators/", indicator, "?per_page=1000&date=1960:2014&format=json", sep = "")	
		gdpPerYear <- fromJSON(query)
		if(length(gdpPerYear) == 2)
		{
			years <- gdpPerYear[[2]]$date
			gdps <- gdpPerYear[[2]]$value
			dataCountry <- cbind(DataScraperWB$countryNames[inxCountry], years, gdps)
			dataset <- rbind(dataset, dataCountry)
			print(DataScraperWB$countryNames[inxCountry])
		}
		else
		{
			print(paste("FAIL:", DataScraperWB$countryNames[inxCountry]))	
		}
	}
	
	# Format
	names(dataset)[1] <- "country"
	dataset$country <- tolower(dataset$country)
	na.omit(dataset)
	
	return(dataset)
}