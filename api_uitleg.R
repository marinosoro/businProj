# Moet enkel 1e keer uitgevoerd worden. 
install.packages(c("httr", "jsonlite", "lubridate"))

library(httr)
library(jsonlite)
library(lubridate)

# Declare api endpoint and attributes
## Bijvoorbeeld: endpoint voor iOS lookup:
## De lijst met benodigde attributes per endpoint is te vinden op de pagina in de documentatie van 42matters
## In dit voorbeed, "access_token" is nodig voor de authenticatie, "id" is nodig zodat 42matters weet welk resultaat ze terug moeten sturen.
url <- "https://data.42matters.com/api/v2.0/ios/apps/lookup.json"
attributes <- list(access_token = Sys.getenv("'42matterskey'"),
                   id = "281796108")

# Make request and GET response
response <- GET(url, query = attributes)

# Extract data from response
result <- content(response, 'parsed')

## Hierna kunnen specifieke onderdelen uit "result" gehaald worden
## om bij te voegen aan de dataframes op de volgende manier:

# Bijvoorbeeld -> Check of de app geoptimaliseerd is voor iPad: 
isIpadOptimised <- result[["ipad"]]

# Ander voorbeeld -> Lijst met alle genres van de app
genres <- result[["genres"]]
    ## Dit resultaat is nu in de vorm van een "list" 
    ## Om dit om te zetten naar het formaat van een vector:

genres <- unlist(genres)


#EXTA LIJN