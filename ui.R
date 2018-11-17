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
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Our Dashboard"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    sidebarPanel(
      ## Content of the sidebar

    sliderInput("num1", h5("gewicht ratings met 0 tot 100 reviews (%)"),
                min = 1, max = 100, value = 10),
    sliderInput("num2", h5("gewicht ratings met 101 tot 1000 reviews (%)"),
                min = 1, max = 100, value = 40),
    sliderInput("num3", h5("gewicht ratings met 1.001 tot 10.000 reviews (%)"),
                min = 1, max = 100, value = 80),
    sliderInput("num4", h5("gewicht ratings met meer dan 10.000 reviews (%)"),
                min = 1, max = 100, value = 100)
    
    ),
    
    # Main panel for displaying outputs ----
    mainPanel(
      ## Content of the main panel
      plotlyOutput("plot")
    )
  )
))



