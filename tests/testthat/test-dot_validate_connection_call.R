test_that("Calls to namespaced DBI::dbConnect() succeed", {
  expr <- quote(DBI::dbConnect(
    drv = odbc::odbc(),
    UID = "mario"
  ))

  expect_error(.validate_connection_call(expr), NA)
})

test_that("Calls to unnamespaced dbConnect() fail", {
  expr <- quote(dbConnect(
    drv = odbc::odbc(),
    UID = "mario"
  ))

  expect_error(.validate_connection_call(expr))

  # even with DBI loaded
  library(DBI)
  expr <- quote(dbConnect(
    drv = odbc::odbc(),
    UID = "mario"
  ))

  expect_error(.validate_connection_call(expr))
})

test_that("Calls to functions other than DBI::dbConnect() fail", {
  expr <- quote(paste(
    drv = odbc::odbc(),
    UID = "mario"
  ))

  expect_error(.validate_connection_call(expr))
})
