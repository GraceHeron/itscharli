## Charli exploration
library(spotifyr)
library(ggjoy)
library(tidyverse)
library(knitr)

## Set working directory 
wd <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)

## Read in 
charli <- readRDS(file = "charli.rds")

## Go time 
cont_var <- c("danceability", "energy", "speechiness", 
              "acousticness", "instrumentalness", "liveness", "valence")

## Polar plots
charli %>% 
  reshape2::melt(measure.var = cont_var) %>% 
  filter(track_name == "Silver Cross") %>% 
  ggplot(aes(x = variable, y = value, group = 1)) +
  geom_polygon(show.legend = F, fill = NA, colour = "hotpink") +
  coord_polar() +
  theme_minimal() +
  theme(axis.text.y = element_blank()) +
  labs(x = "", y = "") +
  ggtitle("Next Level Charli")

## I do not like SUCKER (delete album please)
ggplot(charli, aes(x = valence, y = album_name)) + 
  geom_joy() + 
  theme_joy() 
