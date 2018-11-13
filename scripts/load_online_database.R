#source("./databaseHelper.R")

appleStore <- getDatabaseTable("appleStore")
appleStoreDescription <- getDatabaseTable("appleStoreDescription")
googlePlayStore <- getDatabaseTable("googlePlayStore")
googlePlayStoreReview <- getDatabaseTable("googlePlayStoreReview")
inAppPurchases <- getDatabaseTable("inAppPurchases")
appleAppCategories <- getDatabaseTable("appleAppCategories")
appleRanking <- getDatabaseTable("appleRanking")
appleCategories <- getDatabaseTable("appleCategories")

appleCategory_Weather <- getDatabaseTable("appleCategory_Weather")

databaseLoaded <- TRUE
