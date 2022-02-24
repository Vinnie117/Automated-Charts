######## Bitcoin Fear and Greed Index ########

#convert the raw Unicode into a character vector that resembles the JSON format 
# -> result is truly JSON structure in character format
#rawToChar(sentiment$content)

# From a character vector, convert it to a list
data <- fromJSON(rawToChar(sentiment$content))

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

plot_btc_sentiment <- ggplot(data = df_plot, aes(x = timestamp, y = close, color = value)) +
  geom_point(size = 1) +
  scale_color_gradientn(colours = c("red",  "green"), 
                        breaks = c(90, 10), 
                        labels = c("Extreme \n Greed", "Extreme \n Fear")) +
  labs(title ="Bitcoin Price by Fear and Greed Index", 
       subtitle = paste0("Daily data: ", Sys.Date()-1), 
       color = "Index", x = "", y = "Price in USD", caption = "Data: www.coinmarketcap.com \n www.alternative.me") +
  scale_y_continuous(labels = unit_format(unit = "K", scale = 1e-3))
