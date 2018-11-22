library("twitteR")
library("NLP")
library("syuzhet")
library("tm")
library("SnowballC")
library("stringi")
library("topicmodels")
library("syuzhet")
library("ROAuth")
library("RColorBrewer")
library("wordcloud")
library("tm")

## function for getting tweets of appName
getTweets <- function(appName){
  x <- paste("'#", appName, sep="")
  y <- paste(x, "'", sep="")
  
  # Change the next four lines based on your own consumer_key, consume_secret, access_token, and access_secret. 
  consumer_key <- "WCC8jBuEIcUpRC734ROvG7l1t"
  consumer_secret <- "yj9vHCIEMnw4mMAiRRjS8calnjgLgNzx4sRs4acdnl0nm4X6WX"
  access_token <- "1060085268504604672-K3B05SUfDduX7OIsR8UjUIGOO7UUyc"
  access_secret <- "vhhGG7k7xpOLM5d9R3tLkkOpibKPLoGiiJ45UBki8U68l"
  
  setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)
  
  ## get tweets about appName
  tweets <- searchTwitter(y, n = 1000, lang = 'en')
  dataFrame_tweets <- twListToDF(tweets)
}

## function for getting wordcloud for appName
getWordcloud <- function(appName, minFreq, maxWords){
  dataFrame_tweets <- data.frame(getTweets(appName))
  ## getting wordcloud out of the tweets
  ### select text of tweets
  tweets_text<- dataFrame_tweets$text
  ### Replace blank space (“RT”)
  tweets_text <- gsub("RT", "", tweets_text)
  ### ??? deze werkte niet dus laat ik voorlopig weg XD
  ### convert all text to lower case
  tweets_text<- tolower(tweets_text)
  ### Replace @UserName
  tweets_text <- gsub("@\\w+", "", tweets_text)
  ### Remove punctuation
  tweets_text <- gsub("[[:punct:]]", "", tweets_text)
  ### Remove links
  tweets_text <- gsub("http\\w+", "", tweets_text)
  ### Remove tabs
  tweets_text <- gsub("[ |\t]{2,}", "", tweets_text)
  ### Remove blank spaces at the beginning
  tweets_text <- gsub("^ ", "", tweets_text)
  ### Remove blank spaces at the end
  tweets_text <- gsub(" $", "", tweets_text)
  ### clean up by removing stop words
  tweets_corp <- Corpus(VectorSource(tweets_text))
  tweets.text.corpus <- tm_map(tweets_corp, function(x)removeWords(x,stopwords()))
  ### generate wordcloud
  wordcloud(tweets.text.corpus,min.freq = minFreq,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = maxWords)
}


## gaugechart function
gaugeChart <- function(pos,breaks=c(0,30,70,100)) {
  require(ggplot2)
  get.poly <- function(a,b,r1=0.5,r2=1.0) {
    th.start <- pi*(1-a/100)
    th.end   <- pi*(1-b/100)
    th       <- seq(th.start,th.end,length=100)
    x        <- c(r1*cos(th),rev(r2*cos(th)))
    y        <- c(r1*sin(th),rev(r2*sin(th)))
    return(data.frame(x,y))
  }
  ggplot()+ 
    geom_polygon(data=get.poly(breaks[1],breaks[2]),aes(x,y),fill="red")+
    geom_polygon(data=get.poly(breaks[2],breaks[3]),aes(x,y),fill="gold")+
    geom_polygon(data=get.poly(breaks[3],breaks[4]),aes(x,y),fill="forestgreen")+
    geom_polygon(data=get.poly(pos-1,pos+1,0.2),aes(x,y))+
    geom_text(data=as.data.frame(breaks), size=5, fontface="bold", vjust=0,
              aes(x=1.1*cos(pi*(1-breaks/100)),y=1.1*sin(pi*(1-breaks/100)),label=paste0(breaks,"%")))+
    ggplot2::annotate("text",x=0,y=0,label=pos,vjust=0,size=8,fontface="bold")+
    coord_fixed()+
    theme_bw()+
    theme(axis.text=element_blank(),
          axis.title=element_blank(),
          axis.ticks=element_blank(),
          panel.grid=element_blank(),
          panel.border=element_blank()) 
}


## get gaugechart for appName
getGaugeChart <- function(appName){
  dataFrame_tweets <- data.frame(getTweets(appName))
  ### select text of tweets
  tweets_text<- dataFrame_tweets$text
  ### Replace blank space (“RT”)
  tweets_text <- gsub("RT", "", tweets_text)
  ### ??? deze werkte niet dus laat ik voorlopig weg XD
  ### convert all text to lower case
  tweets_text<- tolower(tweets_text)
  ### Replace @UserName
  tweets_text <- gsub("@\\w+", "", tweets_text)
  ### Remove punctuation
  tweets_text <- gsub("[[:punct:]]", "", tweets_text)
  ### Remove links
  tweets_text <- gsub("http\\w+", "", tweets_text)
  ### Remove tabs
  tweets_text <- gsub("[ |\t]{2,}", "", tweets_text)
  ### Remove blank spaces at the beginning
  tweets_text <- gsub("^ ", "", tweets_text)
  ### Remove blank spaces at the end
  tweets_text <- gsub(" $", "", tweets_text)
  
  ## getting sentiment 
  ### getting emotions using in-built function
  mysentiment_tweets<-get_nrc_sentiment((tweets_text))
  ### calculationg total score for each sentiment
  Sentimentscores_tweets<-data.frame(colSums(mysentiment_tweets[,]))
  names(Sentimentscores_tweets)<-"Score"
  Sentimentscores_tweets<-cbind("sentiment"=rownames(Sentimentscores_tweets),Sentimentscores_tweets)
  rownames(Sentimentscores_tweets)<-NULL
  
  negativeValue <- (Sentimentscores_tweets$Score[2] + Sentimentscores_tweets$Score[5] + 
                      Sentimentscores_tweets$Score[7] + Sentimentscores_tweets$Score[8] + 
                      Sentimentscores_tweets$Score[10])
  
  total <- (Sentimentscores_tweets$Score[1] + Sentimentscores_tweets$Score[2] + 
              Sentimentscores_tweets$Score[3] + Sentimentscores_tweets$Score[4] + 
              Sentimentscores_tweets$Score[5] + Sentimentscores_tweets$Score[6] + 
              Sentimentscores_tweets$Score[7] + Sentimentscores_tweets$Score[8] + 
              Sentimentscores_tweets$Score[9] + Sentimentscores_tweets$Score[10])
  
  Value <- round(((negativeValue/total)*100), digits = 2)
  gaugeChart(Value,breaks=c(0,30,70,100))
}


## top 5 retweeted tweets
getTopTweets <- function(appName, numberOfTweets){
  dataFrame_tweets <- data.frame(getTweets(appName))
  dataFrame_tweets <- filter(dataFrame_tweets, isRetweet == FALSE)
  dataFrame_tweets <- dataFrame_tweets %>% arrange(desc(retweetCount))
  dataFrame_tweets <- head(dataFrame_tweets, numberOfTweets)
  dataFrame_tweets <- select(dataFrame_tweets, text)
  ### select text of tweets
  tweets_text<- dataFrame_tweets$text
  ### Replace blank space (“RT”)
  tweets_text <- gsub("RT", "", tweets_text)
  ### terug in dataFrame zetten
  dataFrame_tweets <- data.frame(tweets_text)
}
  
dataFrame_tweets <- data.frame(getTopTweets("Facebook", 10))










