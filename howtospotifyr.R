## https://github.com/charlie86/spotifyr
library(spotifyr)
library(ggjoy)
library(tidyverse)

## Get spotify client from: 
##  https://developer.spotify.com/documentation/general/guides/authorization-guide/
Sys.setenv(SPOTIFY_CLIENT_ID = 'xxxxx')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'xxxx')
access_token <- get_spotify_access_token()

charli <- get_artist_audio_features('Charli XCX')

saveRDS(charli, file = "charli.rds")