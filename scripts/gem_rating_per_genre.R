# Code beetje aangepast, staat nu in functievorm.
# Gewichten zijn nu variabel en kunnen meegegeven worden aan de functie.
# Indien er geen gewichten worden voorgesteld worden de gewichten gebruikt die Siebe had ingevuld.
# Run deze code om de plot te zien: ggplotly(getWeightedRatingPlot())

getWeightedRatingPlot <- function(weights) {
  appleStore <- get("appleStore")
  ## lijst maken met gemiddelde rating per categorie en daarbij gewichten toekennen aan de hand van het aantal reviews.=======================
  countGenre <- appleStore %>% group_by(prime_genre) %>% summarise(freq = n())
  countGenre$prime_genre = as.character(countGenre$prime_genre)
  
  if (missing(weights)) {
    weights <- c(0.1, 0.4, 0.8, 1)
  }
  
  ##random varaibelen nodig voor de loops :p erik doe rustig worden op het einde fijn terug verwijdert :*
  i = 1
  n = 1
  z = 0.0
  value1 = value2 = value3 = value4 = 0
  avg_rating_with_weight <- data.frame(category = character(), weighted_avg = numeric(), stringsAsFactors = FALSE)
  
  ## percentage voor 0 tot 100 reviews:
  perc1 = weights[1]
  ## percentage voor 101 tot 1000 reviews:
  perc2 = weights[2]
  ## percentage voor 1001 tot 10000 reviews:
  perc3 = weights[3]
  ## percentage voor meer als 10000 reviews:
  perc4 = weights[4]
  
  for(i in 1:23){
    y <- filter(appleStore, prime_genre == countGenre$prime_genre[i])
    for(n in 1:countGenre$freq[i]){
      if (appleStore$rating_count_tot[i] < 100){
        z = z + perc1*y$user_rating[n]
        n = n + 1
        value1 = value1 + 1
      }
      if (appleStore$rating_count_tot[i] < 1000){
        z = z + perc2*y$user_rating[n]
        n = n + 1
        value2 = value2 + 1
      }
      if (appleStore$rating_count_tot[i] < 10000){
        z = z + perc3*y$user_rating[n]
        n = n + 1
        value3 = value3 + 1
      }
      else
        z = z + perc4*y$user_rating[n]
      n = n + 1
      value4 = value4 + 1
    }
    z = z/(countGenre$freq[i] - value1 - value2 - value3 - value4 + (perc1*value1 + perc2*value2 + perc3*value3 + perc4*value4))
    avg_rating_with_weight[nrow(avg_rating_with_weight) + 1,] = list(countGenre$prime_genre[i], z)
    i = i + 1
    n = 1
    z = 0.0
    value1 = value2 = value3 = value4 = 0
  }
  
  p <-ggplot(data=avg_rating_with_weight, aes(x=category, y=weighted_avg)) +
    geom_bar(stat="identity") + coord_flip()
  
  return(p)
}

