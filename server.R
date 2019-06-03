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
      geom_point(stat = "identity", color = "blue") + 
      xlim(input$gdp)
    return(graph)
  })
  
  output$text_for_gdp <- renderText({
    paste("The gdp range you choose is from", input$gdp[1], "to", input$gdp[2])
  })
  
  output$world <- renderPlot({
    target_data <- data %>%
      filter(year == input$year) %>%
      group_by(country)
    table <- summarise(target_data, suicide_ration = sum(suicides_no) * 100 / sum(population))
    table$country[table$country == "Republic of Korea"] <- "South Korea"
    table$country[table$country == "United States"] <- "USA"
    table$country[table$country == "Russian Federation"] <- "Russia"
    world_data <- map_data("world")
    map <- ggplot(world_data) +
      geom_map(aes(map_id = region, group = group, x = long, y = lat), map = world_data, fill = "white", 
               colour = "#7f7f7f") +
      geom_map(data = table, map = world_data, aes(fill = suicide_ration, map_id = country)) +
      scale_fill_gradient(high = "red", low = "blue")
      return(map)
  })
  
})
