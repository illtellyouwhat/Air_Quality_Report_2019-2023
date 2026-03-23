CREATE MATERIALIZED VIEW "aqi_sd_ra_z_who" AS 

		SELECT aqi.*, 
		   CASE WHEN variable = 'pm25' AND median > who.avg_time_24h OR
					 variable = 'pm10' AND median > who.avg_time_24h OR
					 -- calculation to acount for an 8h avg standard instead of usual 24
					 variable = 'o3' AND median *.06 > who.avg_time_8h OR
					 variable = 'no2' AND median > who.avg_time_24h OR
					 variable = 'so2' AND median > who.avg_time_24h OR
					 variable = 'co' AND median > who.avg_time_24h 
					 THEN 1 ELSE 0 
		    END AS over_who_limit,
			-- add WHO limits for context if necessary when pulling rows
			who.avg_time_24h, 
			who.avg_time_8h
	  FROM aqi_sd_ra_z AS aqi
	  -- join guideline table so that every variable has the limit posted in its own row
      FULL OUTER JOIN who_guidelines AS who
      ON aqi.variable = who.pollutant




