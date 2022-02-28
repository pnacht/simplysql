mock_input <- function(x) {
  m <- do.call(mockery::mock, x)

  mockery::stub(.read_connection_expr, "readline", m)

  return(suppressMessages(.read_connection_expr()))
}

test_that("Valid calls with all named arguments are accepted", {
  input <- list(
    "DBI::dbConnect(",
    "drv      = odbc::odbc(),",
    "Driver   = \"SQL Server\",",
    "Port     = 1433)"
  )

  expect_identical(mock_input(input), quote(
    DBI::dbConnect(
      drv    = odbc::odbc(),
      Driver = "SQL Server",
      Port   = 1433
    )
  ))
})

test_that("Invalid calls or expressions fail", {
  input <- list(  # no closing parenthesis
    "DBI::dbConnect(",
    "drv      = odbc::odbc(),",
    "Driver   = \"SQL Server\",",
    "Port     = 1433"
  )

  expect_error(mock_input(input))

  input <- list(  # expression, not simple call
    "DBI::dbConnect(",
    "drv      = odbc::odbc(),",
    "Driver   = \"SQL Server\",",
    "Port     = 1433); { print(1) }"
  )

  expect_error(mock_input(input))
})
