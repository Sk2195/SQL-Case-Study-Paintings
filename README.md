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
| #  | Task Description | Details |
|----|------------------|---------|
| 1  | Fetch all paintings not displayed in any museums | Query to select all records from the `paintings` table where the `museum_id` is NULL. |
| 2  | Check for museums without any paintings | Query to find all museums that do not have any associated paintings in the `paintings` table. |
| 3  | Count paintings with asking price above regular price | Construct a query to count all paintings where the `asking_price` exceeds the `regular_price`. |
| 4  | Identify underpriced paintings | Find paintings where the `asking_price` is less than 50% of the `regular_price`. |
| 5  | Determine which canvas size costs the most | Create a query to determine the maximum `sale_price` by `canvas_size`. |
| 6  | Delete duplicate records from multiple tables | Write queries to remove duplicates from the `work`, `product_size`, `subject`, and `image_link` tables. Ensure uniqueness is determined by content. |
| 7  | Identify museums with invalid city information | Query the `museums` table to find entries with missing or empty city information. |
| 8  | Clean up invalid entry in Museum_Hours table | Identify and remove the invalid entry in the `museum_hours` table based on criteria for valid opening and closing times. |
| 9  | Fetch the top 10 most famous painting subjects | Write a query to list the top 10 subjects in paintings based on occurrence. |
| 10 | Museums open on both Sunday and Monday | Query the `museum_hours` table to find museums that are open on both Sunday and Monday. Display museum name and city. |
| 11 | Identify museums open every day | Determine which museums are open every day of the week by checking all day columns for non-null values. |
| 12 | Top 5 most popular museums by number of paintings | Write a query to find the five museums with the most paintings. |
| 13 | Top 5 most popular artists by paintings done | List the top five artists by the number of paintings they have done. |
| 14 | Find the 3 least popular canvas sizes | Query the least frequently used three canvas sizes in the database. |
| 15 | Which museum is open the longest during a day | Determine which museum has the longest open hours in a single day and provide the museum name, state, hours open, and the day. |
| 16 | Which museum has the most of the most popular painting style | Query which museum holds the most paintings of the most popular style. |
| 17 | Identify artists whose paintings are displayed in multiple countries | Query to find artists whose works are displayed in more than one country. |
| 18 | Display the country and the city with the most museums | Query to find the country and city with the most museums. Output should have two columns: one for the city and one for the country. Use commas to separate multiple values. |
| 19 | Identify the artist and the museum with the most and least expensive paintings | Query to find both the most expensive and least expensive painting, including the artist name, sale_price, painting name, museum name, museum city, and canvas label. |
| 20 | Which country has the 5th highest number of paintings? | Query to rank countries by the number of paintings and select the country with the 5th highest total. |
| 21 | Identify the 3 most popular and 3 least popular painting styles | Query to list the three most and least popular painting styles based on the number of paintings. |
| 22 | Most Portrait paintings by an artist outside the USA | Query to find the artist with the most Portrait paintings located outside the USA, including artist name, number of paintings, and nationality. |

