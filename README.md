Spotify Visualisation
================
Grace Heron
29/07/2020

Using the ‘spotifyr’\[<https://github.com/charlie86/spotifyr>\]. Is a
neat R wrapper for Spotify’s Web API

## Charli XCX Visualisation

I went/still going through a charli xcx phase.

## Grimes Visualisation

I did my main project for MXB262 on Grimes. Can’t wait for their break
up album (bye bye elon rat).

### Why?

  - I have listened to most of Grimes’s discography
  - I want to justify my opinions
  - Grime’s is known for ‘edgy’ music but is it really?

### Visualisation 1:

``` r
## Read in grimes discography (singles, demos, albums, collaborations)
grimes <- readRDS(file = "data/grimes_all.rds")

fix_tracknames <- function(df){
  df <- distinct(df, album_name, track_name, .keep_all=T)
  df$unique_ID <- 1:nrow(df)
  albums_to_fix <- pull(
    filter(mutate(left_join(tally(group_by(df, album_name)), 
                            summarise(group_by(df, album_name), numtracks = max(track_number)),
                            by = "album_name"), 
                  is_something_wrong = case_when(n != numtracks ~ "Yes", TRUE ~ "no")), 
           is_something_wrong == "Yes"), album_name)
  for(select_album in albums_to_fix){
    tracks_to_fix <- pull(
      filter(tally(group_by(filter(df, album_name == select_album), track_number)), n > 1), track_number)
    for(select_track in tracks_to_fix){
      uni_id <- df[df$album_name == select_album & df$track_number == select_track, "unique_ID"][1]
      df <- df[!(df$unique_ID == uni_id), ]
    }
  }
  return(select(df, -unique_ID))
}

## Remove duplicated entries (spotify API not perfect)
grimes <- fix_tracknames(grimes)
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
## Need to filter out songs from other artists that are on the same album grimes' feature is on
distinct_album_names <- c("Miss Anthropocene","Art Angels","Visions","Halfaxa",
                          "Geidi Primes","Miss Anthropocene (V1)","Phone Sex", 
                          "Darkbloom","Go (feat. Blood Diamonds)","Go","Entropy", 
                          "REALiTi (Demo)","Kill V. Maim (Little Jimmy Urine Remix)",
                          "Pynk (feat. Grimes) [King Arthur Remix]","My Name is Dark",
                          "So Heavy I Fell Through the Earth","VIOLENCE",
                          "We Appreciate Power (Radio Edit)","Pretty Dark (Demo)",
                          "We Appreciate Power","L$D (Don't Smoke My Blunt Bitch) [feat. Grimes & Kreayshawn]")
distinct_tracks <- c("Pynk (feat. Grimes)","Medieval Warfare","Take Me Away (feat. Grimes)",
                     "Brotherhood - Feat. Grimes","Eyes Be Closed - Grimes Remix")

## Only include albums and featured singles
grimes <- filter(grimes,album_name %in% distinct_album_names | track_name %in% distinct_tracks) 

## Selected continuous music attributes
cont_var <- c("danceability", "energy","acousticness",
              "instrumentalness", "liveness", "valence")

## PLOT!
ggplot(grimes, aes(x = album_release_year,
                   y = valence)) +
  geom_hline(yintercept = 0.5, colour = "gray70",
             linetype = "dashed")+
  geom_smooth(fill = "mediumpurple1", colour = "mediumpurple1",
              linetype = "dashed", size = 0.5,
              method = "lm", formula = 'y ~ x') +
  geom_boxplot(aes(group = album_release_year),
               fill = NA, outlier.shape = 21)+
  theme_classic() +
  scale_x_continuous(breaks = seq(2010, 2020, 1)) +
  scale_y_continuous(limits = c(0, 1),
                     breaks = seq(0, 1, 0.25)) +
  labs(x = "Release Year",
       y = "Valence (music positiveness)") +
  ggtitle("Grimes' valence over the years",
          subtitle = "Includes albums, singles and collaborations")
```

![](README_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

### Visualisation 2:

``` r
## Read in grimes data (albums only)
grimes <- readRDS(file = "data/grimes.rds")

## Remove demo version of most recent album
grimes <- filter(grimes, album_name != "Miss Anthropocene (V1)")

## Remove duplicated entries (due to bad data entry - capitalisation)
grimes <- fix_tracknames(grimes)
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
## Ensure albums are ordered chronologically 
grimes$album_name <- factor(
  grimes$album_name, 
  ordered = T, 
  levels = c("Miss Anthropocene","Art Angels",
             "Visions","Halfaxa","Geidi Primes"))

## Combine Year and Album name as a column (for plotting)
grimes <- mutate(grimes, album_info = paste(album_release_year, album_name, sep = " - "))

## Selected continuous music attributes
cont_var <- c("danceability", "energy", "acousticness", 
              "instrumentalness", "liveness", "valence")

## store in new variable 
grimes_scaled <- grimes

## Melt by music attributes
grimes_scaled <- grimes_scaled %>% 
  reshape2::melt(measure.var = cont_var)

## Make sure ordered by album (chronological)
grimes_scaled$album_info <- factor(grimes_scaled$album_info, ordered = T)

## PLOT!
ggplot(grimes_scaled, 
       aes(x = variable, y = value, group = track_name)) +
  geom_polygon(show.legend = F, alpha = 0.05, size = 0.1, 
               colour = "mediumpurple1", fill = "mediumpurple1") +
  coord_polar() +
  theme_minimal() +
  theme(axis.text.y = element_blank(),
        axis.text.x = element_blank()) +
  labs(x = "", y = "") +
  facet_grid(cols = vars(album_info)) + 
  ggtitle(
    "Grimes' Album Fingerprints", 
    subtitle = "Song attributes: acousticness, danceability, energy, instrumentalness, liveness, valence")
```

![](README_files/figure-gfm/vis1-1.png)<!-- -->

### Visualisation 3:

``` r
## Read in all of these ladies
grimes <- readRDS(file = "data/grimes.rds") %>% 
  dplyr::select(-album_images, -artists, -available_markets) %>% 
  filter(album_name == "Miss Anthropocene") %>%
  fix_tracknames()
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
ariana <- readRDS(file = "data/ariana.rds") %>% 
  dplyr::select(-album_images, -artists, -available_markets) %>% 
  filter(album_name == "Sweetener") %>%
  fix_tracknames()
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
billie <- readRDS(file = "data/billie.rds") %>% 
  dplyr::select(-album_images, -artists, -available_markets) %>% 
  filter(album_name == "WHEN WE ALL FALL ASLEEP, WHERE DO WE GO?") %>%
  fix_tracknames()
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
taylor <- readRDS(file = "data/taylor.rds") %>% 
  dplyr::select(-album_images, -artists, -available_markets) %>% 
  filter(album_name == "Lover") %>%
  fix_tracknames()
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
halsey <- readRDS(file = "data/halsey.rds") %>% 
  dplyr::select(-album_images, -artists, -available_markets) %>% 
  filter(album_name == "Manic") %>%
  fix_tracknames()
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
cardi <- readRDS(file = "data/cardi.rds") %>% 
  dplyr::select(-album_images, -artists, -available_markets) %>% 
  filter(album_name == "Invasion of Privacy") %>%
  fix_tracknames()
```

    ## `summarise()` ungrouping output (override with `.groups` argument)

``` r
## Combine into 1 data frame
femalepop <- bind_rows(grimes, ariana, billie, taylor, halsey, cardi)

## Remove duplicated entries (API not perfect)
grimes <- distinct(grimes, track_name, .keep_all=T)

## Selected continuous variables for comparison
cont_var <- c("danceability", "energy", #"speechiness",
              "acousticness", "instrumentalness", "liveness", "valence")

## Transpose data frame (for correlation matrix calculations)
t.femalepop <- as.data.frame(t(femalepop[,cont_var]))

## Add respective column names lost in transpose
colnames(t.femalepop) <- femalepop$artist_name

## Correlation matrix
femalepop.cor <- cor(t.femalepop)

## Remove low correlation 
femalepop.cor[femalepop.cor < 0.95] <- 0

## Set set for reproducibility 
set.seed(314)

## Create network from correlation matrix
net_edges <- graph_from_adjacency_matrix(femalepop.cor, weighted = T, mode = "undirected", diag = F)

## 6 distinct colours for 6 artists
colrs <- brewer.pal(6, "Paired")

## Set colors per artist
V(net_edges)$color <- V(net_edges)$name
V(net_edges)$color <- gsub(pattern="Grimes", replacement=colrs[6], x=V(net_edges)$color)
V(net_edges)$color <- gsub(pattern="Ariana Grande", replacement=colrs[5], x=V(net_edges)$color)
V(net_edges)$color <- gsub(pattern="Billie Eilish", replacement=colrs[4],x=V(net_edges)$color)
V(net_edges)$color <- gsub(pattern="Taylor Swift", replacement=colrs[3],x=V(net_edges)$color)
V(net_edges)$color <- gsub(pattern="Halsey", replacement=colrs[2], x=V(net_edges)$color)
V(net_edges)$color <- gsub(pattern="Cardi B", replacement=colrs[1], x=V(net_edges)$color)

## Plot network 
plot.igraph(
  simplify(net_edges),
  layout=layout.fruchterman.reingold,
  vertex.label=NA,
  vertex.color=V(net_edges)$color,
  vertex.size=5,
  edge.arrow.size=.5, 
  main = "Top 5 Female Pop Artists and Grimes",
  sub = "Similarity between songs from most recent album per artist")

## Add legend 
legend(
  "bottomright", 
  legend = c("Cardi B","Halsey","Taylor Swift","Billie Eilish","Ariana Grande","Grimes"), 
  col = colrs,
  pch=19,cex=1,bty="n")
```

![](README_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->
