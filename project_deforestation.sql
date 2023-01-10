--VIEW
DROP VIEW IF EXISTS forestation;
CREATE VIEW forestation
AS
  (SELECT f.*,
   		  l.total_area_sq_mi,
   		  l.total_area_sq_mi*2.59 AS total_area_sqkm,
   	    f.forest_area_sqkm*100/(l.total_area_sq_mi*2.59) AS perc_forest_area,
   		  r.region,
   		  r.income_group
   FROM forest_area f
   JOIN land_area l
   ON l.country_code = f.country_code AND l.year = f.year
   LEFT JOIN regions r
   ON r.country_code = f.country_code);

--GLOBAL SITUATION
-- Question A.
WITH forest_area_1990
     AS (SELECT forest_area_sqkm AS fa_1990
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 1990),
     forest_area_2016
     AS (SELECT forest_area_sqkm AS fa_2016
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 2016)
SELECT fa_1990
FROM   forest_area_1990;

-- Question B.
WITH forest_area_1990
     AS (SELECT forest_area_sqkm AS fa_1990
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 1990),
     forest_area_2016
     AS (SELECT forest_area_sqkm AS fa_2016
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 2016)
SELECT fa_2016
FROM   forest_area_2016;

-- Question C.
WITH forest_area_1990
     AS (SELECT forest_area_sqkm AS fa_1990
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 1990),
     forest_area_2016
     AS (SELECT forest_area_sqkm AS fa_2016
         FROM   forestation
         WHERE  country_name = 'World'
                AND year = 2016)
SELECT fa_1990 - fa_2016 AS difference
FROM   forest_area_1990,
       forest_area_2016;

-- Question D.
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

-- Question E.
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
     difference
     AS (SELECT fa_1990 - fa_2016 AS difference
         FROM   forest_area_1990,
                forest_area_2016)
SELECT country_name,
       total_area_sqkm,
       Abs(total_area_sqkm - difference) AS abs_difference
FROM   forestation,
       difference
WHERE  year = 2016
ORDER  BY 3
LIMIT  1;

--REGIONAL OUTLOOK

-- Question A
--TABLE
WITH forest_precentage_1990
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY 1),
     forest_precentage_2016
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY 1),
     joined_1990_2016
     AS (SELECT a.region AS region,
                a.perc_fa_1990 AS perc_fa_1990,
                b.perc_fa_2016 AS perc_fa_2016
         FROM   forest_precentage_1990 a
                JOIN forest_precentage_2016 b
                  ON a.region = b.region)
SELECT region,
       Round(perc_fa_1990 :: numeric, 2) perc_fa_1990,
       Round(perc_fa_2016 :: numeric, 2) perc_fa_2016
FROM   joined_1990_2016;

--What was the percent forest of the entire world in 2016?

WITH forest_precentage_1990
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY 1),
     forest_precentage_2016
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY 1),
     joined_1990_2016
     AS (SELECT a.region AS region,
                a.perc_fa_1990 AS perc_fa_1990,
                b.perc_fa_2016 AS perc_fa_2016
         FROM   forest_precentage_1990 a
                JOIN forest_precentage_2016 b
                  ON a.region = b.region)
SELECT Round(perc_fa_2016 :: numeric, 2) AS perc_forestarea_2016
FROM   joined_1990_2016
WHERE  region = 'World';

--Which region had the HIGHEST percent forest in 2016?

WITH forest_precentage_1990
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY 1),
     forest_precentage_2016
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY 1),
     joined_1990_2016
     AS (SELECT a.region AS region,
                a.perc_fa_1990 AS perc_fa_1990,
                b.perc_fa_2016 AS perc_fa_2016
         FROM   forest_precentage_1990 a
                JOIN forest_precentage_2016 b
                  ON a.region = b.region)
SELECT region,
       Round(perc_fa_2016::numeric,2) AS perc_forestarea_2016
FROM joined_1990_2016
ORDER BY 2 DESC
LIMIT 1;

--Which region had the LOWEST percent forest in 2016?

WITH forest_precentage_1990
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY 1),
     forest_precentage_2016
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY 1),
     joined_1990_2016
     AS (SELECT a.region AS region,
                a.perc_fa_1990 AS perc_fa_1990,
                b.perc_fa_2016 AS perc_fa_2016
         FROM   forest_precentage_1990 a
                JOIN forest_precentage_2016 b
                  ON a.region = b.region)
SELECT region,
       Round(perc_fa_2016::numeric,2) AS perc_forestarea_2016
FROM joined_1990_2016
ORDER BY 2 ASC
LIMIT 1;

-- Question B
--What was the percent forest of the entire world in 1990?

WITH forest_precentage_1990
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY 1),
     forest_precentage_2016
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY 1),
     joined_1990_2016
     AS (SELECT a.region AS region,
                a.perc_fa_1990 AS perc_fa_1990,
                b.perc_fa_2016 AS perc_fa_2016
         FROM   forest_precentage_1990 a
                JOIN forest_precentage_2016 b
                  ON a.region = b.region)
SELECT Round(perc_fa_1990 :: numeric, 2) AS perc_forestarea_1990
FROM   joined_1990_2016
WHERE  region = 'World';

--Which region had the HIGHEST percent forest in 2016?

WITH forest_precentage_1990
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY 1),
     forest_precentage_2016
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY 1),
     joined_1990_2016
     AS (SELECT a.region AS region,
                a.perc_fa_1990 AS perc_fa_1990,
                b.perc_fa_2016 AS perc_fa_2016
         FROM   forest_precentage_1990 a
                JOIN forest_precentage_2016 b
                  ON a.region = b.region)
SELECT region,
       Round(perc_fa_1990::numeric,2) AS perc_forestarea_1990
FROM joined_1990_2016
ORDER BY 2 DESC
LIMIT 1;

--Which region had the LOWEST percent forest in 2016?

WITH forest_precentage_1990
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY 1),
     forest_precentage_2016
     AS (SELECT region,
                SUM(forest_area_sqkm) * 100 / SUM(total_area_sqkm) AS
                perc_fa_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY 1),
     joined_1990_2016
     AS (SELECT a.region AS region,
                a.perc_fa_1990 AS perc_fa_1990,
                b.perc_fa_2016 AS perc_fa_2016
         FROM   forest_precentage_1990 a
                JOIN forest_precentage_2016 b
                  ON a.region = b.region)
SELECT region,
       Round(perc_fa_1990::numeric,2) AS perc_forestarea_1990
FROM joined_1990_2016
ORDER BY 2 ASC
LIMIT 1;

--COUNTRY-LEVEL DETAIL
--Table
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
SELECT *
FROM   joined_1990_2016;

-- Question A.

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

--Find the 2 top countries with the higher increase in the forest area
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
       forest_area_2016 -  forest_area_1990 AS forest_area_increase
FROM   joined_1990_2016
WHERE  country_name != 'World'
       AND forest_area_1990 IS NOT NULL
       AND forest_area_2016 IS NOT NULL
ORDER  BY 3 DESC
LIMIT  2;

--Question B.

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
                b.forest_area_2016 AS forest_area_2016,
                (a.forest_area_1990 - b.forest_area_2016)*100/forest_area_1990  AS perc_fa_decrease
         FROM   forest_area_1990 a
                JOIN forest_area_2016 b
                  ON a.region = b.region
                     AND a.country_name = b.country_name)
SELECT country_name,
       region,
       ROUND(perc_fa_decrease::numeric, 2) AS perc_fa_decrease
FROM joined_1990_2016
WHERE country_name != 'World'
      AND forest_area_1990 IS NOT NULL
      AND forest_area_2016 IS NOT NULL
ORDER BY 3 DESC
LIMIT 5;

--Find the 2 top countries with the lasgest percentage increase
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
                b.forest_area_2016 AS forest_area_2016,
                (a.forest_area_1990 - b.forest_area_2016)*100/forest_area_1990  AS perc_fa_decrease,
                (b.forest_area_2016 - a.forest_area_1990)*100/forest_area_1990  AS perc_fa_increase
         FROM   forest_area_1990 a
                JOIN forest_area_2016 b
                  ON a.region = b.region
                     AND a.country_name = b.country_name)
SELECT country_name,
       region,
       ROUND(perc_fa_increase::numeric, 2) AS perc_fa_decrease
FROM joined_1990_2016
WHERE country_name != 'World'
      AND forest_area_1990 IS NOT NULL
      AND forest_area_2016 IS NOT NULL
ORDER BY 3 DESC
LIMIT 2;

-- Questio C.
WITH percentiles
  AS (SELECT country_name,
              region,
              perc_forest_area AS perc_fa_2016,
              CASE
                     WHEN perc_forest_area >= 75 THEN '75% - 100%'
                     WHEN perc_forest_area >= 50 THEN '50% - 75%'
                     WHEN perc_forest_area >= 25 THEN '25% - 50%'
                     ELSE '0 - 25%'
              END AS percentile
       FROM   forestation
       WHERE  year = 2016
              AND    country_name != 'World'
              AND    perc_forest_area IS NOT NULL)
SELECT percentile,
        Count(percentile)
FROM   percentiles
GROUP  BY 1
ORDER  BY 2 DESC
LIMIT  1;

-- Question D.
WITH percentiles
  AS (SELECT country_name,
              region,
              perc_forest_area AS perc_fa_2016,
              CASE
                     WHEN perc_forest_area >= 75 THEN '75% - 100%'
                     WHEN perc_forest_area >= 50 THEN '50% - 75%'
                     WHEN perc_forest_area >= 25 THEN '25% - 50%'
                     ELSE '0 - 25%'
              END AS percentile
       FROM   forestation
       WHERE  year = 2016
              AND    country_name != 'World'
              AND    perc_forest_area IS NOT NULL)
SELECT country_name,
       region,
       ROUND(perc_fa_2016::numeric,2)
FROM percentiles
WHERE percentile = '75% - 100%'
ORDER BY 3 DESC;

-- Question E.

WITH percentiles
  AS (SELECT country_name,
              region,
              perc_forest_area AS perc_fa_2016,
              CASE
                     WHEN perc_forest_area >= 75 THEN '75% - 100%'
                     WHEN perc_forest_area >= 50 THEN '50% - 75%'
                     WHEN perc_forest_area >= 25 THEN '25% - 50%'
                     ELSE '0 - 25%'
              END AS percentile
       FROM   forestation
       WHERE  year = 2016
              AND    country_name != 'World'
              AND    perc_forest_area IS NOT NULL)
SELECT
       COUNT(perc_fa_2016)
FROM percentiles
WHERE perc_fa_2016 > (
                      SELECT perc_fa_2016
                      FROM percentiles
                      WHERE country_name = 'United States');



--Number of countries that must be divided in quartiles
WITH countries AS (SELECT region, COUNT(country_name) AS countries
FROM forestation
WHERE year = 2016 AND perc_forest_area IS NOT NULL AND
		country_name != 'World'
GROUP BY region)
SELECT SUM(countries)
FROM countries  -- 204
