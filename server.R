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
  
  output$helloWorld <- renderText({

    "Hello World"
    })

   
  
  output$Category <- renderPlot({
    googlePlayStore %>% group_by(Category) %>% ggplot(aes(Category)) + geom_bar() + coord_flip() -> g
    ggplotly(g)
  })  
    
  
  output$g <- renderPlotly({
    appleStore %>% group_by(prime_genre) %>% ggplot(aes(x=prime_genre)) + xlab("Categorieën") + ylab("Aantal") + geom_bar() + coord_flip()
    ggplotly(g)
  })
  
  output$Test <- renderTable({
    ddply(appleStore, .(prime_genre), summarize, user_rating=mean(user_rating), price=mean(price), rating_count_tot=mean(rating_count_tot))
  filter(Test, prime_genre == input$category)
  
  
})
})





