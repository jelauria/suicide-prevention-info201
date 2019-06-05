#import all neccessary libraries
library(dplyr)

#read in suicide data
raw_suicide_data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)

#reaname country column to a workable title
coll_names <- colnames(raw_suicide_data)
raw_suicide_data <- select(raw_suicide_data, coll_names[1], year, sex, age, suicides_no, generation)
colnames(raw_suicide_data)[colnames(raw_suicide_data) == coll_names[1]] <- "country"

#generate the arry to be plotted by the server
generate_line_array <- function(user_category, user_subcat, year_min, year_max){
  
  #filter data to working timeframe
  working_data <- filter(raw_suicide_data, year >= year_min, year <= year_max)
  
  #takes in user_catergory param and filters to the appropriate subcategory
  if(user_category == "sex"){plotting_array <- filter(working_data, working_data$sex == user_subcat)
  }else if(user_category == "age"){plotting_array <- filter(working_data, working_data$age == user_subcat)
  }else{plotting_array <- filter(working_data, working_data$generation == user_subcat)}
  
  #stitch together final array for linear plot
  final_plotting_array <- group_by(plotting_array, year)%>%
    summarise(sum(suicides_no))
  
  return(final_plotting_array)
}