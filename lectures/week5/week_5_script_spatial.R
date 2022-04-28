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

coc_awards <- pdf_text("lectures/week5/FY2021_NY_Press_Report.pdf")

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

#remove:

rm(coc_names,coc_totals)

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

# EXERCISE 
plot_usmap("counties", fill = "yellow", alpha = 0.25,
           include = c(.south_region), exclude = "FL")


#Only NY state, in blue:

plot_usmap("counties", fill = "blue", alpha = 0.25,
           include = "NY")

#Cool, what about combining with ggplot and the data we have from coc_NY_state:
# FIPS: Federal Information Processing Standard


#Suppose we manage to use the data from the pdf and distribute "roughly" into the counties:
ny_hm <- read_csv('lectures/week5/ny_hmfm.csv')

usmap::plot_usmap(data=ny_hm,include="NY", values = "overall_homeless") #+
  # ggplot2::scale_fill_gradient(low="green",high="darkgreen") + labs(title="Hi")



#### HOMEWORK!
#exclude nyc
usmap::plot_usmap(data=ny_hm[-c(3,24,31,41,43),],include="NY", values = "overall_homeless")

#exclude nyc and Nassau(30), Suffolk(52) and Westchester(60)
usmap::plot_usmap(data=ny_hm[-c(3,24,30,31,41,43,52,60),],include="NY", values = "overall_homeless")


#### HOMEWORK ENDS!

#Not a lot of info.. let's standarize?
ny_hm <- ny_hm %>% mutate(homeless_std = (overall_homeless - mean(overall_homeless))/sd(overall_homeless))



#how much money in each county:
usmap::plot_usmap(data=ny_hm,include="NY", values = "fed_money", color = "grey")


#let's try the ratio of money per homeless:

ny_hm <- ny_hm %>% mutate(dollar_p_hm = fed_money/overall_homeless)

usmap::plot_usmap(data=ny_hm,include="NY", values = "dollar_p_hm", color = "grey") +
 labs(title="Federal dollar per homeless - NY State 2020")

############# break
#Now SF package!? YEAH

#SF: 
#Provides a set of tools for working with geospatial vectors, i.e. points, lines, polygons, etc

#North Carolina data
demo(nc, ask = FALSE, echo = FALSE)
nc <- nc %>% janitor::clean_names()
class(nc)
plot(nc)
plot(nc["area"])
plot(nc["perimeter"])

plot(nc$geom)
plot(st_geometry(nc))


#Let's do a little bit ourselves with NY data:
load("lectures/week5/ny_spatial.RData")

class(ny_for_maps)


View(ny_for_maps)
View(ny_for_maps[,1:10])   # TAKES 3 HOURS TO OPEN, geometry doesn't disappear

ny_no_geometry <- select(as.data.frame(ny_for_maps), -geometry)

View(ny_no_geometry)

plot(ny_for_maps['coc_area'])

#What we are going to do next is try to simulate a similar graph as before when we did:
usmap::plot_usmap(data=ny_hm,include="NY", values = "fed_money", color = "grey")

#so, check this out:
#or better, explain left join and stuff, and everything we will do:
#start with:

coc_NY_state$coc_name

ny_for_maps$cocnum

#we can match those huh? Like, for each cocnum in ny_for_maps, we can match it with coc_NY_state$coc_name
#and back up the federal money from it!
#we need the name of the columns to be the same! (doesn't matter that we have different number of rows!)
#we are going to use a command called merge

#Two things to do:
#extract the first 6 characters of coc_NY_state$coc_name and later set everything to lowercase

#extract: str_sub(coc_NY_state$coc_name,1,6)
#worst: coc_NY_state$coc_number <- str_sub(coc_NY_state$coc_name,1,6)
#better:

coc_NY_state <- coc_NY_state %>% mutate(cocnum = str_sub(coc_name,1,6))

ny_for_maps$cocnum

ny_for_maps$cocnum <- tolower(ny_for_maps$cocnum)

colnames(coc_NY_state)

colnames(ny_for_maps)

#jumping waaay ahead of ourselves
new_york_state <- left_join(ny_for_maps,coc_NY_state,by="cocnum")

plot(new_york_state["total_FED_money"]) #missing data

#The City of New York is made up of five boroughs. Each borough is a county of New York State.

plot(st_geometry(new_york_state), col = sf.colors(12, categorical = TRUE), border = 'grey', 
     axes = TRUE)

options(sf_max.plot=1)
plot(new_york_state)
plot(new_york_state["area"])


#next one is SUPER optional

ggplot() + 
  geom_sf(data = new_york_state, aes(fill = "area"))


# OTHER STUFF, SUPER SUPPEEER OPTIONAL AND MAYBE!!!

mapview(breweries)

nyc_arrests = read_csv('lectures/week5/nyc_arrests.csv')

ttotal_crime <- total_crime %>%
  mutate(date = lubridate::ymd(paste0(year, "-", month, "-", "1")))

total_crime_by_age = nyc_arrests %>% group_by(year, month,age_group) %>% count()

total_crime_by_age <- total_crime_by_age %>%
  mutate(date = lubridate::ymd(paste0(year, "-", month, "-", "1")))


total_crime_by_age = total_crime_by_age %>% 
  rename("tot_crime" = "n")

ggplot(total_crime_by_age,aes(x=date, y = tot_crime, group = age_group, colour = age_group)) +
  geom_line() +
  xlab("Date") +
  ylab("Total crime per month") +
  labs(title = "Crime in NYC by age group")

library(ggmap)
bbox<- c(left = -74.35, bottom = 40.498, right = -73.687, top = 40.90)
nyc <- get_stamenmap(bbox, zoom = 11, maptype = "terrain")

ggmap(nyc) +
  geom_point(data = nyc_arrests %>% filter(ofns_desc=='ROBBERY' & year==2010),aes(longitude,latitude),
             alpha = 0.7) +
  ggthemes::theme_map() +
  labs(title = "Robberies in NYC")


ggmap(nyc) +
  geom_point(data = nyc_arrests %>% filter(ofns_desc=='ROBBERY'),
             aes(longitude,latitude,group = perp_race, colour = perp_race), alpha = 0.7) +
  ggthemes::theme_map() +
  theme(legend.position = c(0.01, 0.5)) +
  labs(color = "Perpetrator race",
       title = "Robberies by race in NYC")

