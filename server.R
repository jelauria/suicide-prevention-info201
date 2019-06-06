#import all neccessary libraries and source files
library(dplyr)
library(rworldmap)
library(stringr)
library(ggplot2)
source("data_wrangling/map_array_manager.R") #reads in file that generate arrays for map tab
source("data_wrangling/line_array_manager.R") #reads in file that generate arrays for linear plot tab
source("data_wrangling/graph_1.R") #reads in file that generate arrays for gdp tab

#read in suicide data
raw_suicide_data <- read.csv("data/master.csv", sep = ",", stringsAsFactors = FALSE)

#sets up dynamic subcatergoy choices
sex_choices <- unique(as.character(raw_suicide_data$sex))
age_choices <- unique(as.character(raw_suicide_data$age))
generation_choices <- unique(as.character(raw_suicide_data$generation))

# define server for Shiny app
shinyServer(function(input, output, session) {
  
  #generates the dynamic subcategory box for the linear tab based off of category input
  output$subcategory_box = renderUI(
    if (is.null(input$lin_category)){return()
      }else if (input$lin_category == "sex"){ selectInput("subcategory", "Select a Subcategory:", choices = sex_choices)
        }else if (input$lin_category == "age"){ selectInput("subcategory", "Select a Subcategory:", choices = age_choices)
        }else{
          selectInput("subcategory", "Select a Subcategory:", choices = generation_choices)
          })
  
  #generates array needed for linear plot
  get_linear_data <- reactive({
    df <- generate_line_array(input$lin_category, input$subcategory, input$lin_year[1], input$lin_year[2])
    return(df)
  })
  
  #fill in main panel for linear plot tab
  output$linear_category_plot <- renderPlot({
    
    data_plot <- get_linear_data() #preps data to be rendered into linearplot
  
    #plot line graph
    plot(data_plot,type = "o", col = "purple", xlab = "Year", ylab = "Number of Suicides",
         main = paste("Number of", str_to_title(input$subcategory), 
                      "Suicides Committed Globally from", input$lin_year[1], "to", input$lin_year[2]))
  })
  
  #generates responsive title as text feedback   
  output$linear_plot_subtitle <- renderText({
    n_entries <- get_linear_data()%>%
      summarise(total = sum(num_suicides))
    title <- paste("Change in", input$subcategory, "suicides generated from", 
                   n_entries$total, "observations recorded during the period of", 
                   input$lin_year[1], "to", input$lin_year[2], ".")
    return(title)
  })
  
  #Include paragraph explanation of linear data plot
  output$linear_plot_explanation <- renderText({
    
    title <- "To determine whether any populations observed and increase in recent years, 
    we generated linear plots of the number of suicides committed by people sharing one 
    specific characteristic (age group, sex, or generation) against time. There appeared 
    to be no significant increases in male or female suicides within the past 20 years; 
    both have remained relatively stable since the increase observed in 1990. A similar 
    pattern was observed across different age ranges; most have remained relatively stable, 
    with the exception of people aged 5-14 years old observing a slight decrease in suicide 
    rate that was observed in 2003 and has since remained stable.Interesting patterns were 
    observed when focusing on suicide rates by generation. Older generations like the GI Generation, 
    Silent Generation, and Baby Boomers have observed significant decreases in recent years, 
    while Millenials and Generation X are on the rise. Perhaps this may be representative of 
    the shift in generations in wokring class; the older generations are retiring/passing due 
    to health conditions while Millenials and GenX are entering the workforce."
    
    return(title)
  })
  
  #generates array needed by map 
  generate_map_data <- reactive({
    df <- generate_map_array(input$map_year[1], input$map_year[2], input$map_category)
    return(as.data.frame(df, stringsAsFactors = FALSE))
  })
  
  #get coloumn to plot reactively
  get_map_col <- reactive({
  
    #get column to plot
    col_2plot <- input$map_category
    return(col_2plot)
  })
  
    get_map_title <- reactive({
    
    #generate map title and constantly update
    map_title <- paste("Most Popular", str_to_title(input$map_category), 
                      "to Commit Suicide (by Country) From", input$map_year[1], "to", input$map_year[2])
    return(map_title)
    })
    
    #updates color palette in response to input
    get_map_pallette <- reactive({
      
      if(input$map_category == "sex"){op <- palette(c('#e78ac3','#8da0cb'))
      }else{op <- palette(c('#e78ac3','#66c2a5','#fc8d62','#a6d854','#ffd92f','#8da0cb'))
      }
      
      return(op)
    })

    #fill in main panel created for a plot
    output$category_comp_map <- renderPlot({
      
      #render the map
      par(mai=c(0,0,0.2,0),xaxs="i",yaxs="i")
      
      #joining the data to a map
      sPDF <- joinCountryData2Map(generate_map_data(), joinCode = "NAME", nameJoinColumn = "country")

      #mapping
      mapCountryData(sPDF,
                    nameColumnToPlot= get_map_col(),
                    catMethod="categorical",
                    mapTitle= get_map_title(),
                    colourPalette= get_map_pallette(),
                    oceanCol="lightgrey",
                    missingCountryCol="white")
    }) #closes map plot output
  
    #generates responsive subtitle as text feedback   
    output$category_map_subtitle <- renderText({
    n_entries <- generate_map_data()%>%
      summarise(total = sum(num_suicides))
    title <- paste("Comparison of the number of suicides by", input$map_category, "from", 
                   n_entries$total, "observations recorded during the period of", 
                   input$map_year[1], "to", input$map_year[2], ".")
    return(title)
    })
    
    #Include paragraph explanation of linear data plot
    output$category_map_explanation <- renderText({
      
      title <- "To determine the dominant characteristics of suicidal individuals by country, 
      we generated maps color-coded to show the subgroup that committed the most suicides in 
      each country. Regardless of time period, the majority of suicides across the globe appeared 
      to be committed by males. The most popular age to commit suicide across the globe was 35-54 
      years of age, followed by a tie between individuals aged 15-24 and 25-34. With regard to 
      generations, Baby Boomers appear to have commited the most suicides from 1985 to 2016, 
      however, Millenials and Genration X individuals have taken the lead in recent years 
      (approx. 2010 to 2016)."
      
      return(title)
    })
    
    #generates GDP tab outputs
    output$suicide_with_gdp <- renderPlot({
      sort_data <- data %>%
        group_by(gdp_per_capita)
      table <- summarise(sort_data, total_suicide_number = sum(suicides_no))
      graph <- ggplot(table, aes(x = gdp_per_capita, y = total_suicide_number)) +
        geom_point(stat = "identity", color = "blue") + 
        xlim(input$gdp) +
        labs(
          title = "Number of Suicides versus GDP per capita, 1985 - 2016",
          x = "GDP per capita (USD($))",
          y = "Number of Suicides"
        )
      return(graph)
    })
    
    output$text_for_gdp <- renderText({
      paste("GDP per capita range: $", input$gdp[1], "to $", input$gdp[2])
    })
    
    output$text_to_analysis_gdp <- renderText({
      paste("As we can see from that graph, suicide always occurs through out the whole GDP axis.
            However, high suicide number occurs when the GDP become lower. And as the GDP increases, the 
            total suicide number decreases.")
    })
})
