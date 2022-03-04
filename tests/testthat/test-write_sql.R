setup_connection()

test_that("write_sql works for non-parametric strings", {
  expect_equal(
    write_sql("SELECT 1"),
    DBI::SQL("SELECT 1")
  )
})

test_that("write_sql fetches parameters from the parent frame", {
  x <- 1
  y <- 2

  expect_equal(
    write_sql("SELECT { x } + { y }"),
    DBI::SQL("SELECT 1 + 2")
  )
})

test_that("write_sql fetches parameters from .x", {
  df <- data.frame(
    x = 1,
    y = 2
  )

  expect_equal(
    write_sql("SELECT { x } + { y }", .x = df),
    DBI::SQL("SELECT 1 + 2")
  )

  lst <- list(
    x = 1,
    y = 2
  )

  expect_equal(
    write_sql("SELECT { x } + { y }", .x = lst),
    DBI::SQL("SELECT 1 + 2")
  )

  env <- new.env(parent = emptyenv())
  env$x <- 1
  env$y <- 2

  expect_equal(
    write_sql("SELECT { x } + { y }", .x = env),
    DBI::SQL("SELECT 1 + 2")
  )
})

test_that("write_sql gives preference to .x over parent frame", {
  df <- data.frame(
    x = 1,
    y = 2
  )

  x <- 3
  y <- 4

  expect_equal(
    write_sql("SELECT { x } + { y }", .x = df),
    DBI::SQL("SELECT 1 + 2")
  )
})

test_that("write_sql gives preference to named arguments over .x", {
  df <- data.frame(
    x = 1,
    y = 2
  )

  expect_equal(
    write_sql("SELECT { x } + { y }", .x = df, x = 3, y = 4),
    DBI::SQL("SELECT 3 + 4")
  )
})

test_that("write_sql throws if `...` contains unnamed arguments", {
  expect_error(
    write_sql("SELECT { x }", x = 1, "y = 2")
  )
})
