# Camilo Abbate
# Week 5 Data Hack 
# 04/29/2022

rm(list = ls())

library(usmap)
library(sf)
library(pdftools)
library(tidyverse)

coc_awards <- pdf_text("FY2021_NY_Press_Report.pdf")

coc_awards %>% head(1)

coc_awards <- coc_awards %>% str_split("\n") %>% unlist()

coc_awards %>% head(5)

coc_awards <- coc_awards %>% str_to_lower() %>% str_trim

coc_awards %>% str_detect('total :') %>% which

#let's call this index:

index <- coc_awards %>% str_detect('total :') %>% which

coc_awards[index]
coc_awards[index+1]
coc_awards[index+2]

index_names <- index+2

coc_awards %>% head(20)

index_names <- c(11,index_names)

index_names <- index_names[-c(25:26)]

coc_awards[index_names]

coc_awards[index_names] %>% as_tibble()

coc_table <- coc_awards[index_names] %>% as_tibble()

coc_awards[index][1:24]

coc_table <-  coc_table %>% mutate(coc_totals = coc_awards[index][1:24])

coc_table <- coc_table %>% tidyr::extract(coc_totals, into = "total_fed_money", ".{1,}\\$(.{1,})")

#almost there
coc_table <- coc_table %>% mutate(total_fed_money = str_replace_all(total_fed_money,",",""))

#need to be numeric huh
coc_table <- coc_table %>% mutate(total_fed_money = as.numeric(total_fed_money))

#Let's begin with the good stuff now eh:

plot_usmap(regions = "states")

plot_usmap(regions = "counties")


plot_usmap(regions = "counties") + labs(title="This is a map of the US", subtitle = "And all the counties")

#more specifics:

plot_usmap("counties",fill = "yellow")

plot_usmap("counties",fill = "yellow", alpha = 0.2, exclude = c(.east_south_central))


ny_hm <- read_csv("ny_hmfm.csv")












