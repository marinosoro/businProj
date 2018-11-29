#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/

source("scripts/initProject.R", local = TRUE)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$rankingPerRevenueModelPlot <- renderPlotly({
    ratingPerRevenueModel(input$Category)
  })
  output$bestPrice <- renderText({
    getCategoryBestPrice(input$Category)
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
    getCategoryBestPrice(input$Category) %>% dollar()
  })
  output$categoryBestPrice2 <- renderText({
    getCategoryBestPrice(input$Category) %>% dollar()
  })
  output$categoryNonZeroPrice <- renderText({
    getCategoryBestPrice(input$Category, nonZero = T) %>% dollar()
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
  companyAppCurrentPrice <- reactive({
      (getCompanyAppByName(input$companyApp))$price
  })
  output$companyAppCurrentPrice <- renderText({
    companyAppCurrentPrice() %>% dollar()
  })
  companyAppCategoryBestPrice <- reactive({
      (getCompanyAppByName(input$companyApp))$primaryGenreId %>% getCategoryBestPriceById()
  })
  output$companyAppCategoryBestPrice <- renderText({
      companyAppCategoryBestPrice() %>% dollar()
  })
  output$companyAppPriceComparator <- renderText({
    if (companyAppCurrentPrice() == companyAppCategoryBestPrice()) {
        c(
            '<i class="fas fa-check"></i>'
        )
    } else {
        c(
            '<i class="fas fa-times"></i>'
        )
    }
  })
  categoryOptimalRevenueModel <- reactive({
      (revenueModels %>% filter(id == getSortedRevenueIdsForCategory(input$Category) %>% head(1)) %>% head(1))$description
  })
  output$categoryOptimalRevenueModel <- renderText({
      categoryOptimalRevenueModel()
  })
  output$companyAppCategory <- renderText({
      appCatId <- (getCompanyAppByName(input$companyApp))$primaryGenreId
      getCategoryNameById(appCatId)
  })
  companyAppOptimalRevenueModel <- reactive({
      appCategoryId <- (getCompanyAppByName(input$companyApp))$primaryGenreId
      appCategoryName <- getCategoryNameById(appCategoryId)
      (revenueModels %>% filter(id == getSortedRevenueIdsForCategory(appCategoryName) %>% head(1)) %>% head(1))$description
  })
  output$companyAppOptimalRevenueModel <- renderText({
      companyAppOptimalRevenueModel()
  })
  companyAppCurrentRevenueModel <- reactive({
      revenueId <- (getCompanyAppByName(input$companyApp))$revenueId
      (revenueModels %>% filter(id == revenueId) %>% head(1))$description
  })
  output$companyAppCurrentRevenueModel <- renderText({
      companyAppCurrentRevenueModel()
  })
  output$companyAppRevenueModelComparator <- renderText({
    if (companyAppCurrentRevenueModel() == companyAppOptimalRevenueModel()) {
        c(
            '<i class="fas fa-check"></i>'
        )
    } else {
        c(
            '<i class="fas fa-times"></i>'
        )
    }
  })
  output$categoryApplicationGrid <- renderText({
    generateApplicationGrid(input$Category)
  })
  output$categoryApplicationGridSecondary <- renderText({
      appList <- getCompanyAppsForCategory(input$Category, secondary = T)
      generateApplicationGrid(appList = appList)
  })
  output$categoryRankingTable <- DT::renderDataTable({
      categoryNameSlug <- str_replace(input$Category, pattern = ' ', replacement = '_')
      categoryNameSlug <- str_replace(categoryNameSlug, pattern = '& ', replacement = '')
      categoryDFName <- paste0("appleCategory_", categoryNameSlug)
      categoryDF <- get(categoryDFName, envir = .GlobalEnv)
      categoryDF %>% select(trackCensoredName) %>% datatable(colnames = c('Rank' = 1),
                                                             selection = "single",
                                                             options = list(ordering = F))
  })
  tweets <- reactive({
      getTweets(input$companyApp)
  })
  twitterGauge <- reactive({
      getGaugeChart(tweets())
  })
  output$twitterGaugeChart <- renderPlot({
      twitterGauge()
  })
  twitterWordCloud <- reactive({
      getWordcloud(tweets(), minFreq = 2, maxWords = 25)
  })
  output$twitterWordCloud <- renderPlot({
      twitterWordCloud()
  })

  outputOptions(output, "revenueModelComparisonPlots", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryBestPrice1", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryBestPrice2", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryNonZeroPrice", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppId", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppIcon", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppCurrentPrice", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppCategoryBestPrice", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppPriceComparator", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppOptimalRevenueModel", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppCurrentRevenueModel", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppRevenueModelComparator", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryOptimalRevenueModel", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryApplicationGrid", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryApplicationGridSecondary", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppCategory", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryRankingTable", suspendWhenHidden=FALSE)
  outputOptions(output, "twitterGaugeChart", suspendWhenHidden=FALSE)
  outputOptions(output, "twitterWordCloud", suspendWhenHidden=FALSE)

})
