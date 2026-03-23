CREATE MATERIALIZED VIEW aqi_cleaned_sd AS
SELECT *, ROUND(SQRT(variance::numeric),2) AS SD
FROM aqi_cleaned

