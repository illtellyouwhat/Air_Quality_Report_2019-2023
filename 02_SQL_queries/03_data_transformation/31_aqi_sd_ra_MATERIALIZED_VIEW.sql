-- This takes the aqi_cleaned_weights table which just has the weights (completeness score) reported by month and applies it to the full table 
-- aqi_sd, from there the 30 day rolling average for every variable is calculated by a window function partitioned by
-- country,city,and variable. 
--
-- The resulting table has the weights for the month and the weighted 30 day rolling average columns added

CREATE MATERIALIZED VIEW "aqi_sd_ra" AS

-- Join aqi_cleaned_weights to current table to enable calculations by window function
WITH complete_score AS (
	SELECT a.*, w.completeness_score 
	FROM aqi_sd AS a
	JOIN aqi_cleaned_weights AS w
	ON a.country = w.country AND
	   a.city = w.city AND
	   EXTRACT(year FROM a.date) = w.year AND
	   EXTRACT(month FROM a.date) = w.month AND
	   a.variable = w.variable
),

-- Calculate 30 day rolling average based on joined tables
weighted_rolling_avg AS (
    SELECT
        *,
	-- Round result to 2 decimal places and CAST as numeric; FLOAT type cannot be rounded
		ROUND(
			CAST(
				AVG(median * completeness_score) OVER 
				(PARTITION BY country, city, variable 
				ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) 
				/
			-- Use NULLIF to avoid divide by 0 where there is no data
				NULLIF(
					AVG(completeness_score) OVER 
					(PARTITION BY country, city, variable 
					ORDER BY date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW)
					,0)
				AS NUMERIC)
			,2)
		AS "30_day_rolling_avg"
    FROM
        complete_score
)

-- include all new columns in final table
SELECT * 
FROM weighted_rolling_avg
ORDER BY country, city, variable, date;