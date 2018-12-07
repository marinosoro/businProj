categoryNames <- appleCategories$name

model1Indexes <- vector()
model2Indexes <- vector()
model3Indexes <- vector()
model4Indexes <- vector()
count1Vector <- vector()
count2Vector <- vector()
count3Vector <- vector()
count4Vector <- vector()

for (name in categoryNames) {
  slugName <- str_replace_all(name, " & ", "_")
  slugName <- str_replace_all(slugName, " ", "_")
  df <- paste0("appleCategory_", slugName)
  df <- get(df, envir = .GlobalEnv)
  
  model1Index <- model2Index <- model3Index <- model4Index <- 0
  count1 <- count2 <- count3 <- count4 <- 0
  allApps <- split(df, seq_len(nrow(df)))
  # Bereken index voor ieder revenueModel:"
  for (rank in 1:nrow(df)) {
    app <- allApps[[rank]]
    if (is.na(app$revenueId) || is.na(app$averageUserRating)) next
    inverseRank <- nrow(df) - rank + 1
    currentIndex <- get(paste0("model", app$revenueId, "Index"))
    newIndex <- currentIndex + (inverseRank * app$averageUserRating)
    assign(x = paste0("model", app$revenueId, "Index"), value = newIndex)
    currentCount <- get(paste0("count", app$revenueId))
    newCount <- currentCount + 1
    assign(x = paste0("count", app$revenueId), value = newCount)
  }
  # Normaliseren
  model1Index <- model1Index / count1
  model2Index <- model2Index / count2
  model3Index <- model3Index / count3
  model4Index <- model4Index / count4
  
  model1Indexes <- append(model1Indexes, model1Index)
  model2Indexes <- append(model2Indexes, model2Index)
  model3Indexes <- append(model3Indexes, model3Index)
  model4Indexes <- append(model4Indexes, model4Index)
  count1Vector <- append(count1Vector, count1)
  count2Vector <- append(count2Vector, count2)
  count3Vector <- append(count3Vector, count3)
  count4Vector <- append(count4Vector, count4)
  
}

categoryIndexes <- data.frame("name" = categoryNames, 
                              "index1" = model1Indexes, 
                              "index2" = model2Indexes, 
                              "index3" = model3Indexes, 
                              "index4" = model4Indexes,
                              "count1" = count1Vector,
                              "count2" = count2Vector,
                              "count3" = count3Vector,
                              "count4" = count4Vector)