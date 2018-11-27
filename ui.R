#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
htmlTemplate("template.html",
    categoryDropdown = selectInput("Category",
                         label = NULL,
                         choices = appleCategories$name,
                         selected = "Games",
                         selectize=TRUE),
    companyDropdown = selectInput("companyApp",
                                  label = NULL,
                                  choices = getCompanyApps() %>% select(trackCensoredName),
                                  selectize = TRUE),
    revenueModelDistributionPlot = plotlyOutput("revenueModelDistributionPlot"),
    revenueModelPopularityPlot = plotlyOutput("revenueModelPopularityPlot"),
    revenueModelComparisonPlots = plotlyOutput("revenueModelComparisonPlots"),
    weightedRatingPlot = plotlyOutput("weightedRatingPlot"),
    rankingPerRevenueModelPlot = plotlyOutput("rankingPerRevenueModelPlot"),
    categoryBestPrice1 = textOutput("categoryBestPrice1"),
    categoryBestPrice2 = textOutput("categoryBestPrice2"),
    categoryNonZeroPrice = textOutput("categoryNonZeroPrice"),
    companyAppCurrentPrice = textOutput("companyAppCurrentPrice"),
    companyAppId = textOutput("companyAppId"),
    companyAppIcon = htmlOutput("companyAppIcon"),
    companyAppCategoryBestPrice = textOutput("companyAppCategoryBestPrice"),


    ratingApp = textOutput("ratingApp"),
    ratingAppAdvice = textOutput("ratingAppAdvice")

)
