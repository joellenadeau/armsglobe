require(knitr)

source("DataExtractorNISAT.R")
source("DataExtractorWGI.R")
source("DataScraping.R")

# Scrapping the raw datasets.
DataScraping$scrape()

# Extract & Format raw datasets.
nisatdataset <- DataExtractorNISAT$extract("../data//nisatdataset.json")
wgidataset <- DataExtractorWGI$extract("../data//wgidataset.xlsx")
dataset <- merge(nisatdataset, wgidataset, by = c("country", "year"))

# Generate the result dataset.
write.csv(dataset, "../data//dataset.csv")

# Generate the codebook.
# knit("codebook.Rmd", output = "../codebook.html")

# Generate the analysis.
# knit("analysis.Rmd", output = "../analysis.html")
