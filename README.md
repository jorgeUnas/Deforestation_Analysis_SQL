# Deforestation Analysis using SQL

### Project Overview  
In this project it was used data from the World Bank related to the global deforestation from 1990 to 2016. This dataset includes the forest areas and the total land areas by country and region. The analysis, which was done using solely SQL, includes some recomendations about how to combat deforestation around the world. 

##Global situation##
According to the World Bank, the total forest area of the world was 41282694.9 km2 in 1990. As of 2016, the most recent year for which data was available, that number had fallen to 39958245.9 km2, a loss of 1324449 km2 or 3.21 %.

The forest area lost over this time period is slightly more than the entire land area of Peru listed for the year 2016 (which is 1279999.9891 km2).

##Reginal outlook##
In 2016, the percent of the total land area of the world designated as forest was 31.38%. The region with the highest relative forestation was Latin America & Caribbean, with 46.16%, and the region with the lowest relative forestation was Middle East & North Africa, with 2.07% forestation.

In 1990, the percent of the total land area of the world designated as forest was 32.42%. The region with the highest relative forestation was Latin America & Caribbean, with 51.03%, and the region with the lowest relative forestation was Middle East & North Africa, with 1.78% forestation.
![image](https://user-images.githubusercontent.com/106410793/227591733-db01ccb7-9d82-4916-ba2c-b8e820b77964.png)


<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/Table%201.png" alt="Forest area by country"> 

### SQL code 

``` sql
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
``` 
