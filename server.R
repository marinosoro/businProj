#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$helloWorld <- renderText({
    "Hello World"
  })
  
  output$Category_output <- renderPlotly({
    googlePlayStore %>% group_by(Category) %>% ggplot(aes(Category)) + geom_bar() + coord_flip() -> g
    ggplotly(g) 
  })  
  

  source("./scripts/initProject.R", local = TRUE)

  if (!exists("databaseLoaded") || !databaseLoaded) {
    source(file = "./scripts/load_online_database.R", local = TRUE)
  }

  output$rankingPerRevenueModelPlot <- renderPlotly({
    ratingPerRevenueModel(input$Category)
  })
  output$weightedRatingPlot <- renderPlotly({
    ggplotly(getWeightedRatingPlot())
  })
  output$revenueModelDistributionPlot <- renderPlotly({
    amountRevenueModelPieChart(appleCategory_Games)
  })
  output$revenueModelPopularityPlot <- renderPlotly({
    weightedRevenueModelPieChart(appleCategory_Games)
  })
  output$revenueModelComparisonPlots <- renderPlotly({
    revenueModelComparisonPlots(input$Category)
  })
  output$summaryApp <- renderTable({
    appSearchedFunction(input$whichApp)
  })
  output$ratingApp <- renderText(
    ratingAppFunction(input$whichApp)
  )
  output$ratingAppAdvice <- renderText(
    ratingAppAdviceFunction(input$whichApp)
  )
  output$categoryBestPrice1 <- renderText({
    getCategoryBestPrice(input$Category)
  })
  output$categoryBestPrice2 <- renderText({
    getCategoryBestPrice(input$Category)
  })
  output$categoryNonZeroPrice <- renderText({
    getCategoryBestPrice(input$Category, nonZero = T)
  })
  output$companyAppId <- renderText({
    (getCompanyApps() %>% filter(trackCensoredName == input$companyApp))$id
  })
  output$companyAppIcon <- renderText({
    c(
        '<img id="companyAppIcon" src="',
        (getCompanyApps() %>% filter(trackCensoredName == input$companyApp))$id %>% getAppIcon(),
        '">'
    )
  })
  output$companyAppCurrentPrice <- renderText({
    (getCompanyAppByName(input$companyApp))$formattedPrice
  })
  output$companyAppCategoryBestPrice <- renderText({
    (getCompanyAppByName(input$companyApp))$primaryGenreId %>% getCategoryBestPriceById()
  })
  
  outputOptions(output, "revenueModelComparisonPlots", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryBestPrice1", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryBestPrice2", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryNonZeroPrice", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppId", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppIcon", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppCurrentPrice", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppCategoryBestPrice", suspendWhenHidden=FALSE)
  
  
})
