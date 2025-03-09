/* Setting up the tables for analysis */

/* Add state and region identifiers to the housing data table */

ALTER TABLE "housing_data"
ADD city text,
ADD state text,
ADD region text;

/* Add state and region identifiers to the population data table */

ALTER TABLE "population_data_2020-2023"
ADD city text,
ADD state text,
ADD region text;

/* Populate new columns in housing data table with values from income data table */

UPDATE "housing_data" h
SET city = i.city
FROM "income_data" i
WHERE h.cbsa_code = i.cbsa_code;

UPDATE "housing_data" h
SET state = i.state
FROM "income_data" i
WHERE h.cbsa_code = i.cbsa_code;

UPDATE "housing_data" h
SET region = i.region
FROM "income_data" i
WHERE h.cbsa_code = i.cbsa_code;

/* Populate new columns in population data table with values from income data table */

UPDATE "population_data_2020-2023" p
SET city = i.city
FROM "income_data" i
WHERE p.cbsa_code = i.cbsa_code;

UPDATE "population_data_2020-2023" p
SET state = i.state
FROM "income_data" i
WHERE p.cbsa_code = i.cbsa_code;

UPDATE "population_data_2020-2023" p
SET region = i.region
FROM "income_data" i
WHERE p.cbsa_code = i.cbsa_code;

/* Delete smaller metros from housing data table */

DELETE FROM "housing_data"
WHERE city ISNULL;

/* Delete smaller metros and counties from population data table */

DELETE FROM "population_data"
WHERE city ISNULL OR lsad != 'Metropolitan Statistical Area';

/* Merge population data tables */

CREATE TABLE "population_data" AS (
	SELECT p2.city,
		p2.state,
		p2.region,
		p2.cbsa_title,
		p2.cbsa_code,
		p1.est_2016,
		p1.est_2017,
		p1.est_2018,
		p1.est_2019,
		p2.est_2020,
		p2.est_2021,
		p2.est_2022,
		p2.est_2023
	FROM "population_data_2016-2019" AS p1 JOIN "population_data_2020-2023" AS p2
	ON p1.cbsa_code = p2.cbsa_code
);

/* Make month a data format in the housing data table */

ALTER TABLE "housing_data"
ADD m_date date;

UPDATE "housing_data"
SET m_date = TO_DATE(month,'YYYYMM');

/* Table checks */

SELECT *
FROM "housing_data"
ORDER BY m_date DESC, city;

SELECT *
FROM "population_data"
ORDER BY city;

SELECT *
FROM "income_data"
ORDER BY city;
