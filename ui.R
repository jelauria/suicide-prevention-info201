
library(shiny)
library(dplyr)
library(ggplot2)
library(mapproj)
source("graph_1.R")

data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)
colnames(data)[10] <- "gdp_for_year"
colnames(data)[11] <- "gdp_per_capita"

shinyUI(fluidPage(
  

  titlePanel("Old Faithful Geyser Data"),
  

  sidebarLayout(
    sidebarPanel(
      selectInput("country", "Country", choices = unique(as.character(data$country)))
       
    ),
    

    mainPanel(
      plotOutput("distPlot")
       
    )
  )
))
