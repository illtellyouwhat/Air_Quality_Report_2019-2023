SELECT EXTRACT(YEAR FROM date) AS year,
	   EXTRACT(MONTH FROM date) AS month,
	   EXTRACT(DAY FROM date) AS day,
	   variable, 
	   COUNT(variable)
	   
FROM aqi

GROUP BY year,
		 month,
		 day,
		 variable

ORDER BY year ASC,
	     month ASC,
		 day ASC,
	     variable DESC, 
		 count DESC
