CREATE TABLE aqi_full AS 
SELECT * FROM aqi_sd_ra_z_who;

CREATE TABLE aqi_magnitude AS
SELECT * FROM aqi_sd_ra_z_who_magnitude;

DROP MATERIALIZED VIEW IF EXISTS "aqi_2019-23",
	                 aqi_cleaned_weights,
					 aqi_sd,
					 aqi_sd_ra,
					 aqi_sd_ra_z,
					 aqi_sd_ra_z_who,
					 aqi_sd_ra_z_who_magnitude;
					 
DROP VIEW IF EXISTS					 
					 "aqi_2019-2021",
					 "aqi_2022-2023";
					 
DROP TABLE IF EXISTS
					 "cities_2019-21",
					 "cities_2022-23",
					 "who_guidelines";
					 