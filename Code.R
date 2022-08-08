### Loading libraries
library(dplyr)
library(RMySQL)
library(xts)
library(lubridate)
library(zoo)

### Creating connction
con <- dbConnect(RMySQL::MySQL(),
                 dbname='retornos',
                 host='localhost',
                 port=3306,
                 user='root',
                 password='Zurique')

print(dbListTables(con)) ### To see tables in data base

### Loading tables
m2 <- read.zoo(dbReadTable(con, 'm2'))
m2<- xts(m2) ### Converting to xts
infl <- read.zoo(dbReadTable(con, 'inflacao'))
infl <- xts(infl)

### Replace data in Inflation
index(infl) <- lubridate::floor_date(ymd(index(infl)), 'month')

### Merge data
macro <- merge(m2, infl, fill = NA)

### Interpolate NAs values in xts
macro <- na.approx(macro)

