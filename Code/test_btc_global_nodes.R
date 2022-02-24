######## Test to work with APIs and JSON data ########
######## Bitoin Global Node Distribution

library(tidyverse)
library(httr)           # to use API (GET requests)
library(jsonlite)       # to deal with JSONs
library(countrycode)    # to convert country codes to country names
library(scales)         # unit_format() -> formatting of y-scale
library(rworldmap)
library(raster)
library(RColorBrewer)


###############################################
# Data preparation

resp <- GET("https://bitnodes.io/api/v1/snapshots/latest")
data <- fromJSON(rawToChar(resp$content))
df <- as.data.frame(data[["nodes"]])
df <- as.data.frame(t(df))

# convert location from character to factor
df$V8 <- as.factor(df$V8)
colnames(df)[colnames(df) == 'V8'] <- 'country'

df_plot <- data.frame(count = summary(df$country))

# convert country codes to country names
# NAs are not matched
df_plot$country_name <- countrycode(rownames(df_plot), "iso2c", "country.name")




df_plot$count_group <- cut(df_plot$count, 
                           breaks = c(-Inf, 200, 600, 1000, 2000, Inf), 
                           labels = c("Less than 200", "600-200", "1000-600", "2000-1000", "More than 2000"))

world_map <- map_data(map = "world")

# excluding some regions
world_map <- world_map %>% filter(region != "Antarctica")

# Adjust country names from df_plot to country_names from world_map
df_plot <- df_plot %>% mutate(country_name = recode(str_trim(country_name), "United States" = "USA"))



###############################################
# Data Visualization

ggplot(df_plot) +
  geom_map(aes(map_id = country_name, fill = fct_rev(count_group)), map = world_map) +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'black', fill = NA) +
  scale_fill_manual(name = "Counts", values = rev(brewer.pal(5, name = "Greens")))

ggplot(df_plot) +
  geom_map(aes(map_id = country_name, fill = fct_rev(count_group)), map = world_map) +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'black', fill = NA) +
  expand_limits(x = world_map$long, y = world_map$lat) +
  scale_fill_manual(name = "Counts", values = rev(brewer.pal(5, name = "Reds"))) +
  theme_void() +
  coord_fixed()
