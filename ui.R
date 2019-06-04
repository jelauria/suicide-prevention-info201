#import shiny
library(shiny)

#load in raw suicide data
raw_suicide_data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)

#define select input choices for map 
categories <- c("pick one", "sex", "age", "generation")

#use fluid Bootstrap layout
shinyUI(fluidPage(
  
  navbarPage("Suicide Data Analysis", #labels upper left corner
             
             #builds map plot tab
             tabPanel("Linear Plot",
                      #titlePanel("Global Comparisons of Suicides by Sex, Age or Generation"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("year", "Select Time Period:", #set up slider to select time period
                                      min = 1985, max = 2016, value = c(1985, 2016)),
                          selectInput("lin_category", "Category:", choices = categories), #static SI widget
                          uiOutput("subcategory_box")), #preps subcategory box that is dependant on category box
                                                                                    #vector defined above (categories)
                        mainPanel(
                          plotOutput("linear_category_plot"), #plots main panel 
                          textOutput("linear_category_subtitle")) #subtitle
                        ) #close side pannel
                      ), #close main panel
             
             #builds linear plot tab
             tabPanel("Map by Category",
                      #titlePanel("Global Change in Number of Suicides (by Subcategory) Over Time"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("year", "Select Time Period:", #set up slider to select time period
                                      min = 1985, max = 2016, value = c(1985, 2016)),
                          selectInput("map_category", "Category:", choices = categories)), #Static SI widget
                            mainPanel(
                              plotOutput("category_comp_map"), #draws main panel plots
                              textOutput("text_for_first_graph") #subtitle
                            ) #close main panel
                      ) #close side panel
                      )#close tab panel
             ) #close navbar page
  ) #close fluid page
) #close shinyUI
             