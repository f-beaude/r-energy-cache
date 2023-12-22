testthat::context("Test data utilities")


testthat::test_that("Testing cached data reading", {

  # reading cached CSV file
  csvDataPath <- file.path("Assessment.csv")

  csv1 <- utils::read.csv(file = csvDataPath)
  csv2 <- eneRgycache::read.csv.cached(file = csvDataPath)
  csv3 <- eneRgycache::read.csv.cached(file = csvDataPath)

  # check that all files are identical
  testthat::expect_true (identical (csv1, csv2))
  testthat::expect_true (identical (csv1, csv3))

  # path to test Excel directory
  excelDataPath <- file.path("Flows.xlsx")

  xl1 <- readxl::read_excel(path = excelDataPath)
  xl2 <- eneRgycache::read.excel.cached(path = excelDataPath)
  xl3 <- eneRgycache::read.excel.cached(path = excelDataPath)

  # check that all files are identical
  testthat::expect_true (identical (xl1, xl2))
  testthat::expect_true (identical (xl1, xl3))
})
