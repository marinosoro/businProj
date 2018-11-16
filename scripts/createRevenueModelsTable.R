revenueModels <- data.frame(id = c(1:4), hasInAppPurchases = c(0,0,1,1), isFree = c(0,1,0,1))
for (category in ls(pattern = 'appleCategory_')) {
  if(is.null(get(category)$hasInAppPurchases)) {
    next
  }
  categoryDF <- get(category) %>% mutate(revenueId = NA)
  index = 0
  for (app in split(categoryDF, seq_len(nrow(categoryDF)))) {
    index = index + 1
    if (is.na(app$hasInAppPurchases)) {
      next
    }
    else if (app$hasInAppPurchases == 0 && app$price > 0) {
      categoryDF$revenueId[index] <- 1
    }
    else if(app$hasInAppPurchases == 0 && app$price == 0) {
      categoryDF$revenueId[index] <- 2
    }
    else if (app$hasInAppPurchases == 1 && app$price > 0) {
      categoryDF$revenueId[index] <- 3
    }
    else if (app$hasInAppPurchases == 1 && app$price == 0) {
      categoryDF$revenueId[index] <- 4
    }
  }
  assign(category, categoryDF, envir = .GlobalEnv)
  createTable(category, categoryDF)
}