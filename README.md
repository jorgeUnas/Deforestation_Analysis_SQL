# Deforestation Analysis using SQL

## Project Overview  
In this project it was used data from the World Bank related to the global deforestation from 1990 to 2016. This dataset includes the forest areas and the total land areas by country and region. The analysis, which was done using solely SQL, includes some recomendations about how to combat deforestation around the world. 

## 1. Global situation
According to the World Bank, the total forest area of the world was 41282694.9 km2 in 1990. As of 2016, the most recent year for which data was available, that number had fallen to 39958245.9 km<sup> 2 </sup> , a loss of 1324449 km<sup> 2 </sup> or 3.21 %. The forest area lost over this time period is slightly more than the entire land area of Peru listed for the year 2016 (which is 1279999.9891 km <sup> 2 </sup>).

The percent change in forest area of the world between 1990 and 2016 was calculated as follows:
``` sql
WITH forest_area_1990
     AS (SELECT forest_area_sqkm AS fa_1990
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 1990),
     forest_area_2016
     AS (SELECT forest_area_sqkm AS fa_2016
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 2016),
     perc_loss_forestarea
     AS (SELECT ( fa_1990 - fa_2016 ) * 100 / fa_1990 AS perc_loss_forestarea
         FROM   forest_area_1990,
                forest_area_2016)
SELECT Round(perc_loss_forestarea :: NUMERIC, 2)
FROM   perc_loss_forestarea;
``` 
Where forest_area_sqkm means amount of forest area in km <sup> 2 </sup> . 

## 2. Reginal outlook
The percent of the total land area of the world designated as forest decreased from 32.42% in 1990 to 31.38% in 2016. In both years, the region with the highest relative forestation was Latin America & Caribbean and the region with the lowest relative forestation was Middle East & North Africa (see table 2.1). 

<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/Regional%20outlook.png" alt="Forest area by country"> 

The only regions of the world that decreased in percent forest area from 1990 to 2016 were Latin America & Caribbean (dropped from 51.03% to 46.16%) and Sub-Saharan Africa (30.67% to 28.79%). All other regions actually increased in forest area over this time period.

## 2. Country-level Detail

a. SUCCESS STORIES
There is one particularly bright spot in the data at the country level, China. This country actually increased in forest area from 1990 to 2016 by 527229.062 km2. It would be interesting to study what has changed in this country over this time to drive this figure in the data higher. The country with the next largest increase in forest area from 1990 to 2016 was the United States, but it only saw an increase of 79200 km2, much lower than the figure for China.

China and United States are of course very large countries in total land area, so when we look at the largest percent change in forest area from 1990 to 2016, we aren’t surprised to find a much smaller country listed at the top. Iceland increased in forest area by 213.66% from 1990 to 2016. 

b. LARGEST CONCERNS
Which countries are seeing deforestation to the largest degree? We can answer this question in two ways. First, we can look at the absolute square kilometer decrease in forest area from 1990 to 2016. The following 3 countries had the largest decrease in forest area over the time period under consideration: 


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
