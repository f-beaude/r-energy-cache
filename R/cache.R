#' Manage cache in order to avoid conducting the same calculation multiple times

pkg.env <- new.env()
pkg.env$cache.directory <- NULL

#' Set the cache directory
#' @param directory the directory in which to store the cache (if NULL, will set it to default)
#' @export
set.cache.directory <- function (directory = NULL) {
  myDir <- directory
  if (is.null (myDir)) {
    myDir <- file.path(tempdir(), "cache")
  }
  pkg.env$cache.directory <- myDir
  # }
  # options("cache-directory"=cacheDir)
}

#' Check whether the cache directory has been set
#' @return whether the cache directory has already been set
cache.directory.set <- function() {
  return(! is.null (pkg.env$cache.directory))
}

#' Retrieve the directory in which to store cached data
#'
#' @return the directory as a file.path
#' @examples
#' cache.directory()
#' @export
cache.directory <- function() {
  if (! cache.directory.set()) {
    eneRgycache::set.cache.directory()
  }

  return(pkg.env$cache.directory)
}

#' Check whether the cache has already been initialised
#'
#' @return whether the cache has already been initialised
#' @examples
#' cache.initialised()
#' @export
cache.initialised <- function() {
  if (! cache.directory.set()) {
    return (FALSE)
  }

  return(dir.exists(cache.directory()))
}

#' Initialise the directory in which to store cached data
#' (includes clearing cache data in the temporary cache directory)
#'
#' @importFrom R.cache setCacheRootPath
#' @examples
#' initialise.cache()
#' @export
initialise.cache <- function() {
  # cache already initialised -> nothing to do
  if (eneRgycache::cache.initialised()) {
    return()
  }

  current.cache.directory <- cache.directory()

  if (! dir.exists(current.cache.directory)) {
    dir.create(current.cache.directory)
  }

  eneRgycache::clear.cache()
  R.cache::setCacheRootPath(path = current.cache.directory)
}


#' Clear the cache
#'
#' @importFrom utils capture.output
#' @examples
#' clear.cache()
#' @export
clear.cache <- function() {
  current.cache.directory <- cache.directory()

  # hide messages sent by file.remove (only show warnings)
  invisible (utils::capture.output (do.call(file.remove, list(list.files(path = current.cache.directory, full.names = TRUE)))))
}

#' Evaluate a cached function
#'
#' @param fun the function to evaluate
#' @param ... further arguments for the memoized call
#' @return the function value
#' @importFrom R.cache memoizedCall
#' @examples
#' eval.cache (world())
#' eval.cache (myFun, x = 1, y = 2)
#' @export
eval.cache <- function(fun, ...) {
  stopifnot(eneRgycache::cache.initialised())
  return (R.cache::memoizedCall (fun, ...))
}

#' Define a function which relies on cache
#'
#' @param fun the function for which to rely on cache
#' @param ... further arguments for the memoization
#' @return the cached function as a function
#' @importFrom R.cache addMemoization
#' @examples
#' my.function <- function () {return (5)}
#' my.function.cached <- cache.function (my.function)
#' @export
cache.function <- function(fun, ...) {
  return (R.cache::addMemoization (fcn = fun, ...))
}
