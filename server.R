library(shiny)
library(dplyr)
library(ggplot2)
library(mapproj)
source("graph_1.R")

data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)
colnames(data)[10] <- "gdp_for_year"
colnames(data)[11] <- "gdp_per_capita"

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
   
  output$distPlot <- renderPlot({
    return(table_one(input$country))
  })
  
})
