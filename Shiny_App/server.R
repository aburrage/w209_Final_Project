# Created by Andrew Burrage - w209 Final Project
# server.R
library(shiny)
library(dplyr)
library(tidyr)
library(highcharter)
library(quantmod)

nasdaq_symbols <- readRDS(file="NASDAQ.Rda")

shinyServer(function(input, output) {
  
  output$overview_ohlc <- renderHighchart({
    from.date <- as.Date("01/01/17", format="%m/%d/%y")
    to.date <- as.Date("04/24/17", format="%m/%d/%y")
    tsla <- getSymbols("TSLA",from = from.date, to = to.date,auto.assign = FALSE)
    
    highchart(type = "stock") %>% 
      hc_title(text = "Tesla Inc (Capital Goods - Auto Manufacturing, NASDAQ, TSLA)") %>% 
      hc_yAxis_multiples(
        create_yaxis(2, height = c(2, 1), turnopposite = TRUE)) %>%
      hc_add_series(tsla,type = "ohlc") %>%
      hc_add_series(tsla[,5], color = "gray", yAxis = 1, name = "Volume", type = "column") %>% 
      hc_exporting(enabled = TRUE)
  })
  
  output$double_bottom <- renderHighchart({
    from.date <- as.Date("12/01/99", format="%m/%d/%y")
    to.date <- as.Date("04/01/00", format="%m/%d/%y")
    cy <- getSymbols("PFE",from = from.date, to = to.date,auto.assign = FALSE)
    
    dates <- as.Date(c("2000-01-04", "2000-03-07"), format = "%Y-%m-%d")
    
    highchart(type = "stock") %>% 
      hc_title(text = "Pfizer Inc. (Healthcare - Drug Manufacturers, NYSE, PFE)") %>% 
      # hc_subtitle(text = "Double Bottom ") %>%
      hc_yAxis_multiples(
        create_yaxis(2, height = c(2, 1), turnopposite = TRUE)) %>%
      hc_add_series(cy,type = "ohlc",id = "dbl_btm") %>%
      hc_add_series_flags(dates, title = c("B1", "B2"), text = c("Bottom 1","Bottom 2"),color="red",id = "dbl_btm") %>% 
      hc_add_series(cy[,5], color = "gray", yAxis = 1, name = "Volume", type = "column") %>% 
      hc_exporting(enabled = TRUE)
  })
  
  output$triple_bottom <- renderHighchart({
    from.date <- as.Date("08/01/05", format="%m/%d/%y")
    to.date <- as.Date("01/01/06", format="%m/%d/%y")
    cy <- getSymbols("CY",from = from.date, to = to.date,auto.assign = FALSE)
    
    dates <- as.Date(c("2005-10-12", "2005-10-19","2005-10-28"), format = "%Y-%m-%d")
    
    highchart(type = "stock") %>% 
      hc_title(text = "Cypress Semiconductor Corp. (Technology - Semiconductors, NASDAQ, CY)") %>% 
      # hc_subtitle(text = "add subtitle here") %>%
      hc_yAxis_multiples(
        create_yaxis(2, height = c(2, 1), turnopposite = TRUE)) %>%
      hc_add_series(cy,type = "ohlc",id= "trpl_btm") %>%
      hc_add_series_flags(dates, title = c("B1", "B2","B3"), text = c("Bottom 1","Bottom 2","Bottom 3"),color="red",id = "trpl_btm") %>% 
      hc_add_series(cy[,5], color = "gray", yAxis = 1, name = "Volume", type = "column") %>% 
      hc_exporting(enabled = TRUE)
  })
  
  output$double_top <- renderHighchart({
    from.date <- as.Date("09/01/03", format="%m/%d/%y")
    to.date <- as.Date("09/01/04", format="%m/%d/%y")
    aee <- getSymbols("AEE",from = from.date, to = to.date,auto.assign = FALSE)
    
    dates <- as.Date(c("2004-01-29", "2004-03-05"), format = "%Y-%m-%d")
    
    highchart(type = "stock") %>%
      hc_title(text = "Ameren Corp. (Utilities - Utilities, NYSE, AEE)") %>% 
      # hc_subtitle(text = "add subtitle here") %>%
      hc_yAxis_multiples(
        create_yaxis(2, height = c(2, 1), turnopposite = TRUE)) %>%
      hc_add_series(aee,type = "ohlc",id="dbl_top") %>%
      hc_add_series_flags(dates, title = c("T1", "T2"), text = c("Top 1","Top 2"),color="red",id = "dbl_top") %>% 
      hc_add_series(aee[,5], color = "gray", yAxis = 1, name = "Volume", type = "column") %>% 
      hc_exporting(enabled = TRUE)
  })
  
  output$triple_top <- renderHighchart({
    from.date <- as.Date("01/01/01", format="%m/%d/%y")
    to.date <- as.Date("12/01/01", format="%m/%d/%y")
    aee <- getSymbols("APC",from = from.date, to = to.date,auto.assign = FALSE)
    
    dates <- as.Date(c("2001-04-17", "2001-04-26", "2001-05-21"), format = "%Y-%m-%d")
    
    highchart(type = "stock") %>%
      hc_title(text = "Anadarko Petroleum Copr. (Petroleum - Producing, NYSE, APC)") %>% 
      # hc_subtitle(text = "add subtitle here") %>%
      hc_yAxis_multiples(
        create_yaxis(2, height = c(2, 1), turnopposite = TRUE)) %>%
      hc_add_series(aee,type = "ohlc",id="trpl_top") %>%
      hc_add_series_flags(dates, title = c("T1", "T2", "T3"), text = c("Top 1","Top 2","Top 3"),color="red",id = "trpl_top") %>%
      hc_add_series(aee[,5], color = "gray", yAxis = 1, name = "Volume", type = "column") %>% 
      hc_exporting(enabled = TRUE)
  })
  
  output$symbol_info <- renderText({
    
    nasdaq_sym <- nasdaq_symbols %>% filter(Symbol == input$Stock_Symbol)
    # paste('You selected stock symbol,',nasdaq_sym$Symbol,'which is, ',nasdaq_sym$Name,'. ',nasdaq_sym$Symbol, 'is in ',nasdaq_sym$Sector,'sector',nasdaq_sym$industry, 'industry.')
    paste(nasdaq_sym$Name, '(',nasdaq_sym$Sector,'-',nasdaq_sym$industry,',','NASDAQ,',nasdaq_sym$Symbol,')')
    
  })
  
  output$stock_candlestick <- renderHighchart({
    x <- getSymbols(input$Stock_Symbol,auto.assign = FALSE)
    
    sym <- paste0(input$Stock_Symbol,'.Volume')
    
    highchart(type = "stock") %>%
      hc_yAxis_multiples(
        create_yaxis(2, height = c(2, 1), turnopposite = TRUE)) %>%
      hc_add_series(x,type = "ohlc") %>%
      hc_add_series(x[,5], color = "gray", yAxis = 1, name = "Volume", type = "column") %>% 
      hc_exporting(enabled = TRUE)
  })
  
}
)
