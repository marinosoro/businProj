url <- "https://data.42matters.com/api/meta/ios/apps/app_primary_genres.json"
categories <- getAPIContent(url)

getAppsFromApi <- function(catId, maxResults, pageToStart, variableToStore) {
  if (missing(variableToStore)) stop("variableToStore is missing")
  if (missing(pageToStart)) pageToStart <- 1
  
  url <- "https://data.42matters.com/api/v2.0/ios/apps/query.json"
  params <- paste0('
    {
      "query": {
        "query_params": {
          "primaryGenreId": [', catId, ']
        }
      } 
    }
  ')
  categoryApps <- getAPIContent(url, params = params, method = "POST", page = pageToStart)
  if (!is.null(categoryApps[["statusCode"]]) && categoryApps[["statusCode"]] != 200) {
    stop(paste0("Process stopped at start because of following error. '", categoryApps[["message"]], "'"))
  }
  number_results <- categoryApps[["number_results"]]
  categoryAppsDF <- convertToDF(categoryApps$results)
  pb <- progress_bar$new(total = 100)
  for (n in pageToStart+1:min(c(maxResults / 50, number_results / 50))) {
    try({
      pb$tick()
    })
    Sys.sleep(1 / 2)
    # Make new request
      categoryApps <- getAPIContent(url, params = params, method = "POST", page = n)
      if (!is.null(categoryApps[["statusCode"]]) && categoryApps[["statusCode"]] != 200) {
        assign(variableToStore, value = categoryAppsDF, envir = .GlobalEnv)
        stop(paste0("Process stopped at page: ", n-1, " because of following error. '", categoryApps[["message"]], "'"))
      }
    # Merge new results with already generated results
    categoryAppsDF <- rbind(categoryAppsDF, convertToDF(categoryApps$results))
  }
  catId <- id
  category <- appleCategories %>% filter(id == catId)
  categoryName <- category$name
  assign(variableToStore, value = categoryAppsDF, envir = .GlobalEnv)
  #addToTable(paste0("appleCategory_", str_replace(categoryName, " ", "_")), categoryAppsDF)
}

convertToDF <- function(list) {
  trackCensoredName <- vector()
  price <- vector()
  trackId <- vector()
  iphone <- vector()
  ipad <- vector()
  primaryGenreId <- vector()
  genreIds <- vector()
  formattedPrice <- vector()
  averageUserRating <- vector()
  userRatingCount <- vector()
  for (app in list) {
    if (!is.null(app[["trackCensoredName"]]))
      trackCensoredName <- append(trackCensoredName, app[["trackCensoredName"]])
    else
      trackCensoredName <- append(trackCensoredName, NA)
    if (!is.null(app[["price"]]))
      price <- append(price, app[["price"]])
    else 
      price <- append(price, NA)
    if (!is.null(app[["trackId"]]))
      trackId <- append(trackId, app[["trackId"]])
    else
      trackId <- append(trackId, NA)
    if (!is.null(app[["iphone"]]))
      iphone <- append(iphone, app[["iphone"]])
    else
      iphone <- append(iphone, NA)
    if (!is.null(app[["ipad"]]))
      ipad <- append(ipad, app[["ipad"]])
    else
      ipad <- append(ipad, NA)
    if (!is.null(app[["primaryGenreId"]]))
      primaryGenreId <- append(primaryGenreId, app[["primaryGenreId"]])
    else
      primaryGenreId <- append(primaryGenreId, NA)
    if (!is.null(app[["genreIds"]])) {
      appGenreIds <- ""
      for (id in app[["genreIds"]]) {
        appGenreIds <- paste0(appGenreIds, id, ",")
      }
      genreIds <- append(genreIds, appGenreIds)
    }
    else
      genreIds <- append(genreIds, NA)
    if (!is.null(app[["formattedPrice"]]))
      formattedPrice <- append(formattedPrice, app[["formattedPrice"]])
    else
      formattedPrice <- append(formattedPrice, NA)
    if (!is.null(app[["averageUserRating"]]))
      averageUserRating <- append(averageUserRating, app[["averageUserRating"]])
    else
      averageUserRating <- append(averageUserRating, NA)
    if (!is.null(app[["userRatingCount"]]))
      userRatingCount <- append(userRatingCount, app[["userRatingCount"]])
    else
      userRatingCount <- append(userRatingCount, NA)
  }
  return(data.frame(trackCensoredName,
                    price, 
                    trackId, 
                    iphone,
                    ipad, 
                    primaryGenreId, 
                    genreIds, 
                    formattedPrice, 
                    averageUserRating,
                    userRatingCount))
}  