########## MASTER FILE ##########

# to generate all monthly charts automatically

# load data
source("Data Input.R")


# generate heatmap of monthly returns
source("Analysis_heatmap.R")
plot_heatmap

# generate stock to flow
source("Analysis_stock_to_flow.R")
plot_price_halvings
plot_s2f











