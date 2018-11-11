library(RMySQL)

# Load Data from csv files
appleStore <- read.csv("../datasets/apple/applestore.csv", sep=",")
appleStoreDescription <- read.csv("../datasets/apple/applestore_description.csv", sep=",")
googlePlayStore <- read.csv("../datasets/google/googleplaystore.csv", sep=",")
googlePlayStoreReviews <- read.csv("../datasets/google/googleplaystore_user_reviews.csv", sep=",")

# Eigen data
inAppPurchases <- read.csv("../datasets/scrapped/inAppPurchases.csv", sep=",")