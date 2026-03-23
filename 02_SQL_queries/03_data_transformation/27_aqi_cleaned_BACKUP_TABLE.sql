CREATE TABLE aqi_cleaned_backup AS
SELECT * FROM aqi_cleaned WHERE false;

INSERT INTO aqi_cleaned_backup
SELECT *
FROM aqi_cleaned;