	--Create CTE with window function that will number each duplicate row as 2 or more
WITH duplicates AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY date, country, city, variable, count, min, max, median, variance
               ORDER BY (SELECT NULL)                     
           ) AS row_num
    FROM aqi
)
	-- Drop the rows that are duplicates
DELETE FROM aqi
USING duplicates
WHERE aqi.date = duplicates.date
  AND aqi.country = duplicates.country
  AND aqi.city = duplicates.city
  AND aqi.variable = duplicates.variable
  AND aqi.count = duplicates.count
  AND aqi.min = duplicates.min
  AND aqi.max = duplicates.max
  AND aqi.median = duplicates.median
  AND aqi.variance = duplicates.variance
  AND duplicates.row_num > 1; 
