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
    ggplotly(ggplot(data=GenreRating, aes(x=prime_genre, y=user_rating)) +
    geom_bar(stat="identity") + coord_flip(), tooltip = c("y"))
    
  })

  output$helloWorld <- renderText({
    "Hello World"
  
  output$Category <- renderPlot({
    googlePlayStore %>% group_by(Category) %>% ggplot(aes(Category)) + geom_bar() + coord_flip() -> g
    ggplotly(g)
  })  
    
    })
})
