<<<<<<< HEAD
source("./scripts/databaseHelper.R")
=======
#source("./databaseHelper.R")
>>>>>>> 67154fe1265916a1cabf2cb235391ec98feb08b3

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
