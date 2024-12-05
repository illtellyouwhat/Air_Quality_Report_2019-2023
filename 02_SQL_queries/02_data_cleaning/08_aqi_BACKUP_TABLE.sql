CREATE TABLE aqi_backup AS 
SELECT * FROM aqi WHERE false;

INSERT INTO aqi_backup
SELECT *
FROM aqi;
