library(tidyverse)
library(maps)
library(RColorBrewer)
library(forcats)
library(rvest)



Sys.setlocale("LC_TIME", "English")

# Scrape web data
data_raw <- read_html("https://tradingeconomics.com/matrix?g=top") %>%
  html_nodes(xpath = "//*[@id='ctl00_ContentPlaceHolder1_ctl01_GridView1']") %>% 
  html_table()

# create data for world map
world_map <- map_data(map = "world") %>% filter(region != "Antarctica")

# generic function for plotting
fill_map <- function(title, legend_fill){
  
  ggplot(df) +
    geom_map(aes(map_id = country, fill = fct_rev(bin)), map = world_map) +
    geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'lightgrey',fill = NA) +
    coord_fixed() +
    theme_void() +
    labs(title = title, caption = "Data: www.tradingeconomics.com") +
    scale_fill_manual(name = "Level", values = legend_fill)
}

# function to prepare the data
data_prep_map <- function(x, breaks, labels){
  
  # Pass the data frame
  x %>% 
    # recode certain entries: "United States" -> "USA"
    mutate(country = recode(str_trim(country), "United States" = "USA",
                            "United Kingdom" = "UK",
                            "Korea (Rep.)" = "South Korea")) %>% 
    # cut data into bins
    mutate(bin = cut(df[,2],
                     breaks = breaks,
                     labels = labels))
  
}


# When using a for-loop...
var_label <- c("interest_rate", "inflation_rate")
var_name <- c("Interest rate", "Inflation rate")

########
# Policy Rate
# Extract data frame from list
df <- data.frame(country = data_raw[[1]][[1]], interest_rate =data_raw[[1]][["Interest rate"]])
# Convert string with "%" to numeric
df$interest_rate <- as.numeric(sub("%", "", df$interest_rate))


# Get differences in country naming 
# setdiff(world_map$region, df$country)

# Define map
df <- data_prep_map(df,
                    breaks = c(-Inf, -0.000000001, 0.00000001, 3, 7, 10, Inf),
                    labels = c("Negative", "0%", ">0% but \u2264 3%",">3% but \u2264 7%", ">7% but \u2264 10%","\u2265 10%")) 

fill_map(title = paste0("Central Bank Policy Rates around the Globe: ", format(Sys.Date(), format = "%B %Y")),
         legend_fill = c("purple",rev(brewer.pal(3, name = "Greens")),"#ffe1e1","red"))

########
# Inflation Rate
# Extract data frame from list
df <- data.frame(country = data_raw[[1]][[1]], inflation_rate =data_raw[[1]][["Inflation rate"]])
# Convert string with "%" to numeric
df$inflation_rate <- as.numeric(sub("%", "", df$inflation_rate))

# Define map
df <- data_prep_map(df,
                    breaks = c(-Inf, 0.00000001, 3, 6, 10, Inf),
                    labels = c("\u2264 0%", ">0% but \u2264 3%",">3% but \u2264 6%", ">6% but \u2264 10%", 
                               "> 10%")) 

fill_map(title = paste0("Global Inflation Rates YoY: ", format(Sys.Date(), format = "%B %Y")),
         legend_fill = c(rev(brewer.pal(4, name = "Reds"))))


########
# Jobless Rate
# Extract data frame from list
df <- data.frame(country = data_raw[[1]][[1]], jobless_rate =data_raw[[1]][["Jobless rate"]])
# Convert string with "%" to numeric
df$jobless_rate <- as.numeric(sub("%", "", df$jobless_rate))


# Define map
df <- data_prep_map(df,
                    breaks = c(0, 3, 6, 10, Inf),
                    labels = c(">0% but \u2264 3%",">3% but \u2264 6%", ">6% but \u2264 10%", "> 10%")) 

# Draw map
fill_map(title = paste0("Unemployment Rates around the Globe: ", format(Sys.Date(), format = "%B %Y")),
         legend_fill = c(rev(brewer.pal(4, name = "Reds"))))


########
# Debt / GDP
# Extract data frame from list
df <- data.frame(country = data_raw[[1]][[1]], debt_gdp =data_raw[[1]][["Debt/GDP"]])
# Convert string with "%" to numeric
df$debt_gdp <- as.numeric(sub("%", "", df$debt_gdp))

# Define map
df <- data_prep_map(df,
                    breaks = c(0, 50, 100, 150, Inf),
                    labels = c(">0% but \u2264 50%",">50% but \u2264 100%", ">100% but \u2264 150%", "> 150%")) 

# Draw map
fill_map(title = paste0("Global Debt to GDP Ratios: ", format(Sys.Date(), format = "%B %Y")),
         legend_fill = c(rev(brewer.pal(4, name = "Reds"))))


########
# GDP YoY
# Extract data frame from list
df <- data.frame(country = data_raw[[1]][[1]], gdp_yoy =data_raw[[1]][["GDP YoY"]])
# Convert string with "%" to numeric
df$gdp_yoy <- as.numeric(sub("%", "", df$gdp_yoy))

# Define map
df <- data_prep_map(df,
                    breaks = c(-Inf, 2, 4, 6, Inf),
                    labels = c("\u2264 2%"," >2% but \u2264 4%", ">4% but \u2264 6%", "> 6%")) 

# Draw map
fill_map(title = paste0("Gross Domestic Prdocut (YoY) around the Globe: ", format(Sys.Date(), format = "%B %Y")),
         legend_fill = c(rev(brewer.pal(4, name = "Greens"))))


