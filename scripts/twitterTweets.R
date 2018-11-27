library("twitteR")
library("NLP")
library("syuzhet")
library("tm")
library("SnowballC")
library("stringi")
library("topicmodels")
library("syuzhet")
library("twitteR")
library("ROAuth")
library("RColorBrewer")
library("wordcloud")
library("tm")

# Change the next four lines based on your own consumer_key, consume_secret, access_token, and access_secret. 
consumer_key <- "WCC8jBuEIcUpRC734ROvG7l1t"
consumer_secret <- "yj9vHCIEMnw4mMAiRRjS8calnjgLgNzx4sRs4acdnl0nm4X6WX"
access_token <- "1060085268504604672-K3B05SUfDduX7OIsR8UjUIGOO7UUyc"
access_secret <- "vhhGG7k7xpOLM5d9R3tLkkOpibKPLoGiiJ45UBki8U68l"

setup_twitter_oauth(consumer_key, consumer_secret, access_token, access_secret)

## get tweets about fortnite
tweets = twitteR::searchTwitter('#Fortnite', n = 5000, since = '2018-11-11', lang = 'en')
dataFrame_tweets = twitteR::twListToDF(tweets)



## getting wordcloud out of the tweets
### select text of tweets
tweets_text<- dataFrame_tweets$text
### convert all text to lower case
tweets_text<- tolower(tweets_text)
### Replace @UserName
tweets_text <- gsub("@\\w+", "", tweets_text)
### Remove punctuation
tweets_text <- gsub("[[:punct:]]", "", tweets_text)
### Replace blank space (“rt”)
### tweets_text <- gsub("rt", "", tweets_text)
### ??? deze werkte niet dus laat ik voorlopig weg XD
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
wordcloud(tweets.text.corpus,min.freq = 10,colors=brewer.pal(8, "Dark2"),random.color = TRUE,max.words = 100)



## getting sentiment 
### getting emotions using in-built function
mysentiment_tweets<-get_nrc_sentiment((tweets_text))
### calculationg total score for each sentiment
Sentimentscores_tweets<-data.frame(colSums(mysentiment_tweets[,]))
names(Sentimentscores_tweets)<-"Score"
Sentimentscores_tweets<-cbind("sentiment"=rownames(Sentimentscores_tweets),Sentimentscores_tweets)
rownames(Sentimentscores_tweets)<-NULL
#plotting the sentiments with scores
ggplot(data=Sentimentscores_tweets,aes(x=sentiment,y=Score))+geom_bar(aes(fill=sentiment),stat = "identity")+
  theme(legend.position="none")+
  xlab("Sentiments")+ylab("scores")+ggtitle("Sentiments of people behind the tweets on fortnite")









