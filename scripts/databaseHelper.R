library(RMySQL)


getDB <- function() {
  db <- dbConnect(MySQL(), user=Sys.getenv("dbuser"), password=Sys.getenv("dbpassword"), dbname=Sys.getenv("dbname"), host=Sys.getenv("dbhost"))
  return(db)
}

getDatabaseTable <- function(table) {
  db <- getDB()
  
  rs <- dbSendQuery(db, paste0("SELECT * FROM ", table))
  result <- fetch(rs, n=-1)
  dbClearResult(rs)
  
  dbDisconnect(db)
  return(result)
}

createTable <- function(name, dataframe) {
  db <- getDB()
  dbWriteTable(db, name, dataframe, overwrite = TRUE)
  dbDisconnect(db)
}

addToTable <- function(table, dataframe) {
  db <- getDB()
  dbWriteTable(db, table, dataframe, append = TRUE)
  dbDisconnect(db)
}


