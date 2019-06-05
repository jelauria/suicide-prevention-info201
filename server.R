#import all neccessary libraries and source files
library(dplyr)
library(rworldmap)
library(stringr)
library(ggplot2)
source("map_array_manager.R") #reads in file that generate arrays for map tab
source("line_array_manager.R") #reads in file that generate arrays for linear plot tab
source("graph_1.R") #reads in file that generate plots for gdp tab

#read in suicide data
raw_suicide_data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)

#sets up dynamic subcatergoy choices
sex_choices <- unique(as.character(raw_suicide_data$sex))
age_choices <- unique(as.character(raw_suicide_data$age))
generation_choices <- unique(as.character(raw_suicide_data$generation))

# define server for Shiny app
shinyServer(function(input, output, session) {
  
  #generates the dynamic subcategory box for the linear tab based off of category input
  output$subcategory_box = renderUI(
    if (is.null(input$lin_category) || input$lin_category == "pick one"){return()
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
})
