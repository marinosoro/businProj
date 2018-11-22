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
  appTextbox = selectInput("whichApp", 'Kies een gewenste app', 
                           choices = c("Facebook", "Temple Run", "Spotify Music") , selected = ""),
  

  revenueModelDistributionPlot = plotlyOutput("revenueModelDistributionPlot"),
  revenueModelPopularityPlot = plotlyOutput("revenueModelPopularityPlot"),
  revenueModelComparisonPlots = plotlyOutput("revenueModelComparisonPlots"),
  weightedRatingPlot = plotlyOutput("weightedRatingPlot"),
  summaryApp = tableOutput("summaryApp"),
  
  
  ratingApp = textOutput("ratingApp"),
  ratingAppAdvice = textOutput("ratingAppAdvice")
)

