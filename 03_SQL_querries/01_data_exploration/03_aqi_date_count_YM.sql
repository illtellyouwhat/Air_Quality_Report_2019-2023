SELECT EXTRACT(YEAR FROM date) AS year, EXTRACT (MONTH FROM date) as month, EXTRACT (DAY FROM date) AS day, date, COUNT(date)
FROM aqi
GROUP BY DISTINCT(year),month,day,date
ORDER BY year ASC, MONTH ASC, day ASC, date ASC, count DESC
