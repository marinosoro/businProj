revenueModelComparisonPlots <- function(categoryName) {
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
  
  indexes <- c(model1Index, model2Index, model3Index, model4Index)
  
  model1Percentage <- model1Index / sum(model1Index, model2Index, model3Index, model4Index)
  model2Percentage <- model2Index / sum(model1Index, model2Index, model3Index, model4Index)
  model3Percentage <- model3Index / sum(model1Index, model2Index, model3Index, model4Index)
  model4Percentage <- model4Index / sum(model1Index, model2Index, model3Index, model4Index)
  
  percentages <- c(model1Percentage, model2Percentage, model3Percentage, model4Percentage)
  data <- data.frame(index = indexes, 
                     count = c(count1, count2, count3, count4),
                     percentage = percentages, 
                     revenueModel = c('Paid','Free','Paid, iAP','Free, iAP'),
                     colorlabel = c('m1', 'm2', 'm3', 'm4'))
  
  plot_ly() %>% 
    add_pie(
      data = data,
      labels = ~revenueModel,
      values = ~count,
      name = 'Distribution',
      textposition = 'inside', 
      textinfo = 'label+percent',
      insidetextfont = list(color = '#FFFFFF'),
      marker = list(line = list(color = '#FFFFFF', width = 3),
                    colors = c("#3c6372", "#E16768", "#d62f30", "#144b7f")),
      domain = list(x = c(0, 0.5), y = c(0, 1))) %>%
    
    add_pie(
      data = data,
      labels = ~revenueModel,
      values = ~index,
      name = 'Popularity',
      textposition = 'inside', 
      textinfo = 'label+percent',
      insidetextfont = list(color = '#FFFFFF'),
      marker = list(line = list(color = '#FFFFFF', width = 3)),
      domain = list(x = c(0.5, 1), y = c(0, 1))) %>%
    
    layout(title = "Distribution vs Popularity of apps within revenue models:",
           xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
           plot_bgcolor='transparent',
           paper_bgcolor='transparent',
           showlegend = T)
}