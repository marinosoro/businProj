url <-  "https://data.42matters.com/api/v2.0/ios/apps/top_appstore_charts.json"
attributes <- list(access_token = Sys.getenv("'42matterskey'"))
response <- GET(url, query = attributes)
q <- content(response, 'parsed')[["number_results"]]
limit <- 100

appCategories <- data.frame(id = integer(), 
                        Books = character(), 
                        Business = character(), 
                        'Developer Tools' = character(), 
                        Education = character(), 
                        Entertainment = character(), 
                        Finance = character(), 
                        'Food & Drink' = character(), 
                        Games = character(), 
                        'Graphics & Design' = character(), 
                        'Health & Fitness' = character(), 
                        Lifestyle = character(), 
                        Kids = character(), 
                        'Magazines & Newspapers' = character(),
                        Medical = character(),
                        Music = character(), 
                        Navigation = character(), 
                        News = character(), 
                        'Photo & Video' = character(), 
                        Photography = character(), 
                        Productivity = character(), 
                        Reference = character(), 
                        Shopping = character(), 
                        'Social Networking' = character(), 
                        Sports = character(), 
                        Travel = character(), 
                        Utilities = character(), 
                        Video = character() , 
                        Weather = character())

appRanking <- data.frame(id = integer(), rank = integer())

for (n in 1:ceiling(q/limit)) {
  attributes <- list(access_token = Sys.getenv("'42matterskey'"),
                     page = n)
  
  response <- GET(url, query = attributes)
  appList <- content(response, 'parsed')
  
  # maak lege dataframe met kolommen
  dataFrame <- data.frame(id = integer(), 
                          Books = character(), 
                          Business = character(), 
                          'Developer Tools' = character(), 
                          Education = character(), 
                          Entertainment = character(), 
                          Finance = character(), 
                          'Food & Drink' = character(), 
                          Games = character(), 
                          'Graphics & Design' = character(), 
                          'Health & Fitness' = character(), 
                          Lifestyle = character(), 
                          Kids = character(), 
                          'Magazines & Newspapers' = character(),
                          Medical = character(),
                          Music = character(), 
                          Navigation = character(), 
                          News = character(), 
                          'Photo & Video' = character(), 
                          Photography = character(), 
                          Productivity = character(), 
                          Reference = character(), 
                          Shopping = character(), 
                          'Social Networking' = character(), 
                          Sports = character(), 
                          Travel = character(), 
                          Utilities = character(), 
                          Video = character() , 
                          Weather = character())
  
  # voeg rij toe aan datafame per app
  i <- 0
  for (app in appList[["app_list"]]){
    i <- i+1
    id <- app[["trackId"]]
    appGenres <- unlist(app[["genres"]])
    boolVector <- vector()
    allGenres <- c("Books", "Business", "Developer Tools" , "Education", "Entertainment", "Finance", "Food & Drink", 
                   "Games", "Graphics & Design" , "Health & Fitness", "Lifestyle", "Kids" , "Magazines & Newspapers", 
                   "Medical", "Music", "Navigation","News", "Photo & Video" , "Photography" , "Productivity", "Reference", 
                   "Shopping", "Social Networking", "Sports", "Travel", "Utilities", "Video" , "Weather")
    
    for (genre in allGenres){
      if (genre %in% appGenres){ 
        boolVector <- append(boolVector, TRUE)
      }
      else{ 
        boolVector <- append(boolVector, FALSE)
      }
    }
    
    # nieuwe rij toevoegen aan dataframe
    appRanking <- rbind(appRanking, c(id, (n-1)*100+i))
    dataFrame <- rbind(dataFrame, c(id, boolVector))
  }
  names(appRanking) <- c("id", "rank")
  names(dataFrame) =  c("id","Books", "Business", "Developer Tools" , "Education", "Entertainment", "Finance", "Food & Drink", 
                        "Games", "Graphics & Design" , "Health & Fitness", "Lifestyle", "Kids" , "Magazines & Newspapers", 
                        "Medical", "Music", "Navigation","News", "Photo & Video" , "Photography" , "Productivity", "Reference", 
                        "Shopping", "Social Networking", "Sports", "Travel", "Utilities", "Video" , "Weather")
  
  appCategories <- rbind(appCategories, dataFrame)
}

