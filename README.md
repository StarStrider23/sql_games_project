# Analysis of the game sales

Project by Alexsey Chernichenko

## Project Background and Overview

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

## Project Goals

The goal is to study the dataset, analyse it and answer the questions below:

1. Does the database contain any duplicate rows or null values?

2. Are there any games that have been released on multuple platforms? If yes, then create a new updated table where this is considered.

3. How is the new table compared to the old one? How many games are still in the top 10? What games are new?

4. What are the 5 most sold games from each genre worldwide? Regionally (NA, EU, JP, Other)?

5. What are the most profitable genres worldwide? Regionally?

6. What were the most profitable years of gaming? What is procentual growth/decrease of a year compared to the previous one?

7. What are the most profitable platforms worldwide? Regionally?

8. Who, amongst the publishers, earned the most?

9. How did the global sales number change from the period 1983-1999 to 2000-2016?

10. How did Nintendo income vary throughout the years 1983-2016? What was the year with lowest income? The highest? What is the average income during the period?

## Results

### 1. 

The dataset contains no duplicates or null values. The duplicates could affect results in an undesired way and null values are just unwanted.

### 2+3. 

However, some games were released to different platforms and this is listed as different rows in the dataset, so technically there are duplicates, but they are not entirely identical. In order to consider the different copies of the same game as one, I created a new table and summed all the sales. To see how this affected the dataset, let's compare the old top 10 games by sales and the new one. 

<img width="429" alt="Снимок экрана 2025-04-23 в 19 40 46" src="https://github.com/user-attachments/assets/9b5c797f-1085-4a7a-b879-041455d7c9d5" />

The old list is on the left and the new one is on the right. Clearly, the top 10s look different, even though the majority of the games (7/10 to be more specific) are still on the new list. But notice that Grand Theft Auto V, which was only on the 13th spot before (the PS3 version), has now overtaken the 2nd place! This is due to the fact that it was released on 5 platforms and sold out pretty good on all of them. 

### 4. 

Here, I've chosen to use Tableau as the list is long and it is much easier to comprehend it visually. The data for the world is the following.

<img width="1269" alt="Снимок экрана 2025-04-23 в 20 09 21" src="https://github.com/user-attachments/assets/ddd1f544-c140-44b5-96a0-f75f2e5eb365" />

The data for different regions (NA, EU, JP and Other) looks similar and the reader is advised to run the code on one's own as those lists are quite lengthy.

### 5. 

Similarly, below are the most profitable genres in the world. 

<img width="1079" alt="Снимок экрана 2025-04-23 в 20 59 02" src="https://github.com/user-attachments/assets/3a297749-0718-4b1d-881c-396a395bbd57" />

Once again, for the regional results, please run the code yourself. 

### 6. 

Here are the most profitable years of gaming and procent difference. One can clearly see that the most profitable year of gaming was the year 2008 and other years are pretty much centered around it. 

<img width="944" alt="Снимок экрана 2025-04-23 в 21 15 45" src="https://github.com/user-attachments/assets/a730ff0a-2665-4a67-b6c5-1aaac7b71e29" />

Interestingly enough, there are only 3 games from year 2008 in the top 50: Mario Kart Wii (35.82 million copies sold), Grand Theft Auto IV (22.47 million) and Call of Duty: World at War (15.87 million). These account for 5.3%, 3.3% and 2.3% respectively from the total sales that year. So these games together contribute to a total of 10.9% from the total sales from the year 2008.

Also, it is quite amusing that the fraph above looks like a Gaussian distribution with the mean being the year 2008.

### 7. 

The most profitable platforms are:

<img width="692" alt="Снимок экрана 2025-04-23 в 21 35 37" src="https://github.com/user-attachments/assets/5588262d-b972-41b2-ab02-d236c9f98726" />

One can also look up the top games for the top 6 platforms as they stick out the most. 

<img width="786" alt="Снимок экрана 2025-04-24 в 10 11 58" src="https://github.com/user-attachments/assets/02c8ce9f-7e49-4d22-ac91-57efe110af34" />

Notice that the 3 Wii games contribute to 16.3% combined of the total games sold on Wii. 

### 8. 

