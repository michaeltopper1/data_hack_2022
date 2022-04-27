#Week 1 code for:  The Slides and the exercises at the end
#Rprojects


rm(list = ls());
library(readxl)

#Is the Rproject created?

#Where are we?
getwd()

data_employment <- read_excel("Week1_data/employment12.xlsx")

names(data_employment)

data_employment$`LAUS code`

#Ugly, we usually want to remove spaces in names:
names(data_employment) <- make.names(names(data_employment), unique=TRUE)

names(data_employment)

View(data_employment)

#Erase last 3 rows:

data_employment <- data_employment[1:3219,]


#class(data_employment)
typeof(data_employment)

typeof(data_employment$LAUS.code)
typeof(data_employment$State.FIPS.code)
typeof(data_employment$Labor.force)


#Logical are TRUE/FALSE

4 == 2+2
a <- 4 == 2+2

typeof(a)

typeof(data_employment$Unemployment.rate..)

#Transform to numeric:

data_employment$Unemployment.rate..=as.numeric(data_employment$Unemployment.rate..) 

typeof(data_employment$Unemployment.rate..)

#Common Statistics:

mean(data_employment$Unemployment.rate..)
sd(data_employment$Unemployment.rate..)

?sd

#After reading a bit, we realize that it's probably better to write stuff like:
mean(data_employment$Unemployment.rate..,na.rm = T)
sd(data_employment$Unemployment.rate..,na.rm = T)

#Cuz otherwise we risk getting:
mean(data_employment$Employed)

mean(data_employment$Employed,na.rm = T)


#Where's the NA?

is.na(data_employment$Employed)

?which

which(is.na(data_employment$Employed))

data_employment[188,]

#Manually correct this?

data_employment[188,7] <- data_employment[188,6] - data_employment[188,8]

data_employment[188,7]

#Cool

#Introduction to Piping:

library(magrittr) #we need this to pipe
library(tidyverse) #we need this for some cool commands

#Let's create a new column called Employment_rate
#two ways to do this:

#R version:

#data_employment$Employment_rate = data_employment$Employed/data_employment$Labor.force



#Piping version:

data_employment %>% mutate(Employment_rate = Employed/Labor.force)

#Notice that the previous line doesn't modify the data.frame, so we need to tell R to "re-define" the data.frame:

data_employment <- data_employment %>% mutate(Employment_rate = Employed/Labor.force)

#This is a good moment to talk about different naming conventions:

names(data_employment)[10]

#snake_case:

names(data_employment)[10] <- "employment_rate"


#camel Case:

names(data_employment)[10] <- "employmentRate"


#Pascal Case:

names(data_employment)[10] <- "EmploymentRate"


#Let's learn how to summarize now (still Piping here of course, let's make it a habit)

# Suppose we want the average unemployment rate of each state:

unemployment_states <- data_employment %>% group_by(State) %>% summarise(avg_unemployment = mean(Unemployment.rate..))
#Notice a mistake here

#get CA:

employment_CA <- data_employment %>% subset(State=="CA")

unemployment_CA <- sum(employment_CA$Unemployed)/sum(employment_CA$Labor.force)


#What if we want the averages from all the variables:

#summarise_each

averages_states <- data_employment %>% group_by(State) %>% 
  summarise_each(funs(mean), Labor.force,Employed,Unemployed,Unemployment.rate..)


#Filtering:

averages_states %>% filter(Unemployment.rate..>9)

# Renaming:

#Let's rename the second column in the data_employment dataframe and put it in snake_case:
# But using dplyr and piping:

#library(dplyr) not necessary because it's part of tidyverse

data_employment <- data_employment %>% rename(state_fips_code=State.FIPS.code)













