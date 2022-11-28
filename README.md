# simplysql

<!-- badges: start -->
[![R-CMD-check](https://github.com/pnacht/simplysql/workflows/R-CMD-check/badge.svg)](https://github.com/pnacht/simplysql/actions)
<!-- badges: end -->



## Overview

`simplysql` securely and easily handles connectivity to a SQL database via a "faux-DSN". Give a connection an alias and then never worry about its connection details again. This includes remembering to disconnect and refreshing stale connections.

SQL statements are also protected from SQL injection via string interpolation.

## Installation steps bla

``` r
# Install development version from GitHub
devtools::install_github("pnacht/simplysql")
```

## Usage

### Connecting to a known server

If a connection has already been set up with an alias (see below), all you've got to do is:

```r
start_sql_connection("my_alias")
```

The connection details will be fetched from your machine's secure credential store and the connection will be set up behind the scenes.

## Performing SQL operations

After calling `start_sql_connection()`, you can freely use the provided functions to perform all necessary SQL operations, confident that your queries are safe from SQL injection.

This functionality leverages the excellent `glue::glue_data_sql()` function:

```r
start_sql_connection("my_alias")

# all the following operations are performed on
# whatever connection was set up as "my_alias"
write_sql_table(iris, "iris")


# wrap parameters in curly brackets
# can fetch values from the parent environment
my_species <- "setosa"
query_sql("
  SELECT TOP 2 *
  FROM iris
  WHERE species = { my_species }
")
#>    Sepal.Length Sepal.Width Petal.Length Petal.Width Species
#> 1           5.1         3.5          1.4         0.2  setosa
#> 2           4.9         3.0          1.4         0.2  setosa


# can fetch values from named parameters
execute_sql("
  UPDATE iris
  SET Sepal.Width = 0
  WHERE Species = { x }
", x = my_species)


# can fetch values from "listish" objects passed to `.x`.
df <- data.frame(a = 1:2, b = 3:4)
write_sql("
  SELECT *
  FROM Foo
  WHERE a IN ({ a* })
    AND b IN ({ b* })
", .x = df)
#> <SQL> SELECT *
#> FROM Foo
#> WHERE a IN (1, 2)
#>   AND b IN (3, 4)
```

### Defining a connection

Connections only ever need to be defined once per machine.

Connections can be defined either interactively or non-interactively. For most cases, the interactive method is likely the easiest.

If you don't already have one, create a `DBI::dbConnect()` statement that can successfully create a connection to your database, such as:

```r
DBI::dbConnect(drv = RSQLite::SQLite(),
               dbname = "./path/to/db.sqlite")
```

Once you've got that DBI statement ready and working, simply copy it to your clipboard, and then run `start_sql_connection("my_alias")`. Since this is the first time you're requesting this connection, you'll be prompted to paste the `DBI::dbConnect()` you just copied:

```r
start_sql_connection("qwe")
#> qwe is not a recognized database connection.
#> Setting it up...
#> Paste a call to `DBI::dbConnect()` which creates a valid connection
#> to the server.
# <your input> DBI::dbConnect(drv = RSQLite::SQLite(),
# <your input>                dbname = "./path/to/db.sqlite")
```

And you're done. The `DBI::dbConnect()` call will be dissected and all of the necessary information will be extracted and saved in your machine's secure credential store. The connection will also be initiated for use in the current session.

If interactive setup isn't a good fit for your use-case (remote deploy, setup when the container boots up, etc), then simply use `setup_sql_connection()`, which expects an alias and the arguments you'd otherwise pass to `DBI::dbConnect()`. You'll then need to call `start_sql_connection()` to actually make the connection.
