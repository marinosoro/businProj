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

    # Application title
  titlePanel("Our Dashboard"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    sidebarPanel(
      
      ## Content of the sidebar

      selectInput("category", "Kies gewenste categorie",
                  choices = appleStore$prime_genre
      ),



   selectInput("Category", 'Kies een gewenste categorie',
               choices = googlePlayStore$Category)
    )),

    
    # Main panel for displaying outputs ----
    mainPanel(
      ## Content of the main panel


      h1(textOutput("helloWorld")),
      plotlyOutput("g"),
      tableOutput("Test"),
      plotlyOutput("plot"),
      textInput("text", h3("Text input"), value = "Enter text..."),  


      plotlyOutput("plot"),
      textInput("text", h3("Text input"), value = "Enter text..."),




  revenueModelDistributionPlot = plotlyOutput("revenueModelDistributionPlot"),
  revenueModelPopularityPlot = plotlyOutput("revenueModelPopularityPlot"),
  revenueModelComparisonPlots = plotlyOutput("revenueModelComparisonPlots"),
  weightedRatingPlot = plotlyOutput("weightedRatingPlot")
)


