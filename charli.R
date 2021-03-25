## Charli exploration
library(spotifyr)
# library(ggjoy) ## deprecated
library(ggridges)
library(tidyverse)
library(knitr)
library(ggcute)
# library(extrafont)
# extrafont::font_import()
# extrafont::loadfonts(device = "win")
windowsFonts("Courier" = windowsFont("Courier New"))

## Set working directory 
wd <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(wd)

## Read in 
charli <- readRDS(file = "data/charli.rds")

## Order Albums by year released
charli <- mutate(charli, album_name = reorder(charli$album_name, charli$album_release_year))

## Go time 
cont_var <- c("danceability", "energy", "speechiness", 
              "acousticness", "instrumentalness", "liveness", "valence")

## Polar plots
charli %>% 
  reshape2::melt(measure.var = cont_var) %>% 
  filter(track_name == "Silver Cross") %>% 
  ggplot(aes(x = variable, y = value, group = 1, fill = track_name)) +
  geom_polygon(show.legend = F) +
  coord_polar() +
  theme_sugarpill() + 
  scale_fill_sugarpill() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  labs(x = "", y = "") +
  ggtitle("Silver Cross")


## I do not like SUCKER (delete album please)
ggplot(charli, aes(x = valence, y = album_name, fill = album_name)) + 
  geom_density_ridges(show.legend = F) +
  scale_fill_fairyfloss() + 
  theme_fairyfloss() +
  labs(y = "Album Name")



charli %>% 
  reshape2::melt(measure.var = cont_var) %>% 
  ggplot(aes(x = variable, y = value, group = track_name)) +
  geom_polygon(show.legend = F, fill = NA, colour = "hotpink") +
  coord_polar() +
  theme_minimal() +
  theme(axis.text.y = element_blank()) +
  labs(x = "", y = "") +
  facet_wrap(vars(album_name))

charli %>% 
  reshape2::melt(measure.var = cont_var) %>% 
  ggplot(aes(x = variable, y = value, group = track_name, colour = "1")) +
  geom_polygon(show.legend = F, fill = NA) +
  coord_polar() +
  theme_sugarpill() +
  scale_color_sugarpill() +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank()) +
  labs(x = "", y = "") +
  facet_wrap(vars(album_name))


