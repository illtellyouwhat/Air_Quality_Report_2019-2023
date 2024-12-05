-- Same query as file 22 but the filter is changed to 6 months (number of valid months in 2023) and 140 days complete over that time.


WITH days_in_months AS (
    SELECT 
        city,
        variable,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(MONTH FROM date) AS month,
        COUNT(DISTINCT date) AS unique_date_count
    FROM 
        "aqi_2022-2023"
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
        COUNT(DISTINCT month) >= 6 AND    -- Ensure at least number of months in 2023 VIEW present
        SUM(unique_date_count) >= 140     -- Ensure the there are at least 140 days (75% of 6 months) present
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
        COUNT(year) >= 2   -- only show 2 consecutive years (all years in VIEW)
)

SELECT 
    DISTINCT city
FROM 
    consecutive_years;
