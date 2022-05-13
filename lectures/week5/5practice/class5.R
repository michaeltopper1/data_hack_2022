

rm(list = ls())

library(usmap)
library(sf)
library(pdftools)
library(tidyverse)

coc_awards <- pdf_text("FY2021_NY_Press_Report.pdf")
coc_awards %>% head()

#trial <- coc_awards %>% str_split("\n")

coc_awards <-  coc_awards %>% str_split("\n") %>% unlist()
coc_awards %>% head()

coc_awards <- coc_awards %>% str_to_lower() %>% str_trim

coc_awards %>% head(20)

index <- coc_awards %>% str_detect("total :") %>% which
coc_awards[c(105,145,283)]

coc_awards[index]
coc_awards[index+2]

index_money <- index[-25]
coc_awards[index_money]

index_name <- index+2

coc_awards %>% head(20)

index_name <- c(11,index_name[-c(24:25)])

coc_awards[index_name]

coc_ny_state <- tibble("coc_name" = coc_awards[index_name],
                       "coc_fed_money" = coc_awards[index_money])

coc_ny_state <- coc_ny_state %>% tidyr::extract(coc_fed_money,into = "coc_fed_money",
                                ".{1,}\\$(.{1,})")

?str_replace_all

coc_ny_state <- coc_ny_state %>%  
  mutate(coc_fed_money = str_replace_all(coc_fed_money,",",""))

typeof(coc_ny_state$coc_fed_money)

coc_ny_state <- coc_ny_state %>% 
  mutate(coc_fed_money = as.numeric(coc_fed_money))

plot_usmap("counties")

plot_usmap(regions = "counties",fill = "yellow",
           alpha = 0.65, exclude = "FL")

ny_hm <- read_csv("ny_hmfm.csv")

plot_usmap(data = ny_hm, include = "NY", 
           values = "overall_homeless" )

#hint: mutate(fed_money_per_homeless = / )

ny_hm <- ny_hm %>% 
  mutate(fed_money_per_homeless = fed_money/overall_homeless)

plot_usmap(data = ny_hm, include = "NY", 
           values = "fed_money_per_homeless")
