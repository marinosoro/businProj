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

getAPIContent <- function(url, params, method) {
  if (missing(params)) {
    params <- list(access_token = Sys.getenv("'42matterskey'"))
  } else {
    params <- list(c(access_token = Sys.getenv("'42matterskey'"), params))
  }
  if (missing(method) || method == "GET") {
    response <- GET(url, query = params)
  } else if (method == "POST") {
    response <- POST(url, query = params)
  }
  result <- content(response, 'parsed')
  return(result)
}