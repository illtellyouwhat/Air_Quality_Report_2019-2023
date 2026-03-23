SELECT 
    COUNT(CASE WHEN  date IS NULL THEN 1 END) AS date_null_count,
    COUNT(CASE WHEN  country IS NULL THEN 1 END) AS country_null_count,
    COUNT(CASE WHEN  city IS NULL THEN 1 END) AS city_null_count,
	COUNT(CASE WHEN  variable IS NULL THEN 1 END) AS variablbe_null_count,
	COUNT(CASE WHEN  count IS NULL THEN 1 END) AS count_null_count,
	COUNT(CASE WHEN  min IS NULL THEN 1 END) AS min_null_count,
	COUNT(CASE WHEN  max IS NULL THEN 1 END) AS max_null_count,
	COUNT(CASE WHEN  median IS NULL THEN 1 END) AS median_null_count,
	COUNT(CASE WHEN  variance IS NULL THEN 1 END) AS variance_null_count
    
FROM aqi;
