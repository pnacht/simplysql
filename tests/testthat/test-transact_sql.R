conn <- setup_connection()

test_that("successful transactions are committed, transact_sql returns fun()", {
  fun <- function() {
    execute_sql(
      "CREATE TABLE Foo (
        id INT
      );")

    nrows <- execute_sql("
      INSERT INTO Foo
      VALUES (1), (2);")

    return("Mission accomplished!")
  }

  expect_equal(transact_sql(fun), "Mission accomplished!")

  expect_equal(
    query_sql("SELECT * FROM Foo"),
    data.frame(id = 1:2)
  )

  # also works with arguments
  fun <- function(x) {
    nrows <- execute_sql("
      INSERT INTO Foo
      VALUES ({x});")

    return("Mission accomplished!")
  }

  transact_sql(fun, 3)
  transact_sql(fun, x = 4)

  expect_equal(
    query_sql("SELECT * FROM Foo"),
    data.frame(id = 1:4)
  )

  execute_sql("DROP TABLE Foo")
})

test_that("break_sql leads to rollbacks and transact_sql returns NULL", {
  fun <- function() {
    execute_sql(
      "CREATE TABLE Foo (
        id INT
      );")

    execute_sql("
      INSERT INTO Foo
      VALUES (1), (2);")

    break_sql()
  }

  expect_equal(transact_sql(fun), NULL)

  expect_error(
    query_sql("SELECT * FROM Foo"),
    "no such table"
  )
})

test_that("errors lead to rollbacks and are bubbled up", {
  fun <- function() {
    execute_sql(
      "CREATE TABLE Foo (
        id INT
      );")

    execute_sql("
      INSERT INTO Foo
      VALUES (1), (2);")

    stop("Danger, Will Robbinson!")
  }

  expect_error(transact_sql(fun), "Danger, Will Robbinson!")

  expect_error(
    query_sql("SELECT * FROM Foo"),
    "no such table"
  )
})
