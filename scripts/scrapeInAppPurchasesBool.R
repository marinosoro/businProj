# Vult de kolom "hasInAppPurchases" verder aan in de LOKALE dataframe. 
# Vergeet niet de online database te updaten via de ftie "createTable()"
startScrape <- function(categoryDF, variableToStore) {
  if(!is.data.frame(categoryDF)) stop("categoryDF must be a data.frame")

  copyDF <- categoryDF
  index <- 0
  
  # If Column doesn't exist
  if (is.null(copyDF[["hasInAppPurchases"]])) {
    copyDF <- mutate(copyDF, hasInAppPurchases = NA)
    assign(variableToStore, copyDF, envir = .GlobalEnv)
  }
  
  pb <- progress_bar$new(total = length(categoryDF$trackId))
  for (app in split(copyDF, seq_len(nrow(copyDF)))) {
    index <- index + 1
    pb$tick()
    Sys.sleep(1 / 100)
    if (!is.na(app$hasInAppPurchases)) {
      next
    }
    try({
      html <- read_html( paste0("https://itunes.apple.com/app/id", app$trackId) )
      node <- html %>% 
        html_node(".app-header__list__item--in-app-purchase") %>% 
        html_text()
      
      if ( !is.na(node) ) {
        copyDF$hasInAppPurchases[index] <- 1
        assign(variableToStore, copyDF, envir = .GlobalEnv)
      } else {
        copyDF$hasInAppPurchases[index] <- 0
        assign(variableToStore, copyDF, envir = .GlobalEnv)
      }
      
      closeAllConnections()
    }, next)
  }
}