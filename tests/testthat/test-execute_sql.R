conn <- setup_connection()

test_that("execute_sql works", {
  DBI::dbWriteTable(conn, "iris", iris)

  nrows <- nrow(iris[iris$Species == "setosa", ])

  expect_equal(
    execute_sql("
      UPDATE iris
      SET Species = 'a'
      WHERE Species = 'setosa'
                ")
    , nrows)
})
