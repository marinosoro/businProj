## alle datasets per categorie samenvoegen

<<<<<<< HEAD
=======
meanRatingPerRevenueModel <- function(categoryName) {

}
>>>>>>> 0df9b2aa83f0d010b90229e47fed08d9fb56b0b2
appleCategory_Business$X <- NULL
appleCategory_Games$row_names <- NULL
appleCategory_Weather$row_names <- NULL

allCategories <- rbind(appleCategory_Book, appleCategory_Business, appleCategory_Catalogs, appleCategory_Education, 
                          appleCategory_Entertainment, appleCategory_Finance, appleCategory_Food_Drink, appleCategory_Games,
                          appleCategory_Health_Fitness, appleCategory_Lifestyle, appleCategory_Magazines_Newspapers,
                          appleCategory_Medical, appleCategory_Music, appleCategory_Navigation, appleCategory_News,
                          appleCategory_Photo_Video, appleCategory_Productivity, appleCategory_Reference, appleCategory_Shopping,
                          appleCategory_Social_Networking, appleCategory_Sports, appleCategory_Stickers, appleCategory_Travel,
                          appleCategory_Utilities, appleCategory_Weather)

newDataframe <- appleCategory_Book %>% mutate(rank = c(1:nrow(appleCategory_Book)))
for (category in allCategories) {
  categoryDF <- get(category)
  categoryDF %>% mutate(rank = 1:nrow(categoryDF))
  newDataframe <- rbind(newDataframe, categoryDF)
}

rankVector <- 1:nrow(appleCategory_Book)
for (category in allCategories) {
  categoryDF <- get(category)
  newVector <- 1:nrow(categoryDF)
  rankVector <- append(rankVector, values = newVector)
}

allCategoryData <- na.omit(allCategoryData)

## gemiddelde rating per revenue model en per categorie berekenen

countGenreId <- count(allCategoryData, primaryGenreId)
colnames(countGenreId)[1] <- "id"
countGenre <- left_join(appleCategories, countGenreId)
countGenre <- filter(countGenre, id != 6022)
allCategoryData <- filter(allCategoryData, primaryGenreId != 6022)

meanRatingGenreRevenue <- data.frame(category = character(), revenueId = numeric(), meanRating = numeric(), stringsAsFactors = FALSE)
i = j = k = r = 1
z = 0

for(i in 1:24){
  y <- filter(allCategoryData, primaryGenreId == countGenre$id[i])
  for(j in 1:4){
    y1 <- filter(y, revenueId == j)
    value1 <- count(y1)

    if (value1$n[1] == 0){
      meanRatingGenreRevenue[nrow(meanRatingGenreRevenue) + 1,] = list(countGenre$name[i], j, 0)
      j = (j + 1)
      }

    else {
      for(k in 1:value1$n[1]){
        z = z + y1$averageUserRating[k]
        k = (k + 1)
      }
      z = (z/(value1$n[1] + 0))
      meanRatingGenreRevenue[nrow(meanRatingGenreRevenue) + 1,] = list(countGenre$name[i], j, z)
      k = 1
      z = 0
      remove(value1)
      j = (j + 1)
    }
  }
  j = 1
  i = (i + 1)
}

<<<<<<< HEAD
<<<<<<< HEAD
remove(i, j, k, z, y, y1)
=======
=======
>>>>>>> d0acdf0e2db834e3c000d54ff81c7a6edc6aa5f6
remove(i, j, k, z, y, y1)

## choices maken voor in selectinput in shiny

CategoryChoices <- appleCategories
CategoryChoices$row_names <- NULL
CategoryChoices$id <- NULL




<<<<<<< HEAD
>>>>>>> 0df9b2aa83f0d010b90229e47fed08d9fb56b0b2
=======
>>>>>>> d0acdf0e2db834e3c000d54ff81c7a6edc6aa5f6
