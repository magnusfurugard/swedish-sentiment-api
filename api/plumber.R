## api/plumber.R

# Libs
library(SnowballC)
library(tictoc)
library(tidyverse)

# Global objects. These are accessible in the API.
dataset = read_csv("sentimentlex.csv")
swedish_sentiments = dataset %>% 
  mutate(stemmed_word = SnowballC::wordStem(.$word, language = "swedish")) %>% 
  rename(matched_word = word)

#' Lookup route.
#' @post /lookup
#' @param word A vector of words to get sentiments for.
function(req, word) {
  # Log input.
  tic("Recieved")
  print(word)
  class(word)
  length(word)
  toc()
  
  # Parse input
  tic("Parsed")
  r = tibble(
    input_word = tolower(word)
  ) %>% 
    mutate(stemmed_input = SnowballC::wordStem(.$input_word, language = "swedish")) %>% 
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
#' @get /data
function(req) {
  list(
    sentiment_source = "https://spraakbanken.gu.se/swe/resurs/sentimentlex", 
    data = dataset
  )
}