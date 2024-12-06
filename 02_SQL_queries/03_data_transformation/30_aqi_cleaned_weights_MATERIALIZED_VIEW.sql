-- Each variable is grouped by city/month/year and a percentage is assigned to each month of the year
-- for weighting the 30 day rolling averages that will be calculated

CREATE MATERIALIZED VIEW aqi_cleaned_weights AS
SELECT
    country,
    city,
    EXTRACT(year FROM date) AS year,
    EXTRACT(month FROM date) AS month,
    variable,
    ROUND(
        SUM(CASE WHEN min = 0 AND max = 0 AND median = 0 THEN 0 ELSE 1 END)::numeric / COUNT(*),
        2
    ) AS completeness_score
FROM
    aqi_cleaned
GROUP BY
    country,
    city,
    variable,
    year,
    month
ORDER BY
    country,
    city,
    variable,
    year,
    month;



