library(ggplot2)
library(dplyr)
library(mapproj)
data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)
colnames(data)[10] <- "gdp_for_year"
colnames(data)[11] <- "gdp_per_capita"

##check if the suicide number increases or decrease according to year
table_one <- function(country_name) {
  target_data <- data%>%
    filter(country == country_name)%>%
    group_by(year)
  table <- summarise(target_data, total_suicide_number = sum(suicides_no), 
                     gdp_per_capita = sum(gdp_per_capita) / 12)
  graph <- ggplot(table, aes(x = year, y = total_suicide_number)) +
    geom_line(stat = "identity", color = "red") +
    labs(y = "total suicide number")
  return(graph)
}

