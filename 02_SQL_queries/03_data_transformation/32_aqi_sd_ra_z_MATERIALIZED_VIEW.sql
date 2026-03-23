-- 2 Z scores are calculated: 1) against the entire dataset and 2) for just the city. 
-- This will help in analysis of looking at outliers that exist against the cities historical background vs world
-- The first CTE calculates the mean of the 30 day rolling average for each variable and its SD for all data
-- The Second CTE does the same but broken down by city
-- The final table joins this data to the main table so that the z scores can be calculated

CREATE MATERIALIZED VIEW aqi_sd_ra_z AS
WITH pre_z_all AS (
    -- Calculate mean of the 30 day rolling average and it's standard deviation for each variable across entire dataset
	-- This provides the best "overall" view of outliers as a whole
	SELECT
        variable,
        ROUND(AVG("30_day_rolling_avg"),2) AS mean_30_day_avg_all,
        ROUND(STDDEV("30_day_rolling_avg"),2) AS sd_30_day_avg_all
    FROM
        aqi_sd_ra
    GROUP BY
        variable
),
pre_z_city AS (
	-- Calculate mean of the 30 day rolling average and it's standard deviation for each variable for each city 
	-- this allows for to spot significant outliers more easily without getting smoothed over by better performing cities overall
	SELECT
		city,
        variable,
        ROUND(AVG("30_day_rolling_avg"),2) AS mean_30_day_avg_city,
        ROUND(STDDEV("30_day_rolling_avg"),2) AS sd_30_day_avg_city
    FROM
        aqi_sd_ra
    GROUP BY
        city,variable)

SELECT
    ra.*,
    -- Calculate z-score normalized for all/city
    ROUND((ra."30_day_rolling_avg" - a.mean_30_day_avg_all) / NULLIF(a.sd_30_day_avg_all,0),2) AS z_score_all,
	ROUND((ra."30_day_rolling_avg" - c.mean_30_day_avg_city) / NULLIF(c.sd_30_day_avg_city,0),2) AS z_score_city
FROM
    aqi_sd_ra AS ra
JOIN
    pre_z_all AS a
    ON ra.variable = a.variable
JOIN
	pre_z_city AS c
	ON ra.variable = c.variable AND ra.city = c.city
    
ORDER BY
    ra.country, ra.city, ra.variable, ra.date;
