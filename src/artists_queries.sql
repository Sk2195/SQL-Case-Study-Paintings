-- Database: artists

-- DROP DATABASE IF EXISTS artists;

CREATE DATABASE artists
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
	
/* Question 1: Fetch all the paintings which are not displayed on any museums?
*/
SELECT *
FROM work
WHERE museum_id IS NULL

/*Question 2 Are there museum without any paintings?
*/
SELECT m.*
FROM museum m
LEFT JOIN work w ON m.museum_id = w.museum_id
WHERE w.museum_id IS NULL;

/* Question 3:  How many paintings have an asking price of more than their regular price? */
SELECT  * FROM product_size
	WHERE sale_price > regular_price;
	
/* Question 4: Identify the paintings whose asking price is less than 50% of its regular price */
SELECT *
FROM product_size
WHERE sale_price < (regular_price * 0.5)

/* Question 5: Which canva size costs the most? */
SELECT 
    label
FROM 
    canvas_size cs 
INNER JOIN 
    product_size ps ON ps.size_id = cs.size_id
WHERE 
    ps.regular_price = (SELECT MAX(regular_price) FROM product_size
						
/*Question 6: Delete duplicate records from work, product_size, subject and image_link tables
*/
delete from work 
	where ctid not in (select min(ctid)
						from work
						group by work_id );

	delete from product_size 
	where ctid not in (select min(ctid)
						from product_size
						group by work_id, size_id );

	delete from subject 
	where ctid not in (select min(ctid)
						from subject
						group by work_id, subject );

	delete from image_link 
	where ctid not in (select min(ctid)
						from image_link
						group by work_id );


/*Question 7  Identify the museums with invalid city information in the given dataset
*/
SELECT *
FROM museum
WHERE city ~ '^[0-9]'
						
/* Question 8: Museum_Hours table has 1 invalid entry. Identify it and remove it.
*/
DELETE FROM museum_hours
WHERE ctid NOT IN (
    SELECT MIN(ctid) -- Select the smallest ctid for each group
    FROM museum_hours
    GROUP BY museum_id, day -- Group by unique combinations of museum_id and day
);

/* Question 9: Identify the museums which are open on both Sunday and Monday. */
WITH subject_count AS (SELECT subject, COUNT(*)	as CNT		   				
FROM subject
GROUP BY subject
ORDER BY 2 DESC)

SELECT 
     subject
FROM subject_count
LIMIT 10;				 	
/*Question 10) Identify the museums which are open on both Sunday and Monday. 
Display museum name, city. */
-- Using GROUP BY and HAVING
SELECT *
FROM museum_hours mh
INNER JOIN museum m ON m.museum_id = mh.museum_Id
WHERE mh.day IN ('Sunday', 'Monday')
GROUP BY m.museum, m.city
HAVING COUNT(DISTINCT mh.day) = 2
						
/* Question 11: ) How many museum are open every single day? */
SELECT 
	m.museum_id,
	COUNT(DISTINCT mh.day) AS days_open
FROM museum m 
LEFT JOIN museum_hours mh ON mh.museum_id = m.museum_id
GROUP BY m.museum_id
HAVING COUNT(DISTINCT mh.day) > 7

/*Question 12: Which are the top 5 most popular museum? (Popularity is defined based on most no of paintings in a museum)
*/
SELECT 
	  m.name as museum_name,
	  COUNT(*) as number_of_paintings		
FROM museum m
INNER JOIN work w ON w.museum_id = m.museum_id
GROUP BY m.name
ORDER BY 2 DESC
LIMIT 5;
				
/* Question 13: Who are the top 5 most popular artist? (Popularity is defined based on most no of paintings done by an artist) */
WITH artist_ranking(SELECT 
	  a.artist_id,
	  COUNT(1) as number_of_paintings,
	  RANK() OVER (ORDER BY COUNT(1) DESC) as rnk
FROM artist a 
INNER JOIN work w ON w.artist_id = a.artist_id
GROUP BY a.artist_id)

SELECT 
      a.artist_id
FROM artist_ranking
WHERE rnk <= 5
				
/* Question 14: ) Display the 3 least popular canva sizes */
WITH CanvasRankings AS (
    SELECT 
        cs.label,
        COUNT(*) AS no_of_paintings,
        DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS ranking
    FROM work w
    JOIN product_size ps ON ps.work_id = w.work_id
    JOIN canvas_size cs ON cs.size_id = ps.size_id::text
    GROUP BY cs.size_id, cs.label
)
SELECT 
    label,
    ranking,
    no_of_paintings
FROM CanvasRankings
WHERE ranking <= 3;


/* Question 15: Which museum is open for the longest during a day. Dispay museum name, state and hours open and which day?*/
WITH RankedMuseumHours AS (
    SELECT 
        m.name AS museum_name, 
        m.state, 
        mh.day, 
        mh.open, 
        mh.close,
        EXTRACT(epoch FROM (to_timestamp(mh.close, 'HH:MI PM') - to_timestamp(mh.open, 'HH:MI AM')))/3600 AS duration,
        RANK() OVER (ORDER BY (to_timestamp(mh.close, 'HH:MI PM') - to_timestamp(mh.open, 'HH:MI AM')) DESC) AS rnk
    FROM museum_hours mh
    JOIN museum m ON m.museum_id = mh.museum_id
)

SELECT 
    museum_name, 
    state, 
    duration,
	day
FROM RankedMuseumHours
WHERE rnk = 1;

/* Question 16 Which museum has the most no of most popular painting style?*/
WITH style_ranking AS (
    SELECT
        m.name AS museum,  
        COUNT(DISTINCT w.style) AS style_count,
        RANK() OVER (ORDER BY COUNT(DISTINCT w.style) DESC) AS rnk  -- Simplified and corrected ranking
    FROM museum m
    INNER JOIN work w ON w.museum_id = m.museum_id
    GROUP BY m.name  -- Changed to GROUP BY museum's name if that's the identifier
)
SELECT museum
FROM style_ranking
WHERE rnk = 1

/* Question 17 Identify the artists whose paintings are displayed in multiple countries*/
SELECT
	  a.full_name as artist
FROM artist a 
INNER JOIN work w ON w.artist_id = a.artist_id
INNER JOIN museum m ON m.museum_id = w.museum_id
GROUP BY a.full_name
HAVING COUNT(DISTINCT m.country) > 1
						
/* Question 18 Display the country and the city with most no of museums. Output 2 seperate columns to mention the city and country. If there are multiple value, seperate them with comma. */
WITH cte_country AS (
    SELECT 
        country,
        COUNT(1) as number_of_museums,
        RANK() OVER (ORDER BY COUNT(1) DESC) as rank
    FROM museum
    GROUP BY country
),
cte_city AS (
    SELECT 
        city,
        COUNT(1) as number_of_museums,
        RANK() OVER (ORDER BY COUNT(1) DESC) as rnk
    FROM museum
    GROUP BY city
)
SELECT  
    string_agg(DISTINCT country.country, ', ') AS top_countries, 
    string_agg(city.city, ', ') AS top_cities
FROM cte_country country
CROSS JOIN cte_city city
WHERE country.rank = 1 AND city.rnk = 1;

/* Question 19  Identify the artist and the museum where the most expensive and least expensive painting is placed. 
Display the artist name, sale_price, painting name, museum name, museum city and canvas label*/
WITH RankedPaintings AS (
    SELECT 
        w.work_id,
        w.name AS painting,
        a.full_name AS artist,
        m.name AS museum,
        m.city AS museum_city,
        cz.label AS canvas,
        ps.sale_price,
        RANK() OVER (ORDER BY ps.sale_price DESC) AS rnk_desc,
        RANK() OVER (ORDER BY ps.sale_price ASC) AS rnk_asc
    FROM work w
    JOIN artist a ON w.artist_id = a.artist_id
    JOIN museum m ON w.museum_id = m.museum_id
    JOIN product_size ps ON w.work_id = ps.work_id
    JOIN canvas_size cz ON ps.size_id = cz.size_id
)
SELECT 
    artist,
    sale_price,
    painting,
    museum,
    museum_city,
    canvas
FROM RankedPaintings
WHERE rnk_desc = 1 OR rnk_asc = 1;
					
/*Question 20 Which country has the 5th highest no of paintings?
*/
WITH country_ranking AS (SELECT 
	  m.country,
	  COUNT(1) as total_museum,
	  RANK() OVER(ORDER BY COUNT(1) DESC) rnk
FROM museum m 
INNER JOIN work w ON w.museum_id = m.museum_id
GROUP BY m.country)
SELECT 
	   country
FROM country_ranking
WHERE rnk = 5

						
	  


