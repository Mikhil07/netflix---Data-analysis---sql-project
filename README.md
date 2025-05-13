📊 Netflix Content Analysis using SQL

👋 Introduction

This project analyzes a real-world Netflix dataset using PostgreSQL to extract insights about content types, release patterns, ratings, actors, and more.

🎯 Objective

The goal of this project is to:

Understand trends in Netflix content (Movies vs TV Shows).

Analyze regional content production (especially from India).

Explore keyword patterns in descriptions for sentiment labeling.

Identify top-performing actors and the frequency of content releases.

🧩 Dataset
The dataset used is netflix_titles.csv, which contains metadata about Netflix shows and movies, including:

title, type, director, cast, country

date_added, release_year, rating, duration

listed_in, description

❓ Business Questions Solved
Count the number of Movies and TV Shows.

Identify the most common rating for each type.

--find the top 5 countries with most content on netflix

Analyze average duration of TV Shows with more than 5 seasons.

--find each year and the average number of content release by India on netflix. return top 5 year with highest avg content release

--find all content without a director

-- find how many movies actor 'salman Khan' appeared in last 10 years:

--Find the top 10 actors who have appeared in the highest number of movies produced in India.

--find each year and the average number of content release by India on netflix. return top 5 year with
highest avg content release

--categorize the content based on the presence of the keywords 'kill' and ' voilence' inthe description field.
label content containing these keywords as 'bad' and all other content as' Good'. count how
any items fall into each category.

-- identify the longest movie

Categorize content based on keywords in description (kill, violence, love) as "bad", "neutral", or "good".

🧠 Key SQL Concepts Used
CASE WHEN and conditional logic

ILIKE for case-insensitive matching

STRING functions: SPLIT_PART, TO_DATE, EXTRACT

AGGREGATE functions: COUNT, AVG, ROUND, MIN

WINDOW FUNCTIONS: RANK() OVER

GROUP BY, ORDER BY, WITH (CTEs)

🧾Some SQL Queries Used

🔹 Table Creation
sql
CREATE TABLE netflix (
  show_id VARCHAR(7), type VARCHAR(15),
  title VARCHAR(200), director VARCHAR(250),
  casts VARCHAR(1000), country VARCHAR(150),
  date_added VARCHAR(100), release_year INT,
  rating VARCHAR(10), duration VARCHAR(50),
  listed_in VARCHAR(100), description VARCHAR(500)
);


🔹 Content Count by Type

SELECT type, COUNT(*) AS total_content
FROM netflix
GROUP BY type;

🔹 Most Common Rating per Type
sql

SELECT type, rating
FROM (
  SELECT type, rating, COUNT(*), RANK() OVER (PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
  FROM netflix
  GROUP BY 1, 2
) AS t
WHERE ranking = 1;
🔹 Average Duration for TV Shows with >5 Seasons
sql

SELECT type, title, duration
FROM netflix
WHERE type = 'TV Show' AND SPLIT_PART(duration,' ', 1)::NUMERIC > 5
ORDER BY SPLIT_PART(duration,' ', 1)::NUMERIC DESC;

🔹 Average Content Released by India by Year
sql

SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year,
  COUNT(*) AS total_titles,
  ROUND(COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM netflix WHERE country ILIKE '%India%') * 100, 2) AS avg_content_percent
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY avg_content_percent DESC
LIMIT 5;

🔹 Categorize Content Based on Keywords
sql

WITH new_table AS (
  SELECT *,
    CASE 
      WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'bad_content'
      WHEN description ILIKE '%love%' THEN 'neutral_content'
      ELSE 'good_content'
    END AS category
  FROM netflix
)
SELECT category, COUNT(*)
FROM new_table
GROUP BY category
ORDER BY COUNT(*) DESC;

and more 
Tool used: PGadmin 4
