source("./scripts/databaseHelper.R")

appleStore <- getDatabaseTable("appleStore")
appleStoreDescription <- getDatabaseTable("appleStoreDescription")
googlePlayStore <- getDatabaseTable("googlePlayStore")
googlePlayStoreReview <- getDatabaseTable("googlePlayStoreReview")
inAppPurchases <- getDatabaseTable("inAppPurchases")
appleAppCategories <- getDatabaseTable("appleAppCategories")
appleRanking <- getDatabaseTable("appleRanking")
appleCategories <- getDatabaseTable("appleCategories")

databaseLoaded <- TRUE
