#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/

source("./scripts/initProject.R")

if (!exists("databaseLoaded") || !databaseLoaded) {
  source(file = "./scripts/load_online_database.R")
}

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
  
  output$plot <- renderPlotly({
    p <-ggplot(data=filter(meanRatingGenreRevenue, category == input$select), aes(x=revenueId, y=meanRating)) +
      geom_bar(stat="identity")
    
    ggplotly(p)
  })
    
    
})
