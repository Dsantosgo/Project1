Create table appleStore_description_combined AS

SELECT * From appleStore_description1

union ALL

Select * from appleStore_description2

union all 

SELECT * FroM appleStore_description3

union all 

Select * from appleStore_description4

**Exploratory Data Anaysis**

-- check the number of unique apps in both tables

Select count(Distinct ID) as UniqueAppIDs
from AppleStore

Select count(Distinct ID) as UniqueAppIDs
from appleStore_description_combined

--check for any missing values in key fields

select count(*) as missingValues
from AppleStore
Where track_name is null or user_rating is null or prime_genre is null 

select count(*) as missingValues
from appleStore_description_combined
Where app_desc is null

--find out the number of apps per genre 

select prime_genre, count (*) As NumOfApps
from AppleStore
group by prime_genre
order by NumOfApps DESC

-- Get an overview of the apps' ratings

SELECT min(user_rating) as MinRating,
		max(user_rating) aS MaxRating,
		avg(user_rating) aS AvgRating
from AppleStore

-- Get the distribution of app prices 

select 
	(price / 2) *2 as PriceBinStart,
    ((price / 2) *2) +2 as PriceBinEnd,
    Count(*) as NumOfApps
from AppleStore

Group by PriceBinStart
order by PriceBinStart

** Data Analysis**

-- Determine whether paid apps have higher ratings than free apps

Select case 
		WHEN price > 0 then 'Paid'
        else 'Free'
      end as App_Type,
      avg(user_rating) as Avg_Rating
from AppleStore
Group by App_Type

--Check if apps with more supported languages have higher ratings

SELECT CAse 
		when lang_num < 10 then '<10 languages'
        when lang_num BETWEEN 10 and 30 then '10-30 languages'
        else '>10 languages'
    end as language_bucket,
    avg(user_rating) as Avg_Rating
from AppleStore
group by language_bucket
order by Avg_Rating DESC

--check genre with low ratings 

select prime_genre,
		avg(user_rating) as Avg_Ratings
from AppleStore
GROUP by prime_genre
Order by Avg_Ratings ASC
Limit 10

--check for correlation between the length of app description and user ratings

select case
		when length(b.app_desc) < 500 then 'Short'
        when length(b.app_desc) BETWEEN 500 and 1000 then 'Medium'
        else 'long'
      end as description_length_bucket,
      avg(a.user_rating) as average_rating
   
from 
	AppleStore as A 
join 
	appleStore_description_combined as b 
on 
	a.id = b.id
    
group by description_length_bucket
order by average_rating desc 

--check the top-rated apps for each genre

Select 
	prime_genre,
    track_name,
    user_rating
from (
  SELECT
  prime_genre,
  track_name,
  user_rating,
  RANK() OVER(PARTITION BY prime_genre ORDER by user_rating DESC, rating_count_tot DESC) as rank
  from 
  AppleStore
  ) as a 
 where a.rank =1 


    
        
