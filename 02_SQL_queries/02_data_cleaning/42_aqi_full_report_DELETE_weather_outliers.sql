
DELETE FROM aqi_full_report 
WHERE variable NOT IN ('co','no2','o3','pm10','pm25','so2') AND
(Variable = 'dew' AND min < 0 AND max > 34) OR
(Variable = 'humidity' AND min < 0 AND max > 100) OR
(Variable = 'precipitation' AND min < 0 AND max > 2500) OR
(Variable = 'temperature' AND min < -70 AND max > 56) OR
(Variable = 'wd' AND min < 0 AND max > 360) OR
(Variable = 'wind-gust' AND min < 0 AND max > 400) OR
(Variable = 'wind-speed' AND min < 0 AND max > 300)


