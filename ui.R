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
      # Marino
    ),
    
    #Stef
    
    # Main panel for displaying outputs ----
    mainPanel(
      ## Content of the main panel
      h1(textOutput("helloWorld"))
      
    )
  )
  
))
