#import shiny
library(shiny)

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
                          sliderInput("lin_year", "Select Time Period:", #set up slider to select time period
                                      min = 1985, max = 2016, value = c(1985, 2016)),
                          selectInput("lin_category", "Category:", choices = categories), #static SI widget
                          uiOutput("subcategory_box")), #preps subcategory box that is dependant on category box
                                                                                    #vector defined above (categories)
                        mainPanel(
                          plotOutput("linear_category_plot"), #plots main panel 
                          textOutput("linear_plot_subtitle")) #subtitle and close main panel
                        ) #close side layout
                      ), #close tab panel
             
             #builds linear plot tab
             tabPanel("Map by Category",
                      #titlePanel("Global Change in Number of Suicides (by Subcategory) Over Time"),
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("map_year", "Select Time Period:", #set up slider to select time period
                                      min = 1985, max = 2016, value = c(1985, 2016)),
                          selectInput("map_category", "Category:", choices = categories)), #Static SI widget
                            mainPanel(
                              plotOutput("category_comp_map"), #draws main panel plots
                              textOutput("category_map_subtitle") #subtitle
                            ) #close main panel
                      ) #close side panel
                      ),#close tab panel
             
             #builds GDP tab
             tabPanel("GDP Scatter",
                      sidebarLayout(
                        sidebarPanel(
                          sliderInput("gdp", "Select GDP Range:", #sets up slider to select GDP range
                                      min = 251, max = 126352, value = c(251, 126352))
                        ),
                        mainPanel(
                          plotOutput("suicide_with_gdp"),
                          textOutput("text_for_gdp")
                        )#close main panel
                      )#close sidebar layout
             ),#close tabPanel
             
             #builds getting help page
             tabPanel("Don't Give Up",
                      includeMarkdown("gettingHelp.Rmd")
             ),#closes tabpanel
             
             #builds about page
             tabPanel("About",
                      includeMarkdown("about.Rmd")
             )#closes tabpanel
             
             ) #close navbar page
  ) #close fluid page
) #close shinyUI
             