

grabAmisData <- function(queryString)
{
  # Open a connection
  connection <- dbConnect(odbc::odbc(),
                          'amis', 
                          UID=uid,
                          PWD=rstudioapi::askForPassword("Database password"))
  
  response <- dbSendQuery(connection, queryString)
  tbl <- dbFetch(response)
  dbClearResult(response)
  
  # disconnect from the database
  dbDisconnect(connection)
  
  names(tbl) <- tolower(names(tbl))
  
  return(as_tibble(tbl))
}

grabLocalData <- function(dbString, queryString)
{
  # Open a connection
  connection <- dbConnect(odbc::odbc(),
                          dbString)
  
  response <- dbSendQuery(connection, queryString)
  tbl <- dbFetch(response)
  dbClearResult(response)
  
  # disconnect from the database
  dbDisconnect(connection)
  rm(connection)
  
  names(tbl) <- tolower(names(tbl))
  
  return(as_tibble(tbl))
}

fixDate <- function(text) {
  answer <- ifelse(str_length(text) == 8,
                   str_c(
                     str_sub(text, 1, 4), '-',
                     str_sub(text, 5, 6), '-',
                     str_sub(text, 7, 8)
                   ),
                   NA
  )
  answer <- date(answer)
}


fixAmisTable <- function(df) {
  df.names <- colnames(df)
  
  # num.df <- df %>%
  #   select_if(is.numeric)
  
  txt.df <- df %>%
    select_if(is.character) %>%
    map(str_trim) %>%
    as_tibble
  
  txt.names <- colnames(txt.df)
  
  other.df <- df %>%
    select(-txt.names)
  
  dates.df <- txt.df %>%
    select(ends_with('_date')) %>%
    map(fixDate) %>%
    as_tibble
  
  df <- txt.df %>%
    select(-ends_with('_date')) %>%
    bind_cols(., other.df, dates.df) %>%
    select(df.names)
  
  return(df)
  
}
