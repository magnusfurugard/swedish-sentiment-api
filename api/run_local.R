library(plumber)
p = plumb("plumber.R")
p$run(port = 8000, swagger = T)
