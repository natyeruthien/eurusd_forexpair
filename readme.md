# EURUSD Forex Pair Historical Data (2002 - 2020)

## About the Dataset

This dataset was taken from [Kaggle](https://www.kaggle.com/datasets/imetomi/eur-usd-forex-pair-historical-data-2002-2019?utm_source=pocket_saves). The dataset contains historical data saved from Oanda Brokerage. The columns represent the Bid and Ask price for every minute/hour. Additionally, there are news articles downloaded from Investing.com. These can be used to forecast the trend of the Forex market with machine learning techniques.

## Repository Contents

This repository contains the following files:

1. **cleaning.sql** - This SQL script was used to clean the dataset by updating the date columns, checking for duplicates and nulls, and ensuring data consistency. The database for the SQL is PostgreSQL on localhost, and this SQL script helps in organizing and cleaning the data effectively before further analysis. The structure of the SQL file is designed to be executed in a SQL notebook.

2. **visualization.ipynb** - This Jupyter Notebook contains the code for visualizing the cleaned data. Various plots and charts are created to provide insights into the historical trends and patterns of the EURUSD Forex Pair. It includes steps for loading the data from the PostgreSQL database, preprocessing, and visualizing key metrics.

## Data Cleaning

The `cleaning.sql` script includes several steps to ensure the dataset is clean and ready for analysis:

- Updating the date columns in the `eurusd_minute` and `eurusd_news` tables to store only the date part.
- Checking for duplicates and null values in the tables.
- Verifying the datatype of the date columns.
- Ensuring data consistency by checking for gaps in the date ranges.

## Data Visualization

The `visualization.ipynb` notebook performs the following tasks:

- Loading the data from the PostgreSQL database into Pandas DataFrames.
- Converting date and time columns to a single datetime column and setting it as the index.
- Plotting various charts including boxplots, histograms, heatmaps, and candlestick charts to visualize the historical trends.
- Identifying significant changes in bid prices and visualizing them.
- Resampling the data to daily time series for further analysis.

## Future Work

- The repository is a work in progress. Future updates will include machine learning models to forecast the trend of the EURUSD Forex Pair.
- Additional analysis and visualization techniques will be added to enhance the insights derived from the dataset.
