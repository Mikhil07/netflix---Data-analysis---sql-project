-- netflix project
create table netflix (
show_id	varchar(7), type varchar (15), 
title varchar(200), director varchar(250),
casts varchar (1000), country varchar (150),
date_added	varchar (100), release_year int,	
rating varchar (10), duration varchar(50),	
listed_in varchar(100), description varchar (500)
);

select * from netflix;

select count(*) as total_content from netflix;

select distinct type from netflix;

select null from netflix;

-- 15 business problems
-- count the number of movies and tvshows.

select type, count(*) as total_content from netflix group by type;

--find the most common rating for movies and tvshows

select type, rating from (
select type, rating, count (*), rank() over(partition by 
type order by count (*) desc ) 
as ranking from netflix
group by 1, 2 ) as t1 
where 
  ranking = 1
--order by 1, 3 desc;

--list all movies released in a specific year (eg; 2020)

select  * from netflix
where type = 'Movie' and release_year = 2020;

--find the top 5 countries with most content on netflix

select unnest(string_to_array(country, ',')) as new_country,
count(show_id) as total_content from netflix
group by 1
order by total_content desc limit 5;
--select unnest(string_to_array(country, ',')) as new_country from netflix

-- identify the longest movie

select type, title, duration from netflix
where type = 'Movie' and 
duration = (select max(duration) from netflix);

--find content added in the last 5 years
select type, title, to_date(date_added, 'Month DD,YYYY') FROM NETFLIX
where  
     to_date(date_added, 'Month DD,YYYY') >= current_date - interval '5 years';
--select current_date - interval '5 years'

-- find all the movies/TV shows by director 'Rajiv Chilaka'

select type, title, director  from netflix
where director Ilike '%Rajiv Chilaka%'
group by type, 2, 3 
--Ilike is case sensitive

--list all tv shows with more than 5 seasons

select type, title, duration from netflix
where type = 'TV Show' and split_part(duration,' ', 1) :: int> 5
ORDER BY split_part(duration, ' ', 1)::int DESC;

--split_part(duration, ' ', 1)

--count the content items in each genre.

select type, unnest(string_to_array(listed_in, ',')) as genre,
count(show_id) as total_content from netflix
group by 1,2
order by 3 desc


--find each year and the average number of content release by India on netflix. return top 5 year with
-- highest avg content release

select 
     Extract(year from To_Date(date_added, 'Month DD, YYYY'))As year, count (*),
	 round(count(*)::numeric /(select count(*) from netflix where country ilike '%India%')::numeric * 100, 2) 
	 as avg_content_per_year
	 from netflix
where country ilike '%India%' group by 1
order by avg_content_per_year desc

-- list all movies that are documentaries

select type, title from netflix
where type = 'Movie' and Listed_in ilike '%Documentaries%'

--find all content without a director
select * from netflix
where director is null

-- find how many movies actor 'salman Khan' appeared in last 10 years:

select title, to_date(date_added, 'Month DD,YYYY') FROM NETFLIX
where  
     to_date(date_added, 'Month DD,YYYY') >= current_date - interval '10 years' and 
	 casts ilike '%Salman Khan%'

--Find the top 10 actors who have appeared in the highest number of movies produced in India.
select unnest(string_to_array (casts, ',')) as Actor, count(title) from netflix
where country ilike'%India%'
group by Actor order by count(title) desc limit 10;

--categorize the content based on the presence of the keywords 'kill' and ' voilence' inthe description field.
--label content containing these keywords as 'bad' and all other content as' Good'. count how
--any items fall into each category.

With new_table as
( select *, 
case when description ilike '%kill%' or description ilike '%violence%'
then 'bad_content'
else 'good_content' END as category from netflix)
select category, count (*)
from new_table group by 1;
	 





