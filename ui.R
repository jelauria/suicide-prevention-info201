
library(shiny)
library(dplyr)
library(ggplot2)
library(mapproj)
source("graph_1.R")

data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)
colnames(data)[10] <- "gdp_for_year"
colnames(data)[11] <- "gdp_per_capita"

shinyUI(fluidPage(
  
  navbarPage("Final Project",
    tabPanel("Suicide in year",
      sidebarLayout(
        sidebarPanel(
          selectInput("country", "Country:", choices = unique(as.character(data$country)))
        ),
       mainPanel(
         plotOutput("suicide_year_Plot"),
         textOutput("text_for_first_graph")
        )
      )
    ),
    
    tabPanel("Suicide with gdp",
             sidebarLayout(
               sidebarPanel(
                 sliderInput("gdp", "Please choose a gdp range", 
                             min = 251, max = 126352, value = c(251,300))
               ),
               mainPanel(
                 plotOutput("suicide_with_gdp"),
                 textOutput("text_for_gdp")
               )
             )
          ),
    
    tabPanel("Summary", 
             selectInput("year", "Year ", choice = sort(unique(data$year))),
             plotOutput("world"), width = 50, height = 100)
  )
  
  
))
