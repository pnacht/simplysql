test_that("DBI::dbConnect() calls with named args and with valid `drv` succeed", {
  # fully namespaced call to `DBI::dbConnect`
  expr <- list(
    drv = quote(odbc::odbc()),
    UID = "mario"
  )

  expect_error(.validate_connection_args(expr), NA)
})

test_that("DBI::dbConnect() calls with unnamed args fail", {
  expr <- list(
    drv = quote(odbc::odbc()),
    "mario"
  )

  expect_error(.validate_connection_args(expr))
})

test_that("DBI::dbConnect() calls with unnamespaced `drv` fail", {
  expr <- list(
    drv = quote(odbc()),
    UID = "mario"
  )

  expect_error(.validate_connection_args(expr))
})

test_that("DBI::dbConnect() calls without drv arg fail", {
  expr <- list(
    UID = "mario"
  )

  expect_error(.validate_connection_args(expr))
})
