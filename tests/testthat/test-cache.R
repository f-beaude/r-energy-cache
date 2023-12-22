testthat::context("Test cache management")

testthat::test_that("Cached functions", {

  testthat::expect_false (eneRgycache::cache.initialised())

  testFun <- function (x) {
    return (x + 5)
  }

  testFun.cached <- eneRgycache::cache.function(fun = testFun)

  # error : cache not initialised yet
  testthat::expect_false (eneRgycache::cache.initialised())
  testthat::expect_error (testFun.cached(x = 0))

  testthat::expect_true ({eneRgycache::initialise.cache(); TRUE})
  testthat::expect_true (eneRgycache::cache.initialised())

  # nothing should happen, because the cache has already been initialised
  testthat::expect_true ({eneRgycache::initialise.cache(); TRUE})

  testthat::expect_true ({testFun.cached(x = 0); TRUE})
  testthat::expect_equal (testFun.cached(x = 0), testFun(x = 0))

  val1 <- testFun.cached(x = 0)
  val2 <- testFun.cached(x = 0)
  val3 <- testFun(x = 0)
  testthat::expect_equal (val1, val2)
  testthat::expect_equal (val1, val3)

  val4 <- testFun.cached(x = 3.1)
  val5 <- testFun.cached(x = 3.1)
  val6 <- testFun(x = 3.1)
  testthat::expect_equal (val4, val5)
  testthat::expect_equal (val4, val6)

  testthat::expect_false (identical(val1, val4))

  testthat::expect_true({eneRgycache::clear.cache(); TRUE})
  testthat::expect_equal(eneRgycache::clear.cache(), "logical(0)")
  # clearing the cache should not lead to deinitialise the cache
  testthat::expect_true (eneRgycache::cache.initialised())
})

test_that("Cached function calls", {

  testFun <- function (x) {
    return (x + 5)
  }

  eneRgycache::initialise.cache()

  valNonCached <- testFun (x = -15)
  valCached1 <- eneRgycache::eval.cache(fun = testFun, x = -15)
  valCached2 <- eneRgycache::eval.cache(fun = testFun, x = -15)

  testthat::expect_equal (valNonCached, valCached1)
  testthat::expect_equal (valNonCached, valCached2)
})
