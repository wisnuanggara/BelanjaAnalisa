library(shiny)
library(shinydashboard)
library(tidyverse)
library(readxl)
library(knitr)
library(ggplot2)
library(lubridate)
library(arules)
library(arulesViz)
library(plyr)
library(dplyr)

retail <- read_excel("online_retail.xlsx") 
retail <- retail[complete.cases(retail),] 
retail$InvoiceNo <- as.numeric(as.character(retail$InvoiceNo)) 
retail <- retail[complete.cases(retail),] 
retail <- retail %>% mutate(Description = as.factor(Description))
retail <- retail %>% mutate(Country = as.factor(Country))  
retail$Date <- as.Date(retail$InvoiceDate)  
retail$TransTime <- format(retail$InvoiceDate,"%H:%M:%S") 
glimpse(retail) 

library(plyr)
transactionData <- ddply(retail,c("InvoiceNo","Date"),
                         function(df1)paste(df1$Description,
                                            collapse = ",")) 
transactionData$InvoiceNo <- NULL
transactionData$Date <- NULL 
colnames(transactionData) <- c("items") 
glimpse(transactionData)

write.csv(transactionData,"market_basket_transactions.csv", quote = FALSE, row.names = FALSE) 
tr <- read.transactions('market_basket_transactions.csv', format = 'basket', sep = ',' , rm.duplicates =TRUE, skip = 1, quote = '')
inspect(tr[1:5])
summary(tr)

tr_df <- as(tr, "data.frame")
summary(tr_df)

items <- 
  tr_df %>% 
  transmute(items=as.character(items) %>% 
              str_remove_all("\\{|\\}")) %>% 
  separate_rows(items, sep = ",\\s?") %>% 
  distinct(items) %>% 
  pull()

