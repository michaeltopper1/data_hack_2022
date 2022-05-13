# Week 7 script

# General plan: Import 10-12 years of enrollment from all highschools in PY (subset clearly)

# use my function to merge them, put them all together & stuff

# do many regressions, store the F-test in a matrix/list

#grapphy?

# three topics:

## import 1

## functions  2

## F-Test  3

rm(list = ls());

library(tidyverse)
library(readxl)

if (!require("pacman")) install.packages("pacman"); 
library(pacman)
pacman::p_load("tidyverse","sandwich","etable","readxl","broom","modelsummary","fmsb","magrittr","lubridate")



#Where are we?

getwd()

enr2002 <- read_excel("camilos_parts/Week 7/enrollment/enrollment_2002.xlsx")

# enr2002 %>% ggplot() + geom_point(aes(x =  , y = )) + geom_line()
# enr2002 %>% hist()

enr2003 <- read_excel("camilos_parts/Week 7/enrollment/enrollment_2003.xlsx") #No, I'm not going to do that


#...


# 1

## 1.1 give me the path (folder with data) and I'll tell you the names of the files there:
# listy <- list.files(full_path)

full_path <- getwd()

full_path <- paste0(full_path,"/camilos_parts/Week 7/enrollment")

listy <- list.files(full_path)


## 1.2 import all of them! but wait, one by one?

enr2002 <- read_excel(paste0(full_path,"/",listy[1]))
# Instead of doing: read_excel(".....listy[1]") 
# and....... doing: read_excel(".....listy[2]")
# ....
# and....... doing: read_excel(".....listy[9]")


# we do: Import everything at once!
#For that, we have lapply!!!
# give me the function and path and I'll tell you the data:

# full_path + listy
#lapply()
#?lapply()

paste0(full_path,"/",listy)

paste0(listy)

listy2 <- paste0(full_path,"/",listy)

list_data <- lapply(listy2,read_excel)  #WARNING! THIS IS GOING TO CREATE A LIST!

list_data[1]


list_data[9]

#Great! We need to transform this into dataframes so we can merge it eventually:
enr2008 <- as.data.frame(list_data[7])

#    ? What would you do next?

# we are going to loop:


listy3 <- paste0()

#give me the path and I'll give you the dataframes:
power_import <- function(path){
    # The full path is a character unidimensional variable: the full directory of the
  # folder where the data files (xlsx) are stored
  thenames <- "enrollment_" #Just change this part if you have different names 
  f_listy <- list.files(full_path)
  f_listy2=glue::glue(paste0(full_path,"/{f_listy}"))
  f_list_data <- lapply(f_listy2,read_excel)
  f_how_long <- length(f_list_data)
  for (i in 1:f_how_long) {
    assign(paste0(thenames, i+2001), as.data.frame(list_data[[i]]),envir = .GlobalEnv)
  }
  
}
full_path

power_import(full_path)


#Function to import data sets hehe
big_import <- function(full_path){
  thenames <- "rep" #Just change this part if you want to go aprobados, matricula or repitentes
  if (typeof(full_path)!="character"){
    print("Wrong, argument needs to be a character")
  }
  else {
    listy <- list.files(full_path)
    listy2=glue::glue(paste0(full_path,"/{listy}"))
    list_data <- lapply(listy2,read_excel)
    how_long <- length(list_data)
    for (i in 1:how_long) {
      assign(paste0(thenames, i+2001), as.data.frame(list_data[[i]]),envir = .GlobalEnv)
    }
  }
}


#More later
#disaggregate last part of function or leave them for hw?




# You want to store the data?

# filepath <- file.path("01_data")
# file = file.path(filepath,"rep.RData")
# save(DATAFRAME,file=file)





