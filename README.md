# sql_games_project

Project by Alexsey Chernichenko

The dataset used in the project is taken from https://www.kaggle.com/datasets/gregorut/videogamesales/data

It contains a list of video games with sales greater than 100,000 copies during 1983-2016, 2017 and 2020 (However, years 2017 and 2020 are dropped since the data during these years seem to be incomplete). There are 16323 rows and 11 columns
- Rank - ranking of overall sales
- Name - the games name
- Platform - platform of the games release (i.e. PC,PS4, etc.)
- Year - year of the game's release
- Genre - genre of the game
- Publisher - publisher of the game
- NA_Sales - sales in North America (in millions)
- EU_Sales - sales in Europe (in millions)
- JP_Sales - sales in Japan (in millions)
- Other_Sales - sales in the rest of the world (in millions)
- Global_Sales - total worldwide sales (NA_Sales + EU_Sales + JP_Sales + Other_Sales)

The questions that are asked, studied and answered are the following:

1. Does the database contain any duplicates or null values?

2. Are there any games that have been released on multuple platforms? If yes, then create a new updated table where this is considered.

3. How is the new table compared to the old one? How many games are still in the top 10? What games are new?

4. What are the 10 most sold games from each genre worldwide? Regionally (NA, EU, JP, Other)?

5. What are the most profitable genres worldwide? Regionally?

6. What were the most profitable years of gaming? What is procentual growth/decrease of a year compared to the previous one?

7. What are the most profitable platforms worldwide? Regionally?

8. Who, amongst the publishers, earned the most?

9. How did global sales number change from the period 1983-1999 to 2000-2016?

10. How did Nintendo income vary throught the years 1983-2016? What was the year with lowest income? The highest? What is the average income during the period?
