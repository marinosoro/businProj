# Eerst runnen jullie de code die voorzien is onder jullie naam.
# Dit zal waarschijnlijk tot smorgens duren dus pls laat uw computer aan staan :p
# Morgen kunnen jullie dan voor die dataframes die jullie gescraped hebben 
# controleren of er een nieuwe kolom "hasInAppPurchases" is bijgekomen met waardes 0 en 1 (en NA af en toe)
# Als dat in orde is kunnen jullie per dataframe volgende code uitvoeren

##### createTable("dataframeName", dataframe)

# Dat zorgt er dan voor dat deze tabel ook in de online database wordt opgeslagen met alle relevante data ;) 


# Mathias
for (df in c("appleCategory_Book", 
             "appleCategory_Catalogs", 
             "appleCategory_Education",
             "appleCategory_Entertainment",
             "appleCategory_Finance"
)) {
  
  startScrape(categoryDF = get(df), variableToStore = df)
}

# Siebe
for (df in c("appleCategory_Food_Drink", 
             "appleCategory_Health_Fitness", 
             "appleCategory_Lifestyle",
             "appleCategory_Magazines_Newspapers",
             "appleCategory_Medical"
)) {
  
  startScrape(categoryDF = get(df), variableToStore = df)
}

# Stef
for (df in c("appleCategory_Music",
             "appleCategory_Navigation",
             "appleCategory_News",
             "appleCategory_Photo_Video",
             "appleCategory_Productivity"
)) {
  
  startScrape(categoryDF = get(df), variableToStore = df)
}

# Hanne
for (df in c("appleCategory_Reference",
             "appleCategory_Social_Networking",
             "appleCategory_Sports",
             "appleCategory_Travel",
             "appleCategory_Utilities"
)) {
  
  startScrape(categoryDF = get(df), variableToStore = df)
}

# Marino
for (df in c("appleCategory_Weather",
             "appleCategory_Shopping",
             "appleCategory_Stickers"
)) {
  
  startScrape(categoryDF = get(df), variableToStore = df)
}