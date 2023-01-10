# Deforestation Analysis using SQL

### Project Overview  


<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/Table%201.png" alt="Forest area by country"> 

### SQL code 

-- SQL
WITH forest_area_1990
     AS (SELECT country_name,
                region,
                forest_area_sqkm AS forest_area_1990
         FROM   forestation
         WHERE  year = 1990),
     forest_area_2016
     AS (SELECT country_name,
                region,
                forest_area_sqkm AS forest_area_2016
         FROM   forestation
         WHERE  year = 2016),
     joined_1990_2016
     AS (SELECT a.country_name AS country_name,
                a.region AS region,
                a.forest_area_1990 AS forest_area_1990,
                b.forest_area_2016 AS forest_area_2016
         FROM   forest_area_1990 a
                JOIN forest_area_2016 b
                  ON a.region = b.region
                     AND a.country_name = b.country_name)
SELECT country_name,
       region,
       forest_area_1990 - forest_area_2016 AS forest_area_decrease
FROM   joined_1990_2016
WHERE  country_name != 'World'
       AND forest_area_1990 IS NOT NULL
       AND forest_area_2016 IS NOT NULL
ORDER  BY 3 DESC
LIMIT  5;
--
