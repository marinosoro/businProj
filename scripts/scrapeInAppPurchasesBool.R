# Scrape App Annie

library(rvest)
library(dplyr)
library(progress)

ids <- c(1)
inAppPurchases <- (FALSE)

pb <- progress_bar$new(total = length(appleStore$id))
for (id in appleStore$id) {
    pb$tick()
    Sys.sleep(1 / 100)
    try({
        app <- read_html( paste0("https://itunes.apple.com/app/id", id) )
        node <- app %>% 
          html_node(".app-header__list__item--in-app-purchase") %>% 
          html_text()
        
        ids <- append(ids, id)
        if ( !is.na(node) ) {
          inAppPurchases <- append(inAppPurchases, TRUE)
        } else {
          inAppPurchases <- append(inAppPurchases, FALSE)
        }
        
        closeAllConnections()
    }, next)
}

hasInAppPurchases <- data.frame(ids, inAppPurchases)
names(hasInAppPurchases)<-c("id","hasInAppPurchases")

