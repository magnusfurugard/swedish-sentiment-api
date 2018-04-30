#* @apiTitle swedish-sentiment-api
#* @apiDescription https://github.com/magnusfurugard/swedish-sentiment-api

# Libs
library(SnowballC)
library(tictoc)
library(tidyverse)
library(jsonlite)

# Global objects. These are accessible in the API.
afinn165 = fromJSON("afinn165.json", simplifyDataFrame = T, flatten = T) %>% 
  as.tibble() %>% 
  t() %>% 
  as.data.frame() %>% 
  rownames_to_column(var = "word") %>% 
  rename(sentiment = V1)
spraakbanken = read_csv("sentimentlex.csv")

#' Lookup route.
#' @post /lookup
#' @param dictionary A string. Either `afinn165` or `spraakbanken`.
#' @param word A vector of words to get sentiments for.
function(req, word, dictionary) {
  # Log input.
  tic("Recieved")
  print(word)
  class(word)
  length(word)
  toc()
  
  # Build sentiment frame based on user selected lexicon.
  tic("Build sentiment lexion")
  if(dictionary == "afinn165") {
    print("running afinn165")
    swedish_sentiments = afinn165 %>% 
      mutate(stemmed_word = SnowballC::wordStem(.$word, language = "swedish")) %>% 
      rename(matched_word = word)
  } else if(dictionary == "spraakbanken") {
    print("running spraakbanken")
    swedish_sentiments = spraakbanken %>% 
      mutate(stemmed_word = SnowballC::wordStem(.$word, language = "swedish")) %>% 
      rename(matched_word = word)
  } else {
    return(list(error = "Unknown lexicon. Please use `afinn165` or `spraakbanken`."))
  }
  toc()
  
  # Parse input
  tic("Parsed")
  r = tibble(
    input_word = tolower(word)
  ) %>% 
    mutate(input_word = str_replace_all(input_word, "[\\W_]", ""), #remove non-alphabet chars
           stemmed_input = SnowballC::wordStem(.$input_word, language = "swedish")) %>% 
    left_join(swedish_sentiments, by = c("stemmed_input" = "stemmed_word")) %>% 
    select(-stemmed_input)
  toc()
  
  # Return df as json (plumber feature).
  return(r)
  
}

#' Default GET route.
#' @get /
function() {
  list(status="OK")
}

#' Raw data dump route.
#' @post /data
#' @param dictionary A string. Either `afinn165` or `spraakbanken`.
function(req, dictionary) {
  if(dictionary == "afinn165") {
    list(
      sentiment_source = "https://spraakbanken.gu.se/swe/resurs/sentimentlex", 
      data = spraakbanken
    )
  } else if(dictionary == "spraakbanken") {
    list(
      sentiment_source = "https://github.com/AlexGustafsson/sentiment-swedish", 
      data = afinn165
    )
  } else {
    list(error = "Unknown lexicon. Please use `afinn165` or `spraakbanken`.")
  }
}