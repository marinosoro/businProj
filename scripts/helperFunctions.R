library(dplyr)
library(httr)
library(jsonlite)
library(lubridate)

getAppCategories <- function(requestedId, store) {
  categories <- vector()
  if (store == "apple") {
    boolDF <- filter(appleAppCategories, id == requestedId)[c(-1, -2)]
    categories <- boolDF %>% select_if(function(cat) cat == TRUE) %>% names()
  } else if (store == "google") {
    ##
  } else {
    return(NA)
  }
  return(categories)
}

getAppRank <- function(requestedId, store) {
  if (store == "apple") {
    return(filter(appleRanking, id == requestedId)[["rank"]])
  } else if (store == "google") {
    ##
  } else {
    return(NA)
  }
}

getAPIContent <- function(url, params, method, page) {
  # Combine params with access_token
  if (missing(params)) {
    params <- list(access_token = Sys.getenv("'42matterskey'"))
  } else if (typeof(params) == "list") {
    params <- c(list(access_token = Sys.getenv("'42matterskey'")), params)
  } else if (typeof(params) == "character") {
    url <- paste0(url, "?access_token=", Sys.getenv("'42matterskey'"), "&page=", page)
  }
  # Code for GET requests
  if (missing(method) || method == "GET") {
    response <- GET(url, query = params)
  } 
  # Code for POST requests
  else if (method == "POST") {
    response <- POST(url, body = params, encode = "json")
  }
  result <- content(response, 'parsed')
  return(result)
}

# Closes all mysql connections
dbDisconnectAll <- function(){
  ile <- length(dbListConnections(MySQL())  )
  lapply( dbListConnections(MySQL()), function(x) dbDisconnect(x) )
  cat(sprintf("%s connection(s) closed.\n", ile))
}