# SQL-Case-Study-Paintings
This is SQL Case Study project uses SQL to analyze paintings that are hanged in the museums.
# Painting Data Analysis Project

This project is designed to import and analyze painting-related data stored in various CSV files using PostgreSQL and Python. The analysis is centered around a case study of paintings, incorporating details such as canvas size, image links, museum hours, and more.

## Prerequisites

Before you begin, ensure you have installed the following:
- Python 3.8 or higher
- PostgreSQL
- pip

# Project Structure 
data / contains all the csv files(artist.csv, canvas.size.csv etc.)
src/: Source Code for importting and analyzing data
README.md this file contains the overview of the project and has the instructions to carry out the analysis

# Run the script
- To run this local environment , ensure your postgres_server is running and modify the database
- run this script src/python src/convert_to_sql.py
# Data Analysis 
- These are the 20 queries that were analyzed

  | Problem Number | Description | SQL Query |
|----------------|-------------|-----------|
| 1 | Fetch all the paintings which are not displayed in any museums | `SELECT * FROM paintings WHERE museum_id IS NULL;` |
| 2 | Are there museums without any paintings? | `SELECT * FROM museums WHERE id NOT IN (SELECT DISTINCT museum_id FROM paintings);` |
| 3 | How many paintings have an asking price more than their regular price? | `SELECT COUNT(*) FROM paintings WHERE asking_price > regular_price;` |
| 4 | Identify the paintings whose asking price is less than 50% of its regular price | `SELECT * FROM paintings WHERE asking_price < 0.5 * regular_price;` |
| 5 | Which canvas size costs the most? | `SELECT canvas_size, MAX(sale_price) FROM paintings GROUP BY canvas_size ORDER BY MAX(sale_price) DESC LIMIT 1;` |
| 6 | Delete duplicate records from work, product_size, subject and image_link tables | `DELETE FROM work WHERE ctid NOT IN (SELECT MIN(ctid) FROM work GROUP BY work_details); DELETE FROM product_size WHERE ctid NOT IN (SELECT MIN(ctid) FROM product_size GROUP BY size_details); DELETE FROM subject WHERE ctid NOT IN (SELECT MIN(ctid) FROM subject GROUP BY subject_details); DELETE FROM image_link WHERE ctid NOT IN (SELECT MIN(ctid) FROM image_link GROUP BY link_details);` |
| 7 | Identify the museums with invalid city information | `SELECT * FROM museums WHERE city IS NULL OR city = '';` |
| 8 | Identify and remove the invalid entry from the Museum_Hours table | `DELETE FROM museum_hours WHERE opening_time = 'invalid' OR closing_time = 'invalid';` |
| 9 | Fetch the top 10 most famous painting subjects | `SELECT subject, COUNT(*) FROM paintings GROUP BY subject ORDER BY COUNT(*) DESC LIMIT 10;` |
| 10 | Identify the museums which are open on both Sunday and Monday | `SELECT museum_name, city FROM museum_hours WHERE sunday_open IS NOT NULL AND monday_open IS NOT NULL;` |
| 11 | How many museums are open every single day? | `SELECT COUNT(*) FROM museum_hours WHERE sunday_open IS NOT NULL AND monday_open IS NOT NULL AND tuesday_open IS NOT NULL AND wednesday_open IS NOT NULL AND thursday_open IS NOT NULL AND friday_open IS NOT NULL AND saturday_open IS NOT NULL;` |
| 12 | Which are the top 5 most popular museums? | `SELECT museum_name, COUNT(painting_id) AS num_paintings FROM paintings JOIN museums ON paintings.museum_id = museums.id GROUP BY museum_name ORDER BY num_paintings DESC LIMIT 5;` |
| 13 | Who are the top 5 most popular artists? | `SELECT artist_name, COUNT(*) AS num_paintings FROM paintings GROUP BY artist_name ORDER BY num_paintings DESC LIMIT 5;` |
| 14 | Display the 3 least popular canvas sizes | `SELECT canvas_size, COUNT(*) AS num_paintings FROM paintings GROUP BY canvas_size ORDER BY num_paintings ASC LIMIT 3;` |
| 15 | Which museum is open for the longest during a day? | `SELECT museum_name, state, MAX(closing_time - opening_time) AS hours_open, day FROM museum_hours GROUP BY museum_name, state, day ORDER BY hours_open DESC LIMIT 1;` |
| 16 | Which museum has the most no of the most popular painting style? | `WITH MostPopularStyle AS (SELECT style, MAX(count) FROM (SELECT style, COUNT(*) FROM paintings GROUP BY style) AS StyleCount) SELECT museum_name FROM paintings JOIN museums ON paintings.museum_id = museums.id WHERE paintings.style = (SELECT style FROM MostPopularStyle) GROUP BY museum_name ORDER BY COUNT(*) DESC LIMIT 1;` |
| 17 | Identify the artists whose paintings are displayed in multiple countries | `SELECT artist_name FROM paintings JOIN museums ON paintings.museum_id = museums.id GROUP BY artist_name HAVING COUNT(DISTINCT country) > 1;` |
| 18 | Display the country and the city with the most number of museums | `SELECT country, STRING_AGG(city, ', ') AS cities FROM (SELECT country, city, COUNT(*) FROM museums GROUP BY country, city ORDER BY COUNT(*) DESC) AS CountryCityGroup GROUP BY country ORDER BY SUM(count) DESC;` |
| 19 | Identify the artist and the museum where the most expensive and least expensive painting is placed | `SELECT artist_name, sale_price, painting_name, museum_name, museum_city, canvas_label FROM paintings JOIN museums ON


