SELECT date,
	   city,
	   variable,
	   min,
	   max,
	   median,
	   "30_day_rolling_avg",
	   z_score_all,
	   z_score_city,
	   magnitude_score
	   
FROM aqi_full_report 
WHERE variable NOT IN ('co','no2','o3','pm10','pm25','so2')