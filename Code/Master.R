########## MASTER FILE ##########
# to generate all monthly charts automatically


# load data
source("Code/Data Input.R")

# Bitcoin: Generate heatmap of monthly returns
source("Code/Analysis_heatmap.R")
plot_heatmap
ggsave("Plots/plot_heatmap.png", width = 600, height = 335, dpi = 100 ,units = "px")

# Bitcoin: Generate stock to flow
source("Code/Analysis_stock_to_flow.R")
plot_price_halvings
# plot_s2f
ggsave("Plots/plot_price_halvings.png", width = 600, height = 335, dpi = 100 ,units = "px")


# Bitcoin: Market Cap by Month
source("Code/Analysis_bitcoin_market_cap.R")
plot_btc_market_cap


# Bitcoin: Generate market dominance
source("Code/Analysis_market_dominance.R")
plot_market_dominance


# Economics: USD M2 money supply
source("Code/Analysis_usd_m2.R")
plot_m2


# Economics: U.S. CPI inflation YoY
source("Code/Analysis_usd_cpi.R")
plot_us_cpi


# Finance: 4 Barcharts of monthly performances - BTC vs other assets
source("Code/Analysis_finance_btc_vs_assets_bars.R")
list_barplots_btc_vs_assets[["barplot_btc_vs_index"]]
list_barplots_btc_vs_assets[["barplot_btc_vs_dm"]]
list_barplots_btc_vs_assets[["barplot_btc_vs_em"]]
list_barplots_btc_vs_assets[["barplot_btc_vs_commodities"]]


# Finance: 4 Linecharts with daily data of yearly performances - BTC vs other assets
source("Code/Analysis_finance_btc_vs_assets_lines.R")
list_linecharts_btc_vs_assets[["linechart_btc_vs_index"]]
list_linecharts_btc_vs_assets[["linechart_btc_vs_em"]]
list_linecharts_btc_vs_assets[["linechart_btc_vs_dm"]]
list_linecharts_btc_vs_assets[["linechart_btc_vs_commodities"]]


# Finance: 1 vertical barchart with monthly performance of BTC vs 11 stock sectors
source("Code/Analysis_finance_btc_vs_sectors.R")
plot_btc_vs_sectors







# Cleaning
# remove raw data to clean up global environment (doing so in function is bad idea)
rm(list = c(index, em, dm, commodities, sectors))




