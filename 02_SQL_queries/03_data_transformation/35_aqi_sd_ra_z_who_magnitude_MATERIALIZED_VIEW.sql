-- Creates a magnitude score which is a composite of the percentage of days in a month the pollutant exceedes the WHO limit
-- and the ammount over the limit (median - who_guideline) as it compares to the average amount the pollutant was
-- exceeded for the month
--
-- A CTE is created that counts the days over the limit for each pollutant variable and a COUNT of the days in the grouping
-- (months over years by city and variable) as well as the average amount that each pollutant exceeded AVG(median - who_limit)
--
-- The finsal SELECT calculates the percentage of days that each variable exceeded the WHO limit and creates the final composite 
-- score by adding the equal weighted (.5) variables (percentage of days over + AVG ammount exceeded for the month)
--
-- This allows a rough look at how "bad" the pollution was for a given variable/time period

CREATE MATERIALIZED VIEW aqi_sd_ra_z_who_magnitude AS
WITH monthly_aggregates AS (
    SELECT 
        country,
        city,
        variable,
        EXTRACT(year FROM date) AS year,
        EXTRACT(month FROM date) AS month,
        -- COUNT/SUM columns to later be calculated as percentage
		COUNT(*) AS total_days,
        SUM(over_who_limit) AS days_over_limit,
		-- Create avege ammount the pollutant exceedes the limit grouped by month over year
        ROUND(
            AVG(
                CASE
                    WHEN over_who_limit = 1 AND variable = 'o3' THEN median - avg_time_8h::double precision
                    WHEN over_who_limit = 1 THEN median - avg_time_24h::double precision
                    ELSE NULL::double precision
                END
            )::numeric, 0
        ) AS avg_magnitude
    FROM 
        aqi_sd_ra_z_who
	GROUP BY 
        country, city, variable, EXTRACT(year FROM date), EXTRACT(month FROM date)
)
SELECT 
    country,
    city,
    variable,
    year,
    month,
	-- Create percentage from previous COUNT/SUM collums
    ROUND(
        (days_over_limit::numeric / NULLIF(total_days, 0)) * 100, 0
    ) AS exceedance_percentage,
    avg_magnitude,
	-- Create magnitude score by combining percentage of days over limit and average ammount over limit equally weighted
    ROUND(
        0.5 * (days_over_limit::numeric / total_days::numeric) * 100 + 0.5 * avg_magnitude, 0
    ) AS magnitude_score
FROM 
    monthly_aggregates
-- Only include pollutant variables as weather data is erroneous here 
WHERE 
	variable IN ('co','o3','no2','pm25','pm10','so2')
ORDER BY 
    country, city, variable, year, month;
