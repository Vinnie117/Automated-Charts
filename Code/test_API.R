######## Test to work with APIs and JSON data ########

library(tidyverse)
library(httr)           # to use API (GET requests)
library(jsonlite)       # to deal with JSONs
library(countrycode)    # to convert country codes to country names
library(scales)         # unit_format() -> formatting of y-scale


######## Fear and Greed Index 

# limit = 0 for max available history
resp <- GET("https://api.alternative.me/fng/?limit=0")


#convert the raw Unicode into a character vector that resembles the JSON format 
# -> result is truly JSON structure in character format
#rawToChar(resp$content)

# From a character vector, convert it to a list
data <- fromJSON(rawToChar(resp$content))

# convert to data frame
df <- as.data.frame(data[["data"]])

# Some data formatting
df$timestamp <- as.numeric(df$timestamp)
df$timestamp <- as.Date(as.POSIXct(df$timestamp, origin="1970-01-01"))
df$value <- as.numeric(df$value)


# get data from "Data Input.R"
df_plot <- merge(df, df_btc, by="timestamp")
df_plot$value_classification <- as.factor(df_plot$value_classification)


######## Visualization
# Daily data


# ggplot(data = df_plot, aes(x = timestamp, y = close, color = value)) +
#   geom_line(size = 1) +
#   scale_color_gradientn(colours = c("red",  "green"), 
#                         breaks = c(90, 10), 
#                         labels = c("Extreme \n Greed", "Extreme \n Fear")) +
#   labs(title ="Bitcoin Price by Fear and Greed Index", 
#        subtitle = paste0("As of ", Sys.Date()), 
#        color = "Index")


ggplot(data = df_plot, aes(x = timestamp, y = close, color = value)) +
  geom_point(size = 1) +
  scale_color_gradientn(colours = c("red",  "green"), 
                        breaks = c(90, 10), 
                        labels = c("Extreme \n Greed", "Extreme \n Fear")) +
  labs(title ="Bitcoin Price by Fear and Greed Index", 
       subtitle = paste0("Daily data: ", Sys.Date()-1), 
       color = "Index", x = "", y = "Price in USD", caption = "Data: www.coinmarketcap.com \n www.alternative.me") +
  scale_y_continuous(labels = unit_format(unit = "K", scale = 1e-3))




###########################################################################################################

######## Bitoin Global Node Distribution

library(rworldmap)
library(raster)


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

# Mapping
#map1 <- getMap(resolution = "li")                 # data: 178 elements, 1.1 Mb
#map2 <- getMap(resolution = "less islands")       # data: 178 elements, 1.1 Mb
#map3 <- getMap(resolution = "low")                # data: 244 elements, 4.7 Mb
map <- getMap(resolution = "coarse")             # data: 243 elements, 1.6 Mb

plot(map)


# get longitude and latitude of all countries as a list of data frames
world_coords <- lapply(as.integer(c(1:243)), function(i){
  df <- data.frame(map@polygons[[i]]@Polygons[[1]]@coords)
  df$region =as.character(map$NAME[i])
  colnames(df) <- list("long", "lat", "region")
  return(df)
})


# lists to data frame  
world_coords <- do.call("rbind", world_coords)

# merge data with map data
world_coords$value <- df_plot$count[match(world_coords$region,df_plot$country)]


# @Polygons[[1]] -> need to go further!! -> also @Polygons[[2]], @Polygons[[3]] ... until the end
# -> subregions of each country need to be bundled

# For each country -> for each of its subregions -> ...
test <- list()
sub_test <- list()
for (i in c(1:243)){
  
  for (j in c(1:length(map@polygons[[i]]@Polygons))){
    
    df <- data.frame(map@polygons[[i]]@Polygons[[j]]@coords)
    df$region =as.character(map$NAME[i])
    colnames(df) <- list("long", "lat", "region")
    sub_test[[j]] <- df
  }

  test[[i]] <-  do.call("rbind", sub_test)
}

test2 <- do.call("rbind", test)

# TRY THIS!!!!
# https://rpubs.com/emmavalme/rworldmap_vignette
# https://datavizpyr.com/how-to-make-world-map-with-ggplot2-in-r/
# https://geocompr.robinlovelace.net/adv-map.html
# http://blog.xavier-fim.net/2012/10/using-r-to-draw-maps-on-country-data/



######## Visualization
ggplot() + 
  geom_polygon(data = world_coords, 
               aes(x = long, y = lat, group = region, fill = value),
               colour = "black")


ggplot() + 
  geom_polygon(data = test2, 
               aes(x = long, y = lat, group = region),
               colour = "black")







