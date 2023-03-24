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

<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/Regional%20outlook.png" alt="Regional Outlook"> 


The only regions of the world that decreased in percent forest area from 1990 to 2016 were Latin America & Caribbean (dropped from 51.03% to 46.16%) and Sub-Saharan Africa (30.67% to 28.79%). All other regions actually increased in forest area over this time period.

## 3. Country-level Detail

a. SUCCESS STORIES
There is one particularly bright spot in the data at the country level, China. This country actually increased in forest area from 1990 to 2016 by 527229.062 km2. It would be interesting to study what has changed in this country over this time to drive this figure in the data higher. The country with the next largest increase in forest area from 1990 to 2016 was the United States, but it only saw an increase of 79200 km2, much lower than the figure for China.

China and United States are of course very large countries in total land area, so when we look at the largest percent change in forest area from 1990 to 2016, we aren’t surprised to find a much smaller country listed at the top. Iceland increased in forest area by 213.66% from 1990 to 2016. 

b. LARGEST CONCERNS
Which countries are seeing deforestation to the largest degree? We can answer this question in two ways. First, we can look at the absolute square kilometer decrease in forest area from 1990 to 2016. The following 3 countries had the largest decrease in forest area over the time period under consideration: 

<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/Amount%20Decrease%20in%20Forest%20Area%20by%20Country.png" alt="Forest area by country"> 

The second way to consider which countries are of concern is to analyze the data by percent decrease.


<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/Percent%20Decrease%20in%20Forest%20Area%20by%20Country.png" alt="Percent Decrease in Forest Area by Country"> 

When we consider countries that decreased in forest area percentage the most between 1990 and 2016, we find that four of the top 5 countries on the list are in the region of Sub-Saharan Africa. The countries are Togo, Nigeria, Uganda and Mauritania. The fifth country on the list is Honduras which is in the Latin America & Caribbean region. 

From the above analysis, we see that Nigeria is the only country that ranks in the top 5 both in terms of absolute square kilometer decrease in forest as well as percent decrease in forest area from 1990 to 2016. Therefore, this country has a significant opportunity ahead to stop the decline and hopefully spearhead remedial efforts.


## 4. Quartiles
The largest number of countries in 2016 were found in the 0 – 25% quartile.

<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/quartiles.png" alt="Quartiles"> 

There were 9 countries in the top quartile in 2016. These are countries with a very high percentage of their land area designated as forest. The following is a list of countries and their respective forest land, denoted as a percentage.

<img src="https://github.com/jorgeUnas/Deforestation_Analysis_SQL/blob/main/Top%20Quartile%20Countries.png" alt="Top Quartile Countries, 2016">  

## 5. Recomendations
- According to the data from the World Bank the forestation areas of the planet have decreased from 1990 to 2016 in a quantity comparable with the entire land area of Peru.  
- Although in most of the regions analysed the percentage of forest areas during this period has increased, it is concerning the high decrease of this percentage in the Latin America & Caribbean and Sub-Saharan Africa regions. 
= In this report it has been highlighted China, the United States and Iceland as countries with representative growth in the forest areas. These countries could be used as models to come up with successful strategies for the most deforested countries.  
- Among the most affected countries, Brazil had the higher reduction in the amount of forest area. Some countries from the Sub-Saharan Africa region had the highest reduction in the percentage of forest areas, among them Nigeria deserves special attention because it is also one of the most deforested countries in terms of square kilometres.
- When we analysed all the countries based on the percentage of forest areas it was found that just 9 countries are in the top level of the countries with high areas designated as forest.
- Based on these results, it is concluded that ForestQuery should put most of its efforts in countries from the Latin America & Caribbean and Sub-Saharan Africa regions, giving priority to Brazil and Nigeria, the most deforested countries from 1990 to 2016.



