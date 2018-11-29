## get rating of an app
ratingAppFunction <- function(whichApp) {
  getCompanyAppByName(whichApp) %>% select(averageUserRating) %>% as.numeric() -> ratingAppSearched
  return(ratingAppSearched)
}

## get mean rating for the category of the selected app
meanRatingGenreFunction <- function(whichApp) {
  getCompanyAppByName(whichApp) %>% select(primaryGenreId) %>% as.character() -> genreAppSearched
  allCategoryData %>% filter(primaryGenreId == genreAppSearched) %>% select(averageUserRating) -> ratingGenre
  meanRatingGenre <- mean(ratingGenre$averageUserRating)
  return(meanRatingGenre)
}

## get advice for app rating
ratingAppAdviceFunction <- function(whichApp) {
  ratingAppFunction(whichApp) -> ratingAppSearched
  meanRatingGenreFunction(whichApp) -> meanRatingGenre
  if (ratingAppSearched > meanRatingGenre + 0.2) 
    { advice <- ratingAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)  
  } else if (ratingAppSearched < meanRatingGenre - 0.2) 
    { advice <- ratingAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription) 
  } else { advice <- ratingAdviceTable %>% filter(adviceId == 3) %>% select(adviceDescription) } 
  advice <- advice %>% as.character()
  return(advice)
}

getAppPrice <- function(whichApp) {
  getCompanyAppByName(whichApp) %>% select(price) %>% as.numeric() -> priceAppSearched
  return(priceAppSearched)
}

## get advice for app price
priceAdviceFunction <- function(whichApp) {
  getAppPrice(whichApp) -> priceAppSearched
  getOptimalPriceByName(whichApp) -> optimalPrice
  
  if (priceAppSearched < optimalPrice)
  {advice <- priceAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription) %>% as.character()
  advice <- paste0(advice, " The recommended price is ", optimalPrice, "$. ")
  } else if (priceAppSearched > optimalPrice)
  {advice <- priceAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription) %>% as.character()
  advice <- paste0(advice, " The recommended price is ", optimalPrice, "$. ")
  } else {advice <- priceAdviceTable %>% filter(adviceId == 3) %>% select(adviceDescription) }
  advice <- advice %>% as.character()
  return(advice)
}

getOptimalPriceByName <- function(whichApp) {
  getCompanyAppByName(whichApp) %>% select(primaryGenreId) %>% 
    as.numeric() %>% getCategoryBestPriceById() -> optimalPrice
  return(optimalPrice)
}

getCategoryOptimalRevenueModel <- function(whichApp) {
  appCategoryId <- (getCompanyAppByName(whichApp))$primaryGenreId
  appCategoryName <- getCategoryNameById(appCategoryId)
  (revenueModels %>% filter(id == getSortedRevenueIdsForCategory(appCategoryName) %>% head(1)) %>% head(1))$id -> modelId
  return(modelId)
}

getCategoryOptimalRevenueModelName <- function(whichApp) {
  appCategoryId <- (getCompanyAppByName(whichApp))$primaryGenreId
  appCategoryName <- getCategoryNameById(appCategoryId)
  (revenueModels %>% filter(id == getSortedRevenueIdsForCategory(appCategoryName) %>% head(1)) %>% head(1))$description -> model
  return(model)
}

## get advice for revenue model of app
modelAdviceFunction <- function(whichApp) {
  getCompanyAppByName(whichApp) %>% select(revenueId) %>% as.numeric() -> appRevenueId
  getCategoryOptimalRevenueModel(whichApp) -> optimalModel
  
  if (appRevenueId == optimalModel) 
    {advice <- modelAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)
  } else {advice <- modelAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription) %>% as.character()
  advice <- paste0(advice, getCategoryOptimalRevenueModelName(whichApp), ".")
  }
  advice <- advice %>% as.character()
  return(advice)
}

## get insight on ranking app
## deze vind ik persoonlijk wel nutteloos, maar ik was toch bezig
rankingAdviceFunction <- function(whichApp) {
  getAppRank(whichApp) -> appRank 
  
  if (appRank < 11) 
  {advice <- rankingAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)
  } else if (appRank < 101) 
  {advice <- rankingAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription)
  } else if (appRank < 1001) 
  {advice <- rankingAdviceTable %>% filter(adviceId == 3) %>% select(adviceDescription)
  } else {advice <- rankingAdviceTable %>% filter(adviceId == 4) %>% select(adviceDescription)}
  advice <- advice %>% as.character()
  return(advice)
}

## get advice on twitter sentiment
tweetsAdviceFunction <- function(whichApp) {
  ## deze 2 regels hierboven zijn enkel nodig als er een aparte inputbalk voor komt
  if (tweetPercentageSentiment < 30)
  {advice <- tweetsAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)
  } else if (tweetPercentageSentiment < 70)
  {advice <- tweetsAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription)
  } else {advice <- tweetsAdviceTable %>% filter(adviceId == 3) %>% select(adviceDescription)}
  advice <- advice %>% as.character()
  return(advice)
}
  

ratingAdviceTable <- data.frame(adviceId = numeric(3), adviceDescription = character(3), stringsAsFactors = FALSE)
ratingAdviceTable$adviceId <- c(1, 2, 3)
ratingAdviceTable$adviceDescription <- c("which is better than the average for apps in this category.", 
                                         "which is worse than average for apps in this category.", 
                                         "which is an average rating for apps in this category.")

priceAdviceTable <- data.frame(adviceId = numeric(3), adviceDescription = character(3), stringsAsFactors = FALSE)
priceAdviceTable$adviceId <- c(1, 2, 3)
priceAdviceTable$adviceDescription <- c("This is too low, you should consider charging a higher price.",
                                        "This is too high, you should consider charging a lower price.", 
                                        "This is the optimal price.")

modelAdviceTable <- data.frame(adviceId = numeric(2), adviceDescription = character(2), stringsAsFactors = FALSE)
modelAdviceTable$adviceId <- c(1, 2)
modelAdviceTable$adviceDescription <- c("Your app uses the best revenuemodel for its category.",
                                        "Your app uses the wrong model, it's recomended to change your revenuemodel to ")

tweetsAdviceTable <- data.frame(adviceId = numeric(3), adviceDescription = character(3), stringsAsFactors = FALSE)
tweetsAdviceTable$adviceId <- c(1, 2, 3)
tweetsAdviceTable$adviceDescription <- c("People are complaining a lot on twitter about your app, you should take this serious.",
                                         "The general opinion on Twitter about your app is neither positive nor negative.", 
                                         "The general opinion about your app is positive on twitter.")

## deze vind ik persoonlijk wel nutteloos, maar ik was toch bezig
rankingAdviceTable <- data.frame(adviceId = numeric(4), adviceDescription = character(4), stringsAsFactors = FALSE)
rankingAdviceTable$adviceId <- c(1, 2, 3, 4)
rankingAdviceTable$adviceDescription <- c("top 10 ranked apps in its category for the apple store",
                                          "top 100 ranked apps in its category for the apple store",
                                          "top 1000 ranked apps in its category for the apple store",
                                          "top 10.000 ranked apps in its category for the apple store")

getCategoryAppByName <- function(whichApp) {
  getCompanyAppByName(whichApp) %>% select(primaryGenreId) %>% as.numeric() -> genreId
  getCategoryNameById(genreId) -> genreApp 
  return(genreApp)
}

## Business report
businessReport <- function(companyApp){
paste0("Business report ", companyApp) -> title

paste0(companyApp, " belongs to the category ", getCategoryAppByName(companyApp), 
       ". ", "The user rating for this app is ", ratingAppFunction(companyApp), ", ", ratingAppAdviceFunction(companyApp),
       "\n",  tweetsAdviceFunction(companyApp), '\n', "Your app belongs to the ", rankingAdviceFunction(companyApp),
       ", namely at rank ", getAppRank(companyApp), ". ", '\n', "The revenue that's generated by your app depends on the revenue model. ",
       modelAdviceFunction(companyApp), " Besides the revenue model, your price is important as well. ",
       "The price of your app is ", getAppPrice(companyApp), "$. ", priceAdviceFunction(companyApp)) -> body

report <- cat(title, body, sep = '\n\n')

}