# swedish-sentiment-api
An open source sentiment lookup API for Swedish words. Built in R with `tidyverse` and `plumber`. Automatically stems any provided words to increase lookup accuracy.

Hosted on a free instance on Heroku: [https://swedish-sentiment-api.herokuapp.com](https://swedish-sentiment-api.herokuapp.com). Since it's in the free tier, if left unused the initial call will take an additional 15-20 seconds (to start up the app).

## Routes
### GET /
This route is simply to see if the Heroku build is working. It should return a json-body with `status=OK`.

### POST /lookup
Requires parameter `dictionary`: Accepted values are either `afinn165` or `spraakbanken`.

Requires parameter `word`: a vector of any length containing the words you need sentiments for.

Example json-body: `{"word":["hallå", "världen"], "dictionary":"afinn165"}`

### POST /data
Requires parameter `dictionary`: Accepted values are either `afinn165` or `spraakbanken`.

A raw dump of all the underlying data for the API, including data source.

## Files
### Dockerfile
Dockerfile is based of the `rocker/tidyverse` image with some additional packages and settings.

### api/plumber.R
Main file, including all routes and logic for lookup.

### api/run_local.R
To be used for local testing.

### api/start.sh
Entrypoint-file for Docker. Runs the API with Heroku-provided portnumber, or `port=8000` if running locally.

### api/sentimentlex.csv
Raw data file.
