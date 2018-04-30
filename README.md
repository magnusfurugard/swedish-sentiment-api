# swedish-sentiment-api
An open source sentiment lookup API for Swedish.

# Routes
## GET /info
This route is simply to see if the Heroku build is working. It should return a json-body with `status=OK`.

## PUSH /lookup
### parameter `word`: a vector of any length containing the words you want to lookup.
