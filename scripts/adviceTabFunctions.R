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

priceAdviceFunction <- function(whichApp) {
  getCompanyAppByName(whichApp) %>% select(price) %>% as.numeric() -> priceAppSearched
  getCompanyAppByName(whichApp) %>% select(primaryGenreId) %>% 
    getCategoryBestPriceById() %>% as.numeric() -> optimalPrice
  
  if (priceAppSearched < optimalPrice)
  {advice <- priceAdviceFunction %>% filter(adviceId == 1) %>% select(adviceDescription)
  } else if (priceAppSearched > optimalPrice)
  {advice <- priceAdviceFunction %>% filter(adviceId == 2) %>% select(adviceDescription)
  } else {advice <- priceAdviceFunction %>% filter(adviceId == 3) %>% select(adviceDescription) }
  advice <- advice %>% as.character()
  return(advice)
}

modelAdviceFunction <- function(whichapp) {
  getCompanyAppByName(whichApp) %>% select(revenueId) %>% as.numeric() -> appRevenueId
  getCompanyAppByName(whichApp) %>% select(primaryGenreId) %>%
    categoryOptimalRevenueModel() %>% as.numeric() -> optimalModel
  
  if (appRevenueId == optimalModel) 
    {advice <- modelAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)
  } else {advice <- modelAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription)}
  advice <- advice %>% as.character()
  return(advice)
}

rankAdviceFunction <- function(whichapp) {
  getAppRank(whichApp) -> appRank 
  
  if (appRank <= 10) 
  {advice <- rankingAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)
  } else if (appRank <= 100) 
  {advice <- rankingAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription)
  } else if (appRank <= 1000) 
  {advice <- rankingAdviceTable %>% filter(adviceId == 3) %>% select(adviceDescription)
  } else {advice <- rankingAdviceTable %>% filter(adviceId == 4) %>% select(adviceDescription)}
  advice <- advice %>% as.character()
  return(advice)
}

tweetsAdviceFunction <- function(whichApp) {
  
  
  if (tweetsApp < 30)
  {advice <- tweetsAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)
  } else if (tweetsApp < 70)
  {advice <- tweetsAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription)
  } else {advice <- tweetsAdviceTable %>% filter(adviceId == 3) %>% select(adviceDescription)}
  advice <- advice %>% as.character()
  return(advice)
}
  

ratingAdviceTable <- data.frame(adviceId = numeric(3), adviceDescription = character(3), stringsAsFactors = FALSE)
ratingAdviceTable$adviceId <- c(1, 2, 3)
ratingAdviceTable$adviceDescription <- c("Your app is performing better than the average app in its category", 
                                         "your app is performing worse than average in its category", 
                                         "your app is has an average rating for its category")

priceAdviceTable <- data.frame(adviceId = numeric(3), adviceDescription = character(3), stringsAsFactors = FALSE)
priceAdviceTable$adviceId <- c(1, 2, 3)
priceAdviceTable$adviceDescription <- c("The price of your app is too low, you should consider charging a higher price",
                                        "The price of your app is too high, you should consider charging a lower price", 
                                        "Your app has the optimal price")

modelAdviceTable <- data.frame(adviceId = numeric(2), adviceDescription = character(2), stringsAsFactors = FALSE)
modelAdviceTable$adviceId <- c(1, 2)
modelAdviceTable$adviceDescription <- c("Your app uses the best revenuemodel for its category",
                                        "Your app uses the wrong model, it's recomended to change your revenuemodel")

tweetsAdviceTable <- data.frame(adviceId = numeric(3), adviceDescription = character(3), stringsAsFactors = FALSE)
tweedsAdviceTable$adviceId <- c(1, 2, 3)
tweetsAdviceTable$adviceDescription <- c("people are complaining a lot on twitter about your app, you should take this serious",
                                         "the general opinion about your app is neither positive of negative", 
                                         "the general opinion about your app is positive on twitter")

rankingAdviceTable <- data.frame(adviceId = numeric(4), adviceDescription = character(4), stringsAsFactors = FALSE)
rankingAdviceTable$adviceId <- c(1, 2, 3, 4)
rankingAdviceTable$adviceDescription <- c("Your app belongs to the top 10 ranked apps in its category for the apple store",
                                          "Your app belongs to the top 100 ranked apps in its category for the apple store",
                                          "your app belongs to the top 1000 ranked apps in its category for the apple store",
                                          "your app belongs to the top 10.000 ranked apps in its category for the apple store")