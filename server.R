#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

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
  output$categoryBestPrice1 <- renderText({
    getCategoryBestPrice(input$Category)
  })
  output$categoryBestPrice2 <- renderText({
    getCategoryBestPrice(input$Category)
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

  outputOptions(output, "revenueModelComparisonPlots", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryBestPrice1", suspendWhenHidden=FALSE)
  outputOptions(output, "categoryBestPrice2", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppId", suspendWhenHidden=FALSE)
  outputOptions(output, "companyAppIcon", suspendWhenHidden=FALSE)

})
