# Ideas for upcoming charts
-> Look for charts that update through time and visibly show change

Plot with CPI
- good for automated charts
- monthly CPI change as bars
- cumulative CPI changes (cumprod()) as line
- past 3 years
- 2 y axis

Plot with correlation of returns
- bad for automated charts becasause new data is just another dot in the scatterplot -> not much value added
- scatterplot of daily returns
- x: BTC, y: other asset (crypto?)
- x: BTC, y: BTC previous day

Plot with correlation of returns over asset classes
- Flipped bar chart
- 12 month rolling correlation?
- For each end of month?

Histogram of weekly BTC returns?

Asset simulation
- good for automated charts
- line charts for longer time horizons, bar charts for month periods?
- Price of BTC and other assets (crypto?) indexed at 100 for start of period -> then evolvment over time
- For period beginning each month? Each year? On a rolling 12 month basis? -> do for fixed and rolling starting point and for varying investment horizon
- "An innvestment of 100 in BTC at the start of the month would have yielded ... other assets (cryptos?) would have yielded...
- Data quality for indices at Yahoo Finance should be fine (unlike for stocks) -> can use quantmod

Bitcoin market cap growth
- good for automated charts
- bar chart
- past 3 years
- growth / reduction of market cap eacht month ?
- Or: absolute number of market cap of BTC per month and then growth indicated as text on the bars

Central Banks
- monthly data?
- balance sheet total assets

