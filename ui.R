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
  categoryDropdown = selectInput("Category", 'Kies een gewenste categorie',
                         choices = appleCategories$name, selected = "Games"),
  

  revenueModelDistributionPlot = plotlyOutput("revenueModelDistributionPlot"),
  revenueModelPopularityPlot = plotlyOutput("revenueModelPopularityPlot"),
  revenueModelComparisonPlots = plotlyOutput("revenueModelComparisonPlots"),
  weightedRatingPlot = plotlyOutput("weightedRatingPlot"),
  plot2 = plotlyOutput("plot2"),
  bestPrice = textOutput("bestPrice")
  
)


