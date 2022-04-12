library(tidyverse)
library(lubridate)

theme_set(theme_minimal())
spotify <- read_csv("homework_assignments/homework_2/streaming_data.csv")

spotify <- spotify %>% 
  mutate(seconds_played = ms_played/1000,
         minutes_played = seconds_played/60) %>% 
  mutate(end_time= with_tz(end_time, tz = "America/Los_Angeles")) %>% 
  mutate(time_played = hms::as_hms(end_time), .before = 1) %>% 
  mutate(hour_played = hour(time_played))

spotify %>% 
  filter(seconds_played > 5) %>% 
  mutate(month = month(end_time)) %>% 
  ggplot(aes(hour_played)) +
  geom_histogram() +
  facet_wrap(~month) +
  labs(y = "Count", x = "Hour of Day Played")
spotify %>% 
  filter(seconds_played > 5) %>% 
  mutate(month = month(end_time, label = T)) %>% 
  ggplot(aes(hour_played)) +
  geom_density(fill = "blue", alpha = 0.5) +
  facet_wrap(~month) +
  labs(y = "Count", x = "Hour of Day Played")

## put on where donda was released.
spotify %>% 
  filter(artist_name == "Kanye West") %>% 
  mutate(month = month(end_time), year = year(end_time)) %>%
  mutate(month_date = ymd(paste0(year, "-", month, "-1"))) %>% 
  group_by(month_date) %>% 
  summarize(month_count = n()) %>% 
  ggplot(aes(month_date, month_count)) +
  geom_line() +
  geom_point() +
  geom_vline(xintercept = ymd("2021-08-29"), linetype = "dashed", color = "red") +
  annotate(x = ymd("2021-08-29"), y = Inf, label = 'Donda Release Date', geom = "label",
           vjust = 1) +
  labs(x = " ", y = "Monthly Play Count", title = "Kanye West Streams in Past Year")

spotify %>% 
  count(artist_name, sort = T) %>% 
  head(20) %>% 
  mutate(artist_name = fct_reorder(artist_name, n)) %>% 
  ggplot(aes(x = n, y = artist_name)) +
  geom_col(fill = "green", alpha = 0.5) +
  geom_text(aes(label = n), hjust = -0.1) +
  labs(x = "Number of Streams", y = " ", title = "Top Artists Streamed Past Year",
       subtitle = "Total Plays: 172") +
  ggthemes::theme_tufte() +
  theme(plot.background = element_rect(fill = "black"),
        axis.text.x = element_text(color = "white"),
        axis.text.y = element_text(color = "white"),
        plot.title = element_text(color = "White"),
        plot.subtitle = element_text(color = "White"))


