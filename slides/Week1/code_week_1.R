#Week 1 code for:  The Slides and the exercises at the end

#Very important always:

rm(list = ls());


# Slides

#load the package:
library(readxl)


#load the data:
#getwd()

data_employment <- read_excel("C:/Users/camel/Desktop/datahack_class1/Week1_data/employment12.xlsx")

data_employment <- data_employment[1:3219,]

#read.csv is part of the R base functions
bitcoin <- read.csv("C:/Users/camel/Desktop/datahack_class1/Week1_data/BTC-USD.csv")

typeof(bitcoin$Date)

wharf_sb <- read.delim("C:/Users/camel/Desktop/datahack_class1/Week1_data/wharf.txt")

getwd()

#so, same dataset, different dir:

setwd("C:/Users/camel/Desktop/datahack_class1/Week1_data/")

wharf_sb <- read.delim("wharf.txt")

another_wharf <- read.delim("../wharf2.txt")


#close this file, create the project and open the version b of this rscript

