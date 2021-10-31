########## MASTER FILE ##########

# to generate all monthly charts automatically

# load data
source("Code/Data Input.R")


# generate heatmap of monthly returns
source("Code/Analysis_heatmap.R")
plot_heatmap

# generate stock to flow
source("Code/Analysis_stock_to_flow.R")
plot_price_halvings
plot_s2f











