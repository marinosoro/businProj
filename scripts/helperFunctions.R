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

getAppRankById <- function(requestedId, store) {
  if(missing(store)) store = "apple"
  if (store == "apple") {
    return(filter(allCategoryData, id == requestedId)[["rank"]])
  } else if (store == "google") {
    ##
  } else {
    return(NA)
  }
}
getAppRank <- function(appName, store) {
  if(missing(store)) store = "apple"
  if (store == "apple") {
    return(filter(allCategoryData, trackCensoredName == appName)[["rank"]])
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

getCompanyApps <- function() {
  apps <- left_join(companyApps, allCategoryData, by = c("id" = "trackId"))
  return(apps)
}

getCompanyAppByName <- function(name) {
  apps <- getCompanyApps()
  app <- (filter(apps, trackCensoredName == name)) %>% head(1)
  return(app)
}

getCompanyAppByid <- function(id) {
  apps <- getCompanyApps()
  app <- (filter(apps, id == id)) %>% head(1)
  return(app)
}

getAppIcon <- function(id) {
  html <- read_html( paste0("https://itunes.apple.com/app/id", id) )
  src <- html %>%
    html_node("img.we-artwork__image") %>%
    html_attr("src")
  return(src)
}

getSortedRevenueIdsForCategory <- function(categoryName) {
  categoryIndexes <- get("categoryIndexes", env = .GlobalEnv)
  categoryIndex <- categoryIndexes %>% filter(name == categoryName)

  model1Index = categoryIndex$index1
  model2Index = categoryIndex$index2
  model3Index = categoryIndex$index3
  model4Index = categoryIndex$index4

  indexes <- c("1" = model1Index, "2" = model2Index, "3" = model3Index, "4" = model4Index)
  sortedIndexes <- sort(indexes, T)

  names <- names(sortedIndexes)
  names <- as.numeric(names)

  return(names)
}

getCategoryBestPriceById <- function(catId) {
  categoryName <- (appleCategories %>% filter(id == catId) %>% head(1))$name
  categoryBestPrice <- getCategoryBestPrice(categoryName)
  return(categoryBestPrice)
}

getCategoryBestPrice <- function(categoryName, nonZero) {
  if (missing(nonZero)) nonZero = F

  sortedIds <- getSortedRevenueIdsForCategory(categoryName)

  if (!nonZero) Id <- sortedIds[1]
  else {
    # kies hoogste van 1 en 3
    if (sortedIds[1] == 1 || sortedIds[1] == 3) Id <- sortedIds[1]
    else if (sortedIds[2] == 1 || sortedIds[2] == 3) Id <- sortedIds[2]
    else if (sortedIds[3] == 1 || sortedIds[3] == 3) Id <- sortedIds[3]
    else Id <- sortedIds[4]
  }
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
    appPrices <- filteredCategoryDF$price
    for (rank in 1:nrow(filteredCategoryDF)) {
      price <- appPrices[rank]
      inverseRank <- nrow(filteredCategoryDF) - rank + 1
      som <- som + (inverseRank*price)
      som2 <- som2 + inverseRank
    }
    result <- som / som2
  }
  return(round(result, digits = 2))
}

getCategoryNameById <- function(catId) {
  result <- appleCategories %>% filter(id == catId) %>% head(1)
  return(result$name)
}
getCategoryIdByName <- function(catName) {
  result <- appleCategories %>% filter(name == catName) %>% head(1)
  return(result$id)
}

getCompanyAppsForCategory <- function(catName, secondary) {
    companyApps <- getCompanyApps()
    categoryId <- getCategoryIdByName(catName)
    if (missing(secondary) || secondary == F) {
        result <- filter(companyApps, primaryGenreId == categoryId)
    } else {
        result <- filter(companyApps, grepl(categoryId, genreIds) & primaryGenreId != categoryId)
    }
    return(result)
}
