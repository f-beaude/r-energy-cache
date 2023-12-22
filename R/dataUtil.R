#' Generic data utility functions

#' Cached CSV reader function
#' @inherit utils::read.csv
#' @importFrom utils read.csv
#' @examples
#' read.csv.cached ()
#' @export
read.csv.cached <- cache.function (fun = utils::read.csv)

#' Cached Excel reader function
#' @inherit readxl::read_excel
#' @importFrom readxl read_excel
#' @examples
#' read.excel.cached (file = file.path("C:", "myExcelFile.xlsx"), sheet = "sheet1")
#' @export
read.excel.cached <- cache.function (fun = readxl::read_excel)
