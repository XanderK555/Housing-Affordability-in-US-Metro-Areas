# Housing Affordability in U.S. Metro Areas

By Alexander Kasternakis

## Overview

This project explores housing data in the top 100 metro areas in the U.S. to analyze changes in housing affordability over time. Key metrics include real estate market trends, population growth, and per capita income. By examining these factors, we provide insights into how economic and demographic shifts have influenced the housing market.

## Objective

This analysis aims to answer the following questions:

1. How has the housing market changed in different metros over time?
2. How has population growth affected the housing market?
3. Are fluctuations in housing prices keeping up with rising income?
4. Which metro areas and regions have experienced the most significant shifts in affordability?

## Introducing the Data

#### Housing Market Data

The dataset used in this analysis is sourced from Realtor.com and spans from July 2016 to January 2025, with monthly updates. It includes key housing market indicators such as median and average listing prices, total listing counts, price per square foot, and medain days on market, all broken down by metro area. Click [here](https://www.realtor.com/research/data/) to view the data source.

#### Population Data

The population data used is from the U.S. Census and comtains annual estimates from 2016 to 2023, broken down by metro area. The data source is from census.gov and can be found [here](https://www.census.gov/data/tables/time-series/demo/popest/2010s-total-metro-and-micro-statistical-areas.html) for 2016-2019 data, and [here](https://www.census.gov/data/tables/time-series/demo/popest/2020s-total-metro-and-micro-statistical-areas.html) for 2020-2023 data.

#### Income Data

Income data used in this analysis is from the Federal Reserve Bank of St. Louis. the dataset includes per capita income in the top 100 U.S. metros updated annualy from 2016 to 2023. Click [here](https://fred.stlouisfed.org/release?rid=175&t=msa&ob=pv&od=desc) to view the data source.

## Key Insights

SQL was used the setup and analyze the data. Click [here](https://github.com/XanderK555/Housing-Affordability-in-US-Metro-Areas/blob/main/table_setup.sql) to view the SQL code for setting up the tables, and click [here](https://github.com/XanderK555/Housing-Affordability-in-US-Metro-Areas/blob/main/analysis.sql) to view the queries used to analyze the data.

### Housing Market Trends

![alt text](https://public.tableau.com/app/profile/xander.kasternakis/viz/HousingMarketTrends_17415530705220/HousingData#1)

- The average median listing price in the top 100 metros has increased by **48%** from July 2016 to January 2025.
- **Boise, ID** saw the highest housing price growth among the top 100 metros, leading in **median listing price (+120%)** and **median price per square foot (+131%)**, while ranking 2nd in **average listing price growth (+134%)** since 2016. **Knoxville, TN, Syracuse, NY, and Spokane, WA** also experienced significant price growth, each ranking in the **top 5 for at least two of the three key housing price metrics**.
- **Honolulu, HI** is the only metro among the top 100 to experience a **decline in median listing price (-1.6%)**, along with the **lowest average listing price growth (+0%)**, and **median price per square foot growth (+17%)**. **San Francisco, CA**, **Bridgeport, CT**, and the **Texas Triangle metros** also saw relatively modest housing price growth.
- 
