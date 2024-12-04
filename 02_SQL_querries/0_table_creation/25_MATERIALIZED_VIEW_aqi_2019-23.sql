CREATE MATERIALIZED VIEW "aqi_2019-23" AS

	SELECT * FROM aqi

	WHERE city IN 

		(SELECT a.city 
		FROM "cities_2019-21" AS a
		INNER JOIN "cities_2022-23" AS b
		ON a.city = b.city)

		AND

		EXTRACT(YEAR FROM date) >= 2018
