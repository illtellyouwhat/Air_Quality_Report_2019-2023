SELECT a.date, a.country, a.city, a.count, a.min, a.max, a.median, a.variance, a.variable,b.variable,
        b.date, b.country, b.city, b.count, b.min, b.max, b.median, b.variance
FROM aqi AS a
JOIN aqi AS b
ON a.date = b.date AND
   a.country = b.country AND
   a.city = b.city AND
   a.count = b.count AND
   a.min = B.min AND
   a.max = b.max AND
   a.median = b.median AND
   a.variance = b.variance AND
   a.variable < b.variable
WHERE a.variable IN ('wind speed', 'wind-speed') AND
	  b.variable IN ('wind speed', 'wind-speed')
;




