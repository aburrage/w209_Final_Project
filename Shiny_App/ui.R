# Created by Andrew Burrage - w209 Final Project
# Ui.R
library(shiny)
library(dplyr)
library(tidyr)
library(highcharter)
library(quantmod)

nasdaq_symbols <- readRDS(file="NASDAQ.Rda")

shinyUI(fluidPage(
                  
                  navbarPage("Chart Patterns",
                             # About the vis/app page
                             tabPanel("About",
                                      sidebarPanel(h2("About Me"),
                                                   p("This page was developed by Andrew Burrage for the final project in W209. Project code can be found on my ", a("Github",href="https://github.com/aburrage/w209_Final_Project")),
                                                   br(),
                                                   img(src='me.png',height = 150, width = 150),
                                                   h2("Sources"),
                                                   p("All chart pattern identification and trading tips is cited from,",a("Thomas Bulkowski",href = "http://thepatternsite.com/index.html")),
                                                   p("R Packages:"),
                                                   code("Shiny"), 
                                                   code("Highcharter"),
                                                   code("quantmod")),
                                      mainPanel(h2("Overview"),
                                                p("This visualization will help aspiring traders learn to recognize chart patterns. To do this, we will focus on a few
                                                  chart patterns: double bottoms, triple bottoms, double tops and triple tops."),
                                                p("To visualize stock prices over time we will use open-high-low-close (OHLC) charts. When trading stocks there are five values
                                                  every trader must be aware of: opening price, high price, low price, closing price and volume. OHLC is a great way to visualize
                                                  movements in stock prices over time. OHLC charts have vertical lines showing highest and lowest
                                                  prices over a certain time period, one day or one week. Tick marks, indicating opening and closing price, appear on the left
                                                  and right side of the vertical line, respectively. Additionally, trading volume will appear beneath the OHLC chart."),
                                                p("Navigating this site: click on the \"Patterns\" drop down menu and select the pattern you want to learn about, click on the \"Explore\" tab
                                                  to investigate stocks of your choosing. On the chart pattern pages you will find information on how to identify and trading tips for the selected pattern.
                                                  When navigating to different pattern pages and exploring stocks on your own the data will take a few seconds to load, please be patient."),
                                                p("General information about a stock will be displayed in the follwing format: "),
                                                p(strong("Company Name (Sector - Industry, Exchange, Symbol)"),align="center"),
                                                p("To familiarize yourself with OHLC charts, have a look at Tesla(s), TSLA, OHLC chart below. Hovering over specific days in the chart 
                                                  will reveal Tesla's open, high, low, close and volume for the seleceted day. There are multiple ways to change the time frame you 
                                                  are looking at: manually enter a date range, select a pre-installed date range (1m, 3m, 6m, YTD, 1y, All), click and drag  
                                                  in chart area and manipulating the blue rectangle at the bottom of the chart."),
                                                highchartOutput("overview_ohlc",height = "500px")
                                      )),
                             navbarMenu("Patterns",
                                        tabPanel("Double Bottoms",
                                                 mainPanel(
                                                   h3("Double Bottoms - Identification"),
                                                   p('There will be a downward trendline. Both valleys will be similar. Both bottoms will be around the same price. Several weeks should
                                                     separate both bottoms. To be a double bottom price must close above the highest peak within the double bottom.'),
                                                   p(em("- Thomas Bulkowski")),
                                                   highchartOutput("double_bottom",height = "500px"),
                                                   h3("Double Bottoms - How to Trade"),
                                                   p("Double bottoms can be risky because they occur on a downward trend. The riskiest time is after price has confirmed the double bottom.  
                                                     Traders will drive price back down. The price will drop below the lowest bottom, stopping out the trade."),
                                                  p("To prevent this, look at overall market outlook. Look for bearish chart patterns
                                                     in the S&P, DJI and NASDAQ eschanges. From these trends and assuming the trend will continue,
                                                     you can guess the coming price trend."),
                                                   p("Look at the industry and sector in which the stock belongs. Look at charts for stocks in the same industry and sector. 
                                                     How are these stocks trendings?"),
                                                  p(em("- Thomas Bulkowski"))
                                                   )),
                                        tabPanel("Triple Bottoms",
                                                 mainPanel(
                                                   h3("Triple Bottoms - Identification"),
                                                   p("Price trends downward to the first bottom. The 
                                                      three bottoms should appear near the same price. The three bottoms are usually separated by several weeks.
                                                      Once price closes above the highest peak, the pattern can be called a triple bottom."),
                                                   p(em("- Thomas Bulkowski")),
                                                  highchartOutput("triple_bottom",height = "500px"),
                                                  h3("Triple Bottoms - How to Trade"),
                                                  p("
                                                    If the rise between bottoms 1 and 2 is higher than the rise between bottoms 2 and 3, draw
                                                    a downsloping trendline connecting the tops. Price closing above this trendline should be a signal to buy."),
                                                  p("Another strong signal to buy would be a triple bottom forming after price has been in a long horizontal trend."),
                                                  p(em("- Thomas Bulkowski"))
                                                           )),
                                        tabPanel("Double Tops",
                                                 mainPanel(
                                                   h3("Double Tops - Identification"),
                                                   p("Price usually trends upper towards a double top."),
                                                   p(em("- Thomas Bulkowski")),
                                                   highchartOutput("double_top",height = "500px"),
                                                   h3("Double Tops - How to Trade"),
                                                   p("Don't be too eager to sell a double top. Wait for confirmation of a double top prior to selling."),
                                                   p("A double top after a six month or more downward trend could indicate the trend might reverse."),
                                                   p("A steep double top on a horizontal trend, expect price to regress down to the horizontal
                                                     trend from which it grew."),
                                                   p(em("- Thomas Bulkowski"))
                                                   )
                                                 ),
                                        tabPanel("Triple Tops",
                                                 mainPanel(
                                                   h3("Triple Tops - Identification"),
                                                   p('Three peaks, each peak should be well-separated from the other peaks. All peaks should be near the 
                                                      same price. A triple top is confirmed when price closes below the lowest
                                                      valley in the pattern.'),
                                                   p(em("- Thomas Bulkowski")),
                                                   highchartOutput("triple_top",height = "500px"),
                                                   h3("Triple Tops - How to Trade"),
                                                   p("If you can draw an upsloping trendline along the two valleys between the three tops, use that as a
                                                     sell signal. This will get you out prior to confirmation."),
                                                   p("If price fails to reach the level of the middle peak in a triple top, expect a powerful decline."),
                                                   p("Triple tops with a high-velocity move going into the chart pattern often results in a high-velocity move
                                                     after the breakout."),
                                                   p(em("- Thomas Bulkowski"))
                                                   ))
                                        ),
                             tabPanel("Explore",
                                      sidebarPanel(
                                        p("Pick any NASDAQ symbol to explore it's charts from 2007 to present. Please click outside of the drop down menu to
                                          load the stock data. Please be patient, the data can take a few seconds to load."),
                                        selectizeInput("Stock_Symbol", "Stock Symbol",
                                                       choices = sort(unique(nasdaq_symbols$Symbol)), multiple = FALSE)
                                      ),
                                      mainPanel(
                                        textOutput('symbol_info'),
                                        highchartOutput("stock_candlestick",height = "500px")
                                      ))
                  ))
)