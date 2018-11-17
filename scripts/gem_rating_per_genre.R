
weightedMean <- function(p1 = integer(),p2 = integer(),p3 = integer(),p4 = integer()){

  ## lijst maken met gemiddelde rating per categorie en daarbij gewichten toekennen aan de hand van het aantal reviews.=======================
  countGenre <- count(appleStore, prime_genre)
  
  ##random varaibelen nodig voor de loops :p erik doe rustig worden op het einde fijn terug verwijdert :*
  i = 1
  p = 1
  z = z1 = z2 = z3 = z4 = 0.0
  perc1 = perc2 = perc3 = perc4 = 0
  value1 = value2 = value3 = value4 = 0.000001
  avg_rating_with_weight <- data.frame(category = character(), weighted_avg = numeric(), stringsAsFactors = FALSE)
  
  ## percentage voor 0 tot 100 reviews:
  perc1 = 0.1
  ## percentage voor 101 tot 1000 reviews:
  perc2 = 0.4
  ## percentage voor 1001 tot 10000 reviews:
  perc3 = 0.8
  ## percentage voor meer als 10000 reviews:
  perc4 = 1.0
  
  for(i in 1:23){
    y <- filter(appleStore, prime_genre == countGenre$prime_genre[i])
    for(p in 1:countGenre$n[i]){
      if (appleStore$rating_count_tot[i] < 100){
        z1 = (z1 + perc1*y$user_rating[p])
        p = p + 1
        value1 = (value1 + 1*perc1)
      }
      else if (appleStore$rating_count_tot[i] < 1000){
        z2 = (z2 + perc2*y$user_rating[p])
        p = p + 1
        value2 = (valua2 + 1*perc2)
      }
      else if (appleStore$rating_count_tot[i] < 10000){
        z3 = (z3 + perc3*y$user_rating[p])
        p = p + 1
        value3 = (value3 + 1*perc3)
      }
      else {
        z4 = (z4 + perc4*y$user_rating[p])
        p = p + 1
        value4 = (value4 + 1*perc4)
      }
    }
    z = ((z1 + z2 + z3 + z4)/(value1 + value2 + value3 + value4))
    avg_rating_with_weight[nrow(avg_rating_with_weight) + 1,] = list(countGenre$prime_genre[i], z)
    i = i + 1
    p = 1
    z = z1 = z2 = z3 = z4 = 0.0
    value1 = value2 = value3 = value4 = 0.000001
  }
  
  ## verwijderen van gebruikte variabelen die niet meer nodig zijn na de bewerking:
  remove(value1, value2, value3, value4, i, y, p, z, z1, z2, z3, z4, perc1, perc2, perc3, perc4, countGenre)
  
  ## een bar chart per categorie met de gemiddelde rating rekenig houdend met de gewichten op basis van het aantal reviews:
  p <-ggplot(data=avg_rating_with_weight, aes(x=category, y=weighted_avg)) +
    geom_bar(stat="identity") + coord_flip()
  
  ggplotly(p)
  
  ##einde ==============================================================================================================================
  
  
}

