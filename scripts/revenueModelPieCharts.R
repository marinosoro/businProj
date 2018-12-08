revenueModelComparisonPlots <- function(categoryName) {
  categoryIndexes <- get("categoryIndexes", env = .GlobalEnv)
  categoryIndex <- categoryIndexes %>% filter(name == categoryName)

  model1Index = categoryIndex$index1
  model2Index = categoryIndex$index2
  model3Index = categoryIndex$index3
  model4Index = categoryIndex$index4

  model1Percentage <- model1Index / sum(model1Index, model2Index, model3Index, model4Index)
  model2Percentage <- model2Index / sum(model1Index, model2Index, model3Index, model4Index)
  model3Percentage <- model3Index / sum(model1Index, model2Index, model3Index, model4Index)
  model4Percentage <- model4Index / sum(model1Index, model2Index, model3Index, model4Index)

  indexes <- c(model1Index, model2Index, model3Index, model4Index)

  count1 <- categoryIndex$count1
  count2 <- categoryIndex$count2
  count3 <- categoryIndex$count3
  count4 <- categoryIndex$count4

  percentages <- c(model1Percentage, model2Percentage, model3Percentage, model4Percentage)
  data <- data.frame(index = indexes,
                     count = c(count1, count2, count3, count4),
                     percentage = percentages,
                     revenueModel = c('Paid','Free','Paid, iAP','Free, iAP'),
                     colorlabel = c('m1', 'm2', 'm3', 'm4'))

  plot_ly() %>%
    add_pie(
      data = data,
      hole = 0.5,
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
      hole = 0.5,
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
           showlegend = F)
}
