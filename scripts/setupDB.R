source("./databaseHelper.R")
source("./load_datasets.R")

createTable("appleStore", appleStore)
createTable("appleStoreDescription", appleStoreDescription)
createTable("googlePlayStore", googlePlayStore)
createTable("googlePlayStoreReview", googlePlayStoreReviews)
createTable("inAppPurchases", inAppPurchases)
