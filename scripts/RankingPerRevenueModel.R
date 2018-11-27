ratingPerRevenueModel <- function(categoryName) {
  categoryNameSlug <- str_replace(categoryName, pattern = ' ', replacement = '_')
  categoryNameSlug <- str_replace(categoryNameSlug, pattern = '& ', replacement = '')
  
  categoryDFName <- paste0("appleCategory_", categoryNameSlug)
  categoryDF <- get(categoryDFName, envir = .GlobalEnv)
  model1Index <- model2Index <- model3Index <- model4Index <- 0
  count1 <- count2 <- count3 <- count4 <- 0
  allApps <- split(categoryDF, seq_len(nrow(categoryDF)))
  # Bereken index voor ieder revenueModel:"
  for (rank in 1:nrow(categoryDF)) {
    app <- allApps[[rank]]
    if (is.na(app$revenueId)) next
    inverseRank <- nrow(categoryDF) - rank + 1
    currentIndex <- get(paste0("model", app$revenueId, "Index"))
    newIndex <- currentIndex + (inverseRank * 1)
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
  
  indexes <- c(model1Index, model2Index, model3Index, model4Index)
  
  model1Percentage <- model1Index / sum(model1Index, model2Index, model3Index, model4Index)
  model2Percentage <- model2Index / sum(model1Index, model2Index, model3Index, model4Index)
  model3Percentage <- model3Index / sum(model1Index, model2Index, model3Index, model4Index)
  model4Percentage <- model4Index / sum(model1Index, model2Index, model3Index, model4Index)
  
  percentages <- c(model1Percentage, model2Percentage, model3Percentage, model4Percentage)
<<<<<<< HEAD
  data <- data.frame(revenueModel = c('Paid','Free','Paid, iAP','Free, iAP'),
=======
  data <- data.frame(revenueModel = c('Model 1','Model 2','Model 3','Model 4'),
>>>>>>> d0acdf0e2db834e3c000d54ff81c7a6edc6aa5f6
                     ratingOfRanking = percentages)
  

  ## een bar chart per categorie met de ranking score:
<<<<<<< HEAD
  colors = c("#3c6372", "#E16768", "#d62f30", "#144b7f")
  
  plot_ly(data = data,
    x = ~revenueModel,
    y = ~ratingOfRanking,
    mode = "markers",
    marker = list(color = colors),
    type = "bar"
  ) %>%
  layout(title = "Mean Ranking??",
         plot_bgcolor='transparent',
         paper_bgcolor='transparent',
         showlegend = F)
=======
  p <-ggplot(data, aes(x=revenueModel, y=ratingOfRanking)) +
  geom_bar(stat="identity")

  ggplotly(p)

>>>>>>> d0acdf0e2db834e3c000d54ff81c7a6edc6aa5f6
}


