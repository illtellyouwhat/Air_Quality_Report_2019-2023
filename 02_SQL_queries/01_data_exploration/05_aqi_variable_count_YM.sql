SELECT EXTRACT(YEAR FROM date) AS year,
	   EXTRACT(MONTH FROM date) AS month,
	   variable, 
	   COUNT(variable)
	   
FROM aqi

GROUP BY year,
		 month,
	     variable

ORDER BY year ASC,
	     month ASC,
	     variable DESC, 
		 count DESC
