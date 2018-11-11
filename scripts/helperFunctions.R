library(dplyr)

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