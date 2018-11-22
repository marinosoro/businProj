
ratingAppFunction <- function(whichApp) {
  allCategoryData %>% filter(trackCensoredName == whichApp) %>% select(averageUserRating, primaryGenreId, revenueId) -> ratingAppSearched
  allCategoryData %>% filter(primaryGenreId == ratingAppSearched$primaryGenreId) %>% select(averageUserRating) -> ratingGenre
  meanRatingGenre <- mean(ratingGenre$averageUser)
  return(ratingAppSearched)
}

ratingAppAdviceFunction <- function(whichApp) {
  allCategoryData %>% filter(trackCensoredName == whichApp) %>% select(averageUserRating, primaryGenreId, revenueId) -> ratingAppSearched
  allCategoryData %>% filter(primaryGenreId == ratingAppSearched$primaryGenreId) %>% select(averageUserRating) -> ratingGenre
  meanRatingGenre <- mean(ratingGenre$averageUser)
  if (ratingAppSearched$averageUserRating > meanRatingGenre + 0.2) 
    { advice <- ratingAdviceTable %>% filter(adviceId == 1) %>% select(adviceDescription)  
  } else if (ratingAppSearched$averageUserRating < meanRatingGenre - 0.2) 
    { advice <- ratingAdviceTable %>% filter(adviceId == 2) %>% select(adviceDescription) 
  } else { advice <- ratingAdviceTable %>% filter(adviceId == 3) %>% select(adviceDescription) } 
  return(advice)
}

ratingAdviceTable <- data.frame(adviceId = numeric(3), adviceDescription = character(3), stringsAsFactors = FALSE)
ratingAdviceTable$adviceId <- c(1, 2, 3)
ratingAdviceTable$adviceDescription <- c("Your app is performing better than the average app in your category", 
                                         "your app is performing worse than average in your category", 
                                         "your app is has an average rating for his category")
