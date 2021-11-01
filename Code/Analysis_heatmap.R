############# A heatmap of monthly Bitcoin returns #############


######## Data Preparation

# convert to xts object required by quantmod
df <- as.data.frame(df_btc)
ts <- xts(df[,-1], order.by=df[,1])

#### calculate monthly returns
monthly_returns <- monthlyReturn(ts)
monthly_returns <- monthly_returns[-1,]

# convert back to dataframe required by ggplot
df <- data.frame(timestamp = index(monthly_returns), return = monthly_returns)
df$month <- format(df$timestamp, "%b")
df$year <- format(df$timestamp, "%Y")

# create months for heatmap
year = unique(format(df$timestamp, "%Y"))
month = c("Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
times = expand.grid(month=month, year=year)

# final data frame
data <- merge(times,df, by=c("year","month"), all = TRUE)

bins <- cut(data$monthly.returns, breaks = c(-1, -0.3, -0.2, -0.1, 0, 0.1, 0.2, 0.3, 10), 
            labels = c("Worse -30%", "-20% to -30%", "-20% to -10%", "-10% to 0%", "0 to 10%", "10% to 20%", "20% to 30%", "Better +30%"))

data$bins <- bins



######## Visualization

plot_heatmap <- ggplot(data, aes(month, year, fill= bins)) + 
  geom_tile(colour="white",size=0.25) +
  labs(x="",y="", title = "Bitcoin: Heatmap of Monthly Returns", fill = "Monthly Return",
       caption = "Data: www.coinmarketcap.com") +
  scale_fill_manual(values=c("grey90", "#BF1616","#FF4242","#FF837E","#FFBFB4","#96ED89","#45BF55","#168039", "#044D29"),
                    breaks = c(NA, "Worse -30%", "-20% to -30%", "-20% to -10%", "-10% to 0%", "0 to 10%", "10% to 20%", "20% to 30%", "Better +30%"),
                    labels = c("No data", "Worse -30%", "-20% to -30%", "-20% to -10%", "-10% to 0%", "0 to 10%", "10% to 20%", "20% to 30%", "Better +30%"),
                    na.value = "grey90") +
  guides(fill = guide_legend(reverse = TRUE))




