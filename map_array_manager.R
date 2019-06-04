#import all neccessary libraries
library(dplyr)

#read in suicide data
raw_suicide_data <- read.csv("master.csv", sep = ",", stringsAsFactors = FALSE)

#reaname country column to a workable title
coll_names <- colnames(raw_suicide_data)
raw_suicide_data <- select(raw_suicide_data, coll_names[1], year, sex, age, suicides_no, generation)
colnames(raw_suicide_data)[colnames(raw_suicide_data) == coll_names[1]] <- "country"

#define function that produces plottable tables for map based on sex
sex_map_array <- function(year_min, year_max){
  
  #filter data to working timeframe
  working_data <- filter(raw_suicide_data, year >= year_min, year <= year_max)
  
  #sum all female suicides within time frame by country
  fem_map_array <- working_data%>%
    filter(sex == "female")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(sex = "female")
  
  #sum all male suicides within time frame by country
  mal_map_array <- working_data%>%
    filter(sex == "male")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(sex = "male")
  
  #combine male and female dataframes and select the sex with the majority
  map_array <- rbind(fem_map_array, mal_map_array)%>%
    group_by(country)%>%
    filter(num_suicides == max(num_suicides))
  map_array <- map_array[!duplicated(map_array["country"]),] #defaults duplicate countries to female
  return(map_array)
}

#define function that produces plottable tables for map based on age
age_map_array <- function(year_min, year_max){
  
  #filter data to working timeframe
  working_data <- filter(raw_suicide_data, year >= year_min, year <= year_max)
  
  #sum all aged 5-14 suicides within time frame by country
  age05_map_array <- working_data%>%
    filter(age == "5-14 years")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(age = "5-14 years")
  
  #sum all aged 15-24 suicides within time frame by country
  age15_map_array <- working_data%>%
    filter(age == "15-24 years")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(age = "15-24 years")
  
  #sum all aged 25-34 suicides within time frame by country
  age25_map_array <- working_data%>%
    filter(age == "25-34 years")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(age = "25-34 years")
  
  #sum all aged 35-54 suicides within time frame by country
  age35_map_array <- working_data%>%
    filter(age == "35-54 years")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(age = "35-54 years")
  
  #sum all aged 55-74 suicides within time frame by country
  age55_map_array <- working_data%>%
    filter(age == "55-74 years")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(age = "55-74 years")
  
  #sum all aged 75+ suicides within time frame by country
  age75_map_array <- working_data%>%
    filter(age == "75+ years")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(age = "75+ years")
  
  #combine all dataframes and select the age with the majority
  map_array <- rbind(age05_map_array, age15_map_array, age25_map_array, 
                     age35_map_array, age55_map_array, age75_map_array)%>%
    group_by(country)%>%
    filter(num_suicides == max(num_suicides))
  map_array <- map_array[!duplicated(map_array["country"]),] #defaults duplicate countries to youngest age
  return(map_array)
}

#define function that produces plottable tables for map based on generation
generation_map_array <- function(year_min, year_max){
  
  #filter data to working timeframe
  working_data <- filter(raw_suicide_data, year >= year_min, year <= year_max)
  
  #sum all GI suicides within time frame by country
  GI_map_array <- working_data%>%
    filter(generation == "G.I. Generation")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(generation = "G.I. Generation")
  
  #sum all Silent Gen suicides within time frame by country
  SI_map_array <- working_data%>%
    filter(generation == "Silent")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(generation = "Silent")
  
  #sum all Baby Boomer suicides within time frame by country
  BB_map_array <- working_data%>%
    filter(generation == "Boomers")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(generation = "Boomers")
  
  #sum all GenX suicides within time frame by country
  GX_map_array <- working_data%>%
    filter(generation == "Generation X")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(generation = "Generation X")
  
  #sum all Millenial suicides within time frame by country
  MI_map_array <- working_data%>%
    filter(generation == "Millenials")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(generation = "Millenials")
  
  #sum all GenZ suicides within time frame by country
  GZ_map_array <- working_data%>%
    filter(generation == "Generation Z")%>%
    group_by(country)%>%
    summarise(num_suicides = sum(suicides_no))%>%
    mutate(generation = "Generation Z")
  
  #combine all dataframes and select the generation with the majority
  map_array <- rbind(GI_map_array, SI_map_array, BB_map_array, GX_map_array, MI_map_array, GZ_map_array)%>%
    group_by(country)%>%
    filter(num_suicides == max(num_suicides))
  map_array <- map_array[!duplicated(map_array["country"]),] #defaults duplicate countries to oldest generation
  return(map_array)
}

#write a function that passes parameters to the appropriate function
generate_map_array <- function(year_min, year_max, user_category){
  
  #takes in user_catergory param and passes year params to appropriate function
  if(user_category == "sex"){plotting_array <- sex_map_array(year_min, year_max)
  }else if(user_category == "age"){plotting_array <- age_map_array(year_min, year_max)
  }else{plotting_array <- generation_map_array(year_min, year_max)}
  
  #returns array for plotting
  return(plotting_array)
}

test_array <- sex_map_array(1990, 2015)
