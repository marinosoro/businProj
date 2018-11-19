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

getCategoryBestPrice <- function(categoryName) {
  ## meanRatingGenreRevenue filteren op Games
  y <- filter(meanRatingGenreRevenue, category == categoryName)
  z <- max(y$meanRating)
  y1 <- filter(y, meanRating == z)
  Id <- y1$revenueId
  result <- 0
  
  if (Id %in% c(4,2)){
    restult <- 0
  }
  
  else {
    categoryNameSlug <- str_replace(categoryName, pattern = ' ', replacement = '_')
    categoryNameSlug <- str_replace(categoryNameSlug, pattern = '& ', replacement = '')
    
    categoryDFName <- paste0("appleCategory_", categoryNameSlug)
    categoryDF <- get(categoryDFName, envir = .GlobalEnv)
    filteredCategoryDF <- filter(categoryDF, revenueId == Id)
    som <- 0
    som2 <- 0
    allApps <- split(filteredCategoryDF, seq_len(nrow(filteredCategoryDF)))
    
    for (rank in 1:nrow(filteredCategoryDF)) {
      app <- allApps[[rank]]
      inverseRank <- nrow(filteredCategoryDF) - rank + 1
      som <- som + (inverseRank*app$price)
      som2 <- som2 + inverseRank
    }
    result <- som / som2
  }
  return(round(result, digits = 2))
}

