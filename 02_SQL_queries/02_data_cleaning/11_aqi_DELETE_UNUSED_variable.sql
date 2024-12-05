DELETE FROM aqi_cleaned
WHERE variable = 'aqi' OR
	  variable ='pm1' OR
	  variable ='mepaqi'OR
	  variable ='neph' OR 
	  variable ='pol' OR
	  variable ='d' OR
	  variable ='psi';

