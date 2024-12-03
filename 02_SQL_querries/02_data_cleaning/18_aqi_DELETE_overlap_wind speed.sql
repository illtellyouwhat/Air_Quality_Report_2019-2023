DELETE FROM aqi
WHERE variable = 'wind speed'
  AND EXISTS (
    SELECT 1
    FROM aqi AS b
    WHERE aqi.date = b.date
      AND aqi.country = b.country
      AND aqi.city = b.city
      AND aqi.count = b.count
      AND aqi.min = b.min
      AND aqi.max = b.max
      AND aqi.median = b.median
      AND aqi.variance = b.variance
      AND b.variable = 'wind-speed'
  );
