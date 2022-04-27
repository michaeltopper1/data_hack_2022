#Week 5 script

rm(list = ls());

library(usmap)
library(sf)
library(pdftools)
library(tidyverse)
library(mapview)

#In this script we are going to lear how to extract data from the pdf called: FY2021_CA_Press_Report.pdf\
#It's about the money HUD-CoC awards to different counties/CoC locations
#Continuum of Care Competition
#Homeless Assistance Award Report
#getwd()

coc_awards <- pdf_text("camilos_parts/Week 5/FY2021_NY_Press_Report.pdf")

#Just like Michael did last class:


coc_awards <- coc_awards %>% str_split('\n') %>% unlist()


#all in lower case and remove the whitespaces:

coc_awards <- coc_awards %>%
  str_to_lower() %>%
  str_trim

#What structure are we recognizing from the pdf?
#For example: Once the breakdown of each CoC is done, they summarize the total:
# NY-500 total : $13,587,501
#And then, a new Coc starts! That's a pattern/structure we can take advantage:
#Like, we can search the exact match "Total :" and after the money amount, we KNOW a new CoC starts!
# str_detect detects what you are asking

index <- coc_awards %>%
  str_detect("total :") %>%
  which


# Notice the following: The previous command creates numbers or indices (cuz that what "which" does)
# If you start exploring what happens one two and three lines after those indices, again we can find something valuable:

index

coc_awards[index]  #great, notice that NY state has 24 cocs!
coc_awards[index+1]
coc_awards[index+2]

#Ok, we are close of saying: Hooray!
#coc_awards[index+2] is what we need to divide and create tibbles that have what we want!

index_names <- index+2

#Also, do not forget that ny-500 is not there yet!

coc_awards %>% head(20)

#Notice that in line 11 we have ny-500

index_names<- c(11,index_names)

index_names <- index_names[-c(25:26)]


coc_awards[index_names] %>% as_tibble()

#Now the code is going to get messy, but let's try to keep our goal in mind:
#Create a tibble where we have all the cocs and the total amount awarded:

coc_names <- coc_awards[index_names] %>%
  as_tibble() %>%
  rename(coc_name=value)

#Cool, let's get the totals:
coc_totals <- coc_awards[index] %>% as_tibble

coc_totals <- coc_totals[-25,]

coc_NY_state <- tibble(coc_names,coc_totals)

coc_NY_state <- coc_NY_state %>%
    tidyr::extract(value, into = "total_FED_money", ".{1,}\\$(.{1,}).{1,}", remove = F)

coc_NY_state <- coc_NY_state %>%
  tidyr::extract(value, into = "total_FED_money", ".{1,}\\$(.{1,}).{1,}", remove = T)

#remove the commas:

coc_NY_state$total_FED_money <- as.numeric(gsub(',', '', coc_NY_state$total_FED_money))

typeof(coc_NY_state$total_FED_money)

#Now we begin the good stuff:

#From the package US MAP:

plot_usmap(regions = "states")

plot_usmap(regions = "counties") 

#let's add a couple of nice features/things:

plot_usmap(regions = "counties") +
  labs(title = "US Counties",
       subtitle = "This is a blank map of the counties of the United States.")

#What if we want some specifics::

plot_usmap("counties", fill = "yellow", alpha = 0.25,
           include = c(.south_region))


plot_usmap("counties", fill = "yellow", alpha = 0.25,
           include = c(.south_region), exclude = c(.east_south_central))


#Only NY state, in blue:

plot_usmap("counties", fill = "blue", alpha = 0.25,
           include = "NY")

#Cool, what about combining with ggplot and the data we have from coc_NY_state:
# FIPS: Federal Information Processing Standard


#Suppose we manage to use the data from the pdf and distribute "roughly" into the counties:
ny_hm <- read_csv('camilos_parts/Week 5/ny_hmfm.csv')

usmap::plot_usmap(data=ny_hm,include="NY", values = "overall_homeless", color = "grey") #+
  # ggplot2::scale_fill_gradient(low="green",high="darkgreen") + labs(title="Hi")

#Not a lot of info.. let's standarize?
ny_hm <- ny_hm %>% mutate(homeless_std = (overall_homeless - mean(overall_homeless))/sd(overall_homeless))


usmap::plot_usmap(data=ny_hm,include="NY", values = "homeless_std", color = "grey") #+

#let's try the ratio of money per homeless:

ny_hm <- ny_hm %>% mutate(dollar_p_hm = fed_money/overall_homeless) 

usmap::plot_usmap(data=ny_hm,include="NY", values = "dollar_p_hm", color = "grey") +
 labs(title="Federal dollar per homeless individual - NY State 2020")


#Now SF package!

install.packages("mapview")

mapview(breweries)

mapview(breweries)




















