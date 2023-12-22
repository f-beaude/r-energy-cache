library(microbenchmark)
library(R.cache)
library(simpleRCache)

# Comparing the performances of various caching packages
nb.runs <- 1000

a_function <- function(y) {
  for (x in 0:10){
    y <- y + x
  }
  return (y)
}


R.cache::setCacheRootPath(file.path(tempdir(), "R_cache"))
a_function_Rcache <- R.cache::addMemoization(a_function)
microbenchmark::microbenchmark(a_function_Rcache(50), times = nb.runs)


simpleRCache::setCacheRootPath(file.path(tempdir(), "simple_R_cache"))
a_function_simpleRcache <- simpleRCache::addMemoization(a_function)
microbenchmark::microbenchmark(a_function_simpleRcache(50), times = nb.runs)
