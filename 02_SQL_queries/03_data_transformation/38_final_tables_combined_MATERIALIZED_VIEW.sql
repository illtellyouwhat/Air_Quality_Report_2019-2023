CREATE MATERIALIZED VIEW aqi_full_report AS
	
	SELECT a.*, 
		   b.exceedance_percentage AS monthly_percent_exceeded,
		   b.avg_magnitude,
		   b.magnitude_score

	FROM aqi_full AS a

	FULL OUTER JOIN aqi_magnitude AS b ON
		 EXTRACT(MONTH FROM a.date) = b.month AND
		 EXTRACT(YEAR FROM a.date) = b.year AND
		 a.city = b.city AND
		 a.variable = b.variable
		
		   