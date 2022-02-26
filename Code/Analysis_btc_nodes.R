######## Bitoin Global Node Distribution ########


# Data preparation
data <- fromJSON(rawToChar(nodes$content))
df <- as.data.frame(data[["nodes"]])
df <- as.data.frame(t(df))

# convert location from character to factor
df$V8 <- as.factor(df$V8)
colnames(df)[colnames(df) == 'V8'] <- 'country'

df_plot <- data.frame(count = summary(df$country))

# convert country codes to country names
# NAs are not matched
df_plot$country_name <- countrycode(rownames(df_plot), "iso2c", "country.name")



# coarse
df_plot$count_group <- cut(df_plot$count, 
                           breaks = c(-Inf, 10, 50, 100, 500, Inf), 
                           labels = c("Less than 10", "10-50", "50-100", "100-500", "More than 500"))

#granular
df_plot$count_group <- cut(df_plot$count, 
                           breaks = c(-Inf, 5 , 10, 50, 100, 500, 1000, Inf), 
                           labels = c("Less than 5", "5-10", "10-50", "50-100", "100-500", "500-1000" ,"More than 1000"))

world_map <- map_data(map = "world")

# excluding some regions
world_map <- world_map %>% filter(region != "Antarctica")

# Adjust country names from df_plot to -> country_names from world_map
df_plot <- df_plot %>% mutate(country_name = recode(str_trim(country_name), "United States" = "USA"))


# With quantiles
# Exclude country_name == NA for quantile analysis
#df_plot <- df_plot %>% filter(country_name != "NA")

#quantiles <- quantile(df_plot$count, probs = seq(0, 1, 0.2))

#df_plot$count_group <- cut(df_plot$count, 
#                           breaks = c(0, 200, 600, 1000, 2000, Inf), 
#                           labels = c("0", "600-200", "1000-600", "2000-1000", "More than 2000"))

#########################################################
# Data Visualization

# Adjust fonts for resolution of 1600 x 900 
plot_btc_nodes <- ggplot(df_plot) +
  geom_map(aes(map_id = country_name, fill = fct_rev(count_group)), map = world_map) +
  geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'black', fill = NA) +
  scale_fill_manual(name = "Counts", values = rev(brewer.pal(7, name = "Greens"))) +
  theme_void() +
  labs(title ="    Bitcoin: Global Node Distribution", 
       subtitle = paste0("        as of ", Sys.Date()), 
       caption = "Data: www.bitnodes.io") +
  theme(legend.key.size = unit(2, 'cm'),
        legend.title = element_text(size=24),
        legend.text = element_text(size=20),
        plot.title = element_text(size=28),
        plot.subtitle = element_text(size=24),
        plot.caption = element_text(size=20))


#########################################################
# # resolution: 1200 x 675
# ggplot(df_plot) +
#   geom_map(aes(map_id = country_name, fill = fct_rev(count_group)), map = world_map) +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'black', fill = NA) +
#   scale_fill_manual(name = "Counts", values = rev(brewer.pal(7, name = "Greens"))) +
#   theme_void() +
#   labs(title ="    Bitcoin: Global Node Distribution", 
#        subtitle = paste0("    as of ", Sys.Date()), 
#        caption = "Data: www.bitnodes.io") +
#   theme(legend.key.size = unit(1.5, 'cm'),
#         legend.title = element_text(size=18),
#         legend.text = element_text(size=14),
#         plot.title = element_text(size=22),
#         plot.subtitle = element_text(size=18))

# ggplot(df_plot) +
#   geom_map(aes(map_id = country_name, fill = fct_rev(count_group)), map = world_map) +
#   geom_polygon(data = world_map, aes(x = long, y = lat, group = group), colour = 'black', fill = NA) +
#   expand_limits(x = world_map$long, y = world_map$lat) +
#   scale_fill_manual(name = "Counts", values = rev(brewer.pal(5, name = "Reds"))) +
#   theme_void() +
#   coord_fixed()
