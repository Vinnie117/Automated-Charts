########## MASTER FILE ##########
# to generate all monthly charts automatically

# load function
source("Code/Functions.R")

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
ggsave("Plots/plot_btc_market_cap.png", width = 600, height = 335, dpi = 100 ,units = "px")

# Bitcoin: Generate market dominance
source("Code/Analysis_market_dominance.R")
plot_market_dominance
ggsave("Plots/plot_market_dominance.png", width = 600, height = 335, dpi = 100 ,units = "px")

# Economics: USD M2 money supply
source("Code/Analysis_usd_m2.R")
plot_m2

# Economics: U.S. CPI inflation YoY
source("Code/Analysis_usd_cpi.R")
plot_us_cpi

# Economics: U.S. Margin Accounts at Brokers and Dealers
source("Code/Analysis_econ_margin_accounts.R")
plot_margin_accounts
ggsave("Plots/plot_margin_accounts.png", width = 600, height = 335, dpi = 100 ,units = "px")

# Finance: 4 Barcharts of monthly performances - BTC vs other assets
source("Code/Analysis_finance_btc_vs_assets_bars.R")
list_barplots_btc_vs_assets[["barplot_btc_vs_index"]]
ggsave("Plots/barplot_btc_vs_index.png", width = 600, height = 335, dpi = 100 ,units = "px")
list_barplots_btc_vs_assets[["barplot_btc_vs_dm"]]
ggsave("Plots/barplot_btc_vs_dm.png", width = 600, height = 335, dpi = 100 ,units = "px")
list_barplots_btc_vs_assets[["barplot_btc_vs_em"]]
ggsave("Plots/barplot_btc_vs_em.png", width = 600, height = 335, dpi = 100 ,units = "px")
list_barplots_btc_vs_assets[["barplot_btc_vs_commodities"]]
ggsave("Plots/barplot_btc_vs_commodities.png", width = 600, height = 335, dpi = 100 ,units = "px")


# Finance: 4 Linecharts with daily data of yearly performances - BTC vs other assets
source("Code/Analysis_finance_btc_vs_assets_lines.R")
list_linecharts_btc_vs_assets[["linechart_btc_vs_index"]]
ggsave("Plots/linechart_btc_vs_index.png", width = 600, height = 335, dpi = 100 ,units = "px")
list_linecharts_btc_vs_assets[["linechart_btc_vs_em"]]
ggsave("Plots/linechart_btc_vs_em.png", width = 600, height = 335, dpi = 100 ,units = "px")
list_linecharts_btc_vs_assets[["linechart_btc_vs_dm"]]
ggsave("Plots/linechart_btc_vs_dm.png", width = 600, height = 335, dpi = 100 ,units = "px")
list_linecharts_btc_vs_assets[["linechart_btc_vs_commodities"]]
ggsave("Plots/linechart_btc_vs_commodities.png", width = 600, height = 335, dpi = 100 ,units = "px")


# Finance: 1 vertical barchart with monthly performance of BTC vs 11 stock sectors
source("Code/Analysis_finance_btc_vs_sectors.R")
plot_btc_vs_sectors
ggsave("Plots/plot_btc_vs_sectors.png", width = 600, height = 800, dpi = 100 ,units = "px")

# Bitcoin: Fear and Greed Index
source("Code/Analysis_btc_sentiment.R")
plot_btc_sentiment
ggsave("Plots/plot_btc_sentiment.png", width = 600, height = 335, dpi = 100 ,units = "px")




# Cleaning
# remove raw data to clean up global environment (doing so in function is bad idea)
rm(list = c(index, em, dm, commodities, sectors))




