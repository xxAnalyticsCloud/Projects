--Combine all tables

CREATE TABLE appleStore_description_combined AS

SELECT * FROM appleStore_description1

UNION ALL

SELECT * FROM appleStore_description2

UNION ALL

SELECT * FROM appleStore_description3

UNION ALL

SELECT * FROM appleStore_description4

**EDA**

--Check number of unique apps in both tables

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description_combined

--Check for missing values in key fields

SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description_combined
WHERE app_desc IS NULL

---Find out number of apps per genere 

SELECT prime_genre, count(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER BY NumApps DESC

--Get an overview of apps' ratings

SELECT MIN(user_rating) AS MinRating,
	   MAX(user_rating) AS MaxRating,
       AVG(user_rating) AS AvgRating
FROM AppleStore

**Data Analysis**

--Determine whether paid apps have a higer rating than free apps

SELECT CASE
			WHEN price >0 THEN 'Paid'
            ELSE 'Free'
       END AS App_Type,
       avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY App_Type

-- check if apps with more supported languages have higer ratings 

SELECT CASE
			WHEN lang_num <10 THEN '<10 languages'
            WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
            ELSE '>10 languages'
        END AS language_bucket,
        avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY language_bucket
ORDER BY Avg_Rating DESC

--Check genres with low ratings 

SELECT prime_genre,
	   avg(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY Avg_Rating DESC
LIMIT 10

--Check if there is correlation between the length of the app description and the user ratingAppleStore

SELECT CASE 
			WHEN LENGTH(b.app_desc) <500 THEN 'Short'
            WHEN LENGTH(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
            ELSE 'Long'
         END AS description_length_bucket,
         AVG(a.user_rating) AS average_rating
         
FROM 
	AppleStore AS a
JOIN
	appleStore_description_combined AS b
ON
	a.id = b.id
            
GROUP BY description_length_bucket
ORDER BY average_rating DESC
            
--Check the top rated apps for each genre             

SELECT
	prime_genre,
    track_name,
    user_rating
FROM (
		SELECT
  		prime_genre,
  		track_name,
  		user_rating,
  		RANK() OVER(PARTITION BY prime_genre order BY user_rating DESC, rating_count_tot DESC) AS rank
  		FROM
  		AppleStore
 	) AS a
WHERE
a.rank = 1