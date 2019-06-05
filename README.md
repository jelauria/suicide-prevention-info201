# Using Data to Identify Patterns in Suicidal Populations Across the Globe

## Link to Project

## Project Description

For this project, we worked with a dataset that depicted global suicide rates from 1985 to 2016. This dataset is a compilation of data from the United Nations Development Program, World Bank, and the World Health Organization. We accessed this dataset [here](https://www.kaggle.com/russellyates88/suicide-rates-overview-1985-to-2016) at this address: https://www.kaggle.com/russellyates88/suicide-rates-overview-1985-to-2016  

We aim to reach out to general audiences interesed in suicide prevention, especially support groups/organizations, schools and hospitals. Although suicide is an issue that effects most communities across the globe, suicide prevention organizations/institutions would find this dataset especially useful. Organizations can use this data to make informed decisions about how to design their outreach techniques and care plans to suit the high-risk demographic in their area.

**Questions addressed:**  

1.	Are there any populations that have observed an increase in suicides over time? What characteristics do they share?
2.	What is the most popular age to commit suicide in each country? Are male suicides more popular than female suicides in particular countries? What about generations?
3.	Is there any correlation between suicide rates and a country’s GDP? Are citizens of countries with higher economic status at higher risk for suicide?

## General Findings

To determine whether any populations observed and increase in recent years, we generated linear plots of the number of suicides committed by people sharing one specific characteristic (age group, sex, or generation) against time. There appeared to be no significant increases in male or female suicides within the past 20 years; both have remained relatively stable since the increase observed adound 1990. A similar pattern was observed across different age ranges; most have remained relatively stable, with the exception of 5-14 year olds observing a slight decrease in suicide rate that has been observed since 2003. Interesting patterns were observed when focusing on suicide rates by generation. Older generations like the GI Generation, Silent Generation, and Baby Boomers have observed significant decreases in recent years, while Millenials and Generation X are on the rise. Perhaps this may be representative of the shift in generations in wokring class; the older generations are retiring/passing due to health conditions while Millenials and GenX are entering the work force.

To determine the dominant characteristics of suicidal individuals by country, we generated maps color-coded to show the subgroup that committed the most suicides in each country. Regardless of time period, the majority of suicides across the globe appeared to be committed by males. The most popular age to commit suicide across the globe was 35-54 years of age, followed by a tie between individuals aged 15-24 and 25-34. With regard to generations, Baby Boomers appear to have commited the most suicides from 1985 to 2016,however, Millenials and Genration X individuals have taken the lead in recent years (approx. 2010 to 2016).

Low GDP per capita countries appeared to be at much higher risk of suicide than higher GDP per capita countries. This relationship was revealed by plotting the numbers of suicides (global) against GDP per capita on a scatter plot, and oberving large spikes towards lower GDP areas. 

## Technical Component Descriptions  

This dataset was read in as a static .csv file. Each entry has information on the country, year, sex, age group, count of suicides, population, suicide rate, country-year composite key, HDI for that year, GDP for that year, GDP per capita, and generation (based on age grouping average) for each unique case.

Data wrangling was done in `map_array_manager.R` and `line_array_manager.R`, along with a minor amount in `server.R`.

## Notes

- Data was not collected equally across all years; some countries were missing points at certain years
- When two or more groups tied for largest number of suicides in `map_array_manager.R`, the script defaulted to either female, youngest age, or oldest generation (depending on the category of interest)
- 144 countries were not reported at all. Many datapoints missing from Africa and Asia.


## Challenges
One of the biggest challenges we face is the fact that this dataset does not include data for every year in every country; some countries have more data than others. This may be combatted by only summing up the data from years that all countries have data on, but there should still be an option to accurately display data from other (likely more recent) years. The data also will be analyzed by entry, instead of by entire columns (as done in previous assignments), which will require a bit of extra work. Lastly, this will be the first time any of us make an interactive data representation, which will prove challenging. The goal is to make a map that displays the desired characteristic on a map that can be manipulated with a set of filter controls.

## R Packages Used:
-	dplyr
-	mapprojrworldmap
-	ggmapstringr
-	ggplot2

### Github Repository: 
https://github.com/jelauria/suicide-prevention-info201
