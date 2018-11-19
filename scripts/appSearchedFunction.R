

appSearchedFunction <- function(whichApp){
  allCategoryData %>% filter(trackCensoredName == whichApp) -> appSearched
  appleCategories %>% filter(id == appSearched$primaryGenreId) %>% select(name) -> appSearched$primaryGenreId
  revenueModels %>% filter(id == appSearched$revenueId) %>% select(description) -> appSearched$revenueDescription
  appSearched %>% select(price, averageUserRating, userRatingCount, revenueDescription, primaryGenreId) -> appSearched
  colnames(appSearched) <- c("Price", "Rating", "Rating count", "Revenue model", "Genre")
  return(appSearched)
}
