SELECT EXTRACT(YEAR FROM date) AS year, 
       EXTRACT (MONTH FROM date) as month, 
       EXTRACT (DAY FROM date) as day, 
       COUNT(date)

FROM aqi

GROUP BY DISTINCT(year),
         month, 
         day

ORDER BY year ASC, 
         MONTH ASC, 
         count DESC
