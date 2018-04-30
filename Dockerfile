FROM rocker/tidyverse
MAINTAINER Magnus Furugård <magnus.furugard@gmail.com>

RUN apt-get update -qq && apt-get install -y \ 
    git-core \ 
    libssl-dev \ 
    libcurl4-gnutls-dev

COPY ./api/ /usr/local/src/swesent-api
WORKDIR /usr/local/src/swesent-api

RUN chmod 700 start.sh

RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('tictoc')"
RUN R -e "install.packages('SnowballC')"

# Port 8000 for local usage, not used on Heroku.
EXPOSE 8000

ENTRYPOINT ["/usr/local/src/swesent-api/start.sh"]
CMD ["plumber.R"]