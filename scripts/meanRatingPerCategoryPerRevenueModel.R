## alle datasets per categorie samenvoegen

appleCategory_Business$X <- NULL
appleCategory_Games$row_names <- NULL
appleCategory_Weather$row_names <- NULL

allCategoryData <- rbind(appleCategory_Book, appleCategory_Business, appleCategory_Catalogs, appleCategory_Education, 
                          appleCategory_Entertainment, appleCategory_Finance, appleCategory_Food_Drink, appleCategory_Games,
                          appleCategory_Health_Fitness, appleCategory_Lifestyle, appleCategory_Magazines_Newspapers,
                          appleCategory_Medical, appleCategory_Music, appleCategory_Navigation, appleCategory_News, 
                          appleCategory_Photo_Video, appleCategory_Productivity, appleCategory_Reference, appleCategory_Shopping,
                          appleCategory_Social_Networking, appleCategory_Sports, appleCategory_Stickers, appleCategory_Travel,
                          appleCategory_Utilities, appleCategory_Weather)

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

remove(i, j, k, z, y, y1)

## choices maken voor in selectinput in shiny

CategoryChoices <- appleCategories
CategoryChoices$row_names <- NULL
CategoryChoices$id <- NULL




