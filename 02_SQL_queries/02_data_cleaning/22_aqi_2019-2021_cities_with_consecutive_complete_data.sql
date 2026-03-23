-- 4 CTEs created:
-- 1) days_in_months:        group the number of recorded days for each city by month/year
-- 2) complete_data_filter:  filter the 1st CTE to show data for all 12 months and at least 270 days
-- 3) group_complete_years:  group the complete data into number of years present
-- 4) consecutive_years:     filters for all years in VIEW to ensure consecutive year over year data
-- final select generates a list of cites that have this complete data to be filtered for final analysis

WITH days_in_months AS (
    SELECT 
        city,
        variable,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month,
        COUNT(DISTINCT date) AS unique_date_count
    FROM 
        "aqi_2019-2021"
    WHERE 
        variable IN ('no2', 'o3', 'pm25', 'pm10', 'so2', 'co') -- only look at polution data to ensure most complete polution analysis, can rerun for weather 
    GROUP BY 
        city,
        variable,
        EXTRACT(YEAR FROM date),
        EXTRACT(MONTH FROM date)
),

complete_data_filter AS (
    SELECT 
        city,
        variable,
        year,
        COUNT(DISTINCT month) AS month_count,
        SUM(unique_date_count) AS total_unique_dates 
    FROM 
        days_in_months
    GROUP BY 
        city,
        variable,
        year
    HAVING 
        COUNT(DISTINCT month) = 12 AND    -- Ensure all months are present
        SUM(unique_date_count) >= 270     -- Ensure the year has at least 270 days
),

group_complete_years AS (
    SELECT 
        city,
        variable,
        year,
        ROW_NUMBER() OVER (PARTITION BY city, variable ORDER BY year) AS year_order,
        year - ROW_NUMBER() OVER (PARTITION BY city, variable ORDER BY year) AS year_group  -- Create grouping ID by number of years 
    FROM 
        complete_data_filter
),

consecutive_years AS (
    SELECT 
        city,
        variable,
        MIN(year) AS start_year,
        MAX(year) AS end_year,
        COUNT(year) AS consecutive_years
    FROM 
        group_complete_years
    GROUP BY 
        city,
        variable,
        year_group
    HAVING 
        COUNT(year) >= 3   -- only show 3 consecutive years (all years in VIEW)
)

SELECT 
    DISTINCT city
FROM 
    consecutive_years;
