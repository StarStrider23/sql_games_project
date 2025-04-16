-- Project by Alexsey Chernichenko

USE games;

SELECT *
FROM sales;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM sales WHERE Year = 2017;
DELETE FROM sales WHERE Year = 2020;

-- First, let's see if there are any duplicates or null values

SELECT Ranking, Name, Platform, Year, Genre, Publisher,
       NA_Sales, EU_Sales, JP_Sales, Other_Sales,
       Global_Sales, COUNT(*)
FROM sales
GROUP BY Ranking, Name, Platform, Year, Genre, Publisher,
       NA_Sales, EU_Sales, JP_Sales, Other_Sales,
       Global_Sales
HAVING COUNT(*) > 1;

-- No duplicates. Any null values?

SELECT Ranking, Name, Platform, Year, Genre, Publisher,
       NA_Sales, EU_Sales, JP_Sales, Other_Sales,
       Global_Sales
FROM sales
WHERE Ranking IS NULL OR NAME IS NULL OR Platform IS NULL OR
      Year IS NULL OR Genre IS NULL OR Publisher IS NULL OR
      NA_Sales IS NULL OR EU_Sales IS NULL OR JP_Sales IS NULL OR
      Other_Sales IS NULL OR Global_Sales IS NULL; 

-- No null values. 

-- Many games were released on multiple platforms. First, let's see convince ourselves 
-- that this is indeed true and then let's sum all the sales from different platforms
-- and put it into a new table as it'll be useful later on. 

SELECT Name, COUNT(Name)
FROM sales
GROUP BY Name
HAVING COUNT(Name) > 1;

-- Creating table

CREATE TABLE sales_new AS
WITH cte_total AS
	(
     SELECT
	 Name, COUNT(Name) AS num_platforms, 
     Genre AS Genre,
     Publisher AS publisher,
     ROUND(SUM(Global_Sales),4) AS total_sales,
     ROUND(SUM(NA_Sales),4) AS total_sales_NA, 
     ROUND(SUM(EU_Sales),4) AS total_sales_EU, 
     ROUND(SUM(JP_Sales),4) AS total_sales_JP, 
     ROUND(SUM(Other_Sales),4) AS total_sales_other
     FROM sales
     GROUP BY Name, Genre, Publisher
)
SELECT ROW_NUMBER() OVER() AS Ranking, Name, num_platforms, 
genre, publisher, total_sales, total_sales_NA, 
total_sales_EU, total_sales_JP, total_sales_other
FROM cte_total
ORDER BY total_sales DESC;

SELECT *
FROM sales_new;

-- Top 10 games sold, old list vs new list

SELECT sales.Ranking, sales.Name, sales_new.Ranking, sales_new.Name
FROM sales
JOIN sales_new
ON sales.Ranking = sales_new.Ranking
LIMIT 10;

-- Games that are present in both lists

SELECT sales.Name
FROM sales
WHERE sales.Ranking <= 10
INTERSECT 
SELECT sales_new.Name
FROM sales_new
WHERE sales_new.Ranking <= 10
LIMIT 10;

-- Only 6/10.

-- Top 10 games per each genre

WITH cte_top10 AS (
    SELECT Name, genre, total_sales, ROW_NUMBER() 
    OVER(PARTITION BY genre ORDER BY total_sales DESC
    ) AS row_num 
FROM sales_new
)
SELECT row_num, Name, genre, total_sales
FROM cte_top10 
WHERE row_num <= 10;

-- Top 5 games sold per genre per region (NA, EU, JP and Other)

SELECT temp_table1.row_num, temp_table1.Name, temp_table1.genre, temp_table1.total_sales_NA, 
       temp_table2.row_num, temp_table2.Name, temp_table2.genre, temp_table2.total_sales_EU,
       temp_table3.row_num, temp_table3.Name, temp_table3.genre, temp_table3.total_sales_JP,
       temp_table4.row_num, temp_table4.Name, temp_table4.genre, temp_table4.total_sales_other
FROM (SELECT Name, genre, total_sales_NA, 
      ROW_NUMBER() OVER(PARTITION BY genre ORDER BY total_sales_NA DESC) AS row_num 
      FROM sales_new) AS temp_table1
JOIN 
(SELECT Name, genre, total_sales_EU, 
        ROW_NUMBER() OVER(PARTITION BY genre ORDER BY total_sales_EU DESC) AS row_num 
        FROM sales_new) AS temp_table2
ON temp_table1.row_num = temp_table2.row_num AND temp_table1.genre = temp_table2.genre
JOIN 
(SELECT Name, genre, total_sales_JP, 
        ROW_NUMBER() OVER(PARTITION BY genre ORDER BY total_sales_JP DESC) AS row_num 
        FROM sales_new) AS temp_table3
ON temp_table2.row_num = temp_table3.row_num AND temp_table2.genre = temp_table3.genre
JOIN 
(SELECT Name, genre, total_sales_other, 
        ROW_NUMBER() OVER(PARTITION BY genre ORDER BY total_sales_other DESC) AS row_num 
        FROM sales_new) AS temp_table4
ON temp_table3.row_num = temp_table4.row_num AND temp_table3.genre = temp_table4.genre
WHERE temp_table1.row_num <= 5; 


-- Most profitable genres

SELECT Genre, ROUND(SUM(Global_Sales),2) AS total_earned,
ROUND(SUM(Global_Sales)/(SELECT SUM(Global_Sales) FROM sales) * 100,2) 
AS procent_total_sales
FROM sales
GROUP BY Genre
ORDER BY total_earned DESC;

-- Top 10 genres per region (NA, EU, JP and Other)

SELECT temp_table1.row_num, temp_table1.genre, temp_table1.total_earned_NA,
       temp_table2.row_num, temp_table2.genre, temp_table2.total_earned_EU,
       temp_table3.row_num, temp_table3.genre, temp_table3.total_earned_JP,
       temp_table4.row_num, temp_table4.genre, temp_table4.total_earned_other
FROM (SELECT genre, ROUND(SUM(total_sales_NA),2) AS total_earned_NA, 
       ROW_NUMBER() OVER(ORDER BY SUM(total_sales_NA) DESC) AS row_num
FROM sales_new
GROUP BY genre
ORDER BY total_earned_NA DESC) AS temp_table1
JOIN
(SELECT genre, ROUND(SUM(total_sales_EU),2) AS total_earned_EU, 
       ROW_NUMBER() OVER(ORDER BY SUM(total_sales_EU) DESC) AS row_num
FROM sales_new
GROUP BY genre
ORDER BY total_earned_EU DESC) AS temp_table2
ON temp_table1.row_num = temp_table2.row_num
JOIN
(SELECT genre, ROUND(SUM(total_sales_JP),2) AS total_earned_JP, 
       ROW_NUMBER() OVER(ORDER BY SUM(total_sales_JP) DESC) AS row_num
FROM sales_new
GROUP BY genre
ORDER BY total_earned_JP DESC) AS temp_table3
ON temp_table2.row_num = temp_table3.row_num
JOIN
(SELECT genre, ROUND(SUM(total_sales_other),2) AS total_earned_other, 
       ROW_NUMBER() OVER(ORDER BY SUM(total_sales_other) DESC) AS row_num
FROM sales_new
GROUP BY genre
ORDER BY total_earned_other DESC) AS temp_table4
ON temp_table3.row_num = temp_table4.row_num
WHERE temp_table1.row_num <= 10;

-- Most profitable years

SELECT Year, ROUND(SUM(Global_Sales),2) AS total_earned
FROM sales
GROUP BY Year
ORDER BY total_earned DESC;

-- Procentual growth/decrease compared to previous year

WITH cte_procent AS (
	SELECT DISTINCT Year, SUM(Global_Sales) OVER(PARTITION BY Year) AS sum_year
    FROM sales
)
SELECT Year, ROUND(sum_year ,2) AS sum_year, 
       ROUND((sum_year - LAG(sum_year) OVER())/LAG(sum_year) OVER() *100,2) 
       AS procent_difference
FROM cte_procent
ORDER BY Year ASC;

-- The most profitable platforms

SELECT Platform, ROUND(SUM(Global_Sales),2) AS total_earned, 
ROUND(SUM(Global_Sales)/(SELECT SUM(Global_Sales) FROM sales) * 100, 2)
AS procent_total_sales
FROM sales
GROUP BY Platform
ORDER BY total_earned DESC;

-- Top platforms per region (NA, EU, JP and Other)

SELECT tt1.row_num, tt1.platform, tt1.total_earned_NA,
       tt2.row_num, tt2.platform, tt2.total_earned_EU,
       tt3.row_num, tt3.platform, tt3.total_earned_JP,
       tt4.row_num, tt4.platform, tt4.total_earned_other
FROM (SELECT platform, ROUND(SUM(NA_Sales),2) AS total_earned_NA, 
       ROW_NUMBER() OVER(ORDER BY SUM(NA_Sales) DESC) AS row_num
FROM sales
GROUP BY platform
ORDER BY total_earned_NA DESC) AS tt1
JOIN
(SELECT platform, ROUND(SUM(EU_Sales),2) AS total_earned_EU, 
       ROW_NUMBER() OVER(ORDER BY SUM(EU_Sales) DESC) AS row_num
FROM sales
GROUP BY platform
ORDER BY total_earned_EU DESC) AS tt2
ON tt1.row_num = tt2.row_num
JOIN
(SELECT platform, ROUND(SUM(JP_Sales),2) AS total_earned_JP, 
       ROW_NUMBER() OVER(ORDER BY SUM(JP_Sales) DESC) AS row_num
FROM sales
GROUP BY platform
ORDER BY total_earned_JP DESC) AS tt3
ON tt2.row_num = tt3.row_num
JOIN
(SELECT platform, ROUND(SUM(Other_Sales),2) AS total_earned_other, 
       ROW_NUMBER() OVER(ORDER BY SUM(Other_Sales) DESC) AS row_num
FROM sales
GROUP BY platform
ORDER BY total_earned_other DESC) AS tt4
ON tt3.row_num = tt4.row_num
WHERE tt1.row_num <= 5;

-- Publisher who earned the most money?

SELECT sales.Publisher, SUM(Global_Sales) AS total_earned
FROM sales
GROUP BY sales.Publisher
ORDER BY total_earned DESC;

-- Difference in earned money between two 17-year periods: 1983-1999 and 2000-2016

SELECT
DISTINCT (SELECT SUM(Global_Sales) 
          FROM sales 
          WHERE Year < 1999)
          AS sales_1983_1999, 
		 (SELECT SUM(Global_Sales) 
          FROM sales 
          WHERE Year > 1999) 
          AS sales_2000_2016
FROM sales;

-- Investigating Nintendo

SELECT Publisher, Year, 
ROUND(SUM(Global_Sales),2) AS earned_year, 
(SELECT ROUND(AVG(temp_table.avg_earned),2)
	FROM (SELECT SUM(Global_Sales) AS avg_earned
		  FROM sales
		  WHERE Publisher = 'Nintendo'
		  GROUP BY Year) AS temp_table) AS avg_earned
FROM sales
WHERE Publisher = 'Nintendo'
GROUP BY Publisher, Year
ORDER BY earned_year DESC;

-- Average, minimum and maximum 

WITH cte_temp AS (
    SELECT ROUND(AVG(temp_table.avg_earned),2) AS avg_earned,
    ROUND(MAX(temp_table.avg_earned),2) AS max_year,
	ROUND(MIN(temp_table.avg_earned),2) AS avg_year
	FROM (SELECT SUM(Global_Sales) AS avg_earned
		  FROM sales
		  WHERE Publisher = 'Nintendo'
		  GROUP BY Year) AS temp_table
)
SELECT *
FROM cte_temp;
