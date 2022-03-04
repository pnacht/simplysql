setup_connection()

test_that("sql_identifier handles simple character names", {
  expect_equal(
    sql_identifier("foo"),
    DBI::SQL('`foo`')
  )

  expect_equal(  # does not parse
    sql_identifier("foo.bar"),
    DBI::SQL('`foo.bar`')
  )
})

test_that("sql_identifier can parse character names", {
  expect_equal(  # works if there's nothing to parse
    sql_identifier("foo", parse = TRUE),
    DBI::SQL('foo')
  )

  expect_equal(
    sql_identifier("foo.bar", parse = TRUE),
    DBI::SQL('foo.bar')
  )
})

test_that("sql_identifier validates parsed character names", {
  expect_error(
    sql_identifier("foo.bar; DROP TABLE foo", parse = TRUE),
    "Can't unquote"
  )
})

test_that("sql_identifier handles SQL names", {
  expect_equal(
    sql_identifier(DBI::SQL("foo.bar")),
    DBI::SQL('foo.bar')
  )
})

test_that("sql_identifier validates SQL names", {
  expect_error(
    sql_identifier(DBI::SQL("foo.bar; DROP TABLE foo")),
    "Can't unquote"
  )
})

test_that("sql_identifier works with Id names", {
  expect_equal(  # does not interpret the dot as a separator
    sql_identifier(DBI::Id(table = "my.table")),
    DBI::SQL('`my.table`')
  )
  expect_equal(
    sql_identifier(DBI::Id(schema = "my.schema", table = "my.table")),
    DBI::SQL('`my.schema`.`my.table`')
  )
})


