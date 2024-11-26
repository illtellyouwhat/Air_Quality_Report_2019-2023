CREATE TABLE IF NOT EXISTS aqi
(
    date date,
    country character varying(2),
    city character varying(50),
    variable character varying(20),
    count integer,
    min float,
    max float,
    median float,
    variance float
)