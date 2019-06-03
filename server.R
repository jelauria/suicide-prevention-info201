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
   
  output$suicide_year_Plot <- renderPlot({
    return(suicide_in_year(input$country))
  })
  
  output$text_for_first_graph <- renderText({
    paste("This graph shows the relation between suicide number and year in ", input$country)
  })
  
  output$suicide_with_gdp <- renderPlot({
    sort_data <- data %>%
      group_by(gdp_per_capita)
    table <- summarise(sort_data, total_suicide_number = sum(suicides_no))
    graph <- ggplot(table, aes(x = gdp_per_capita, y = total_suicide_number)) +
      geom_line(stat = "identity", color = "blue") + 
      xlim(input$gdp)
    return(graph)
  })
  
  output$text_for_gdp <- renderText({
    paste("The gdp range you choose is from", input$gdp[1], "to", input$gdp[2])
  })
  
})
