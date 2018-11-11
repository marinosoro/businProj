#url <- "https://data.42matters.com/api/v2.0/ios/apps/query.json"

url <- "https://data.42matters.com/api/meta/ios/apps/app_primary_genres.json"
categories <- getAPIContent(url)

categoryNames <- vector()
categoryIds <- vector()
for (cat in categories$genres) {
  categoryNames <- append(categoryNames, cat[["name"]])
  categoryIds <- append(categoryIds, cat[["genreId"]])
}

categoriesDF <- data.frame(categoryIds, categoryNames)
names(categoriesDF) <- c("id", "name")
