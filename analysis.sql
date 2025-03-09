/* Exploratory data anaysis */

/* Median listing price, mean listing price, total listing count, and price per sqft by metro and month */
SELECT cbsa_title, region, m_date, median_listing_price, average_listing_price, total_listing_count, med_listing_price_per_sq_ft, median_days
FROM "housing_data"
ORDER BY m_date DESC, cbsa_code;

/* Percentage growth of median and mean listing price, and total listing count from Jan 2017 to Jan 2025 */
WITH h_2017 AS (
	SELECT cbsa_title, 
		state, 
		region, 
		median_listing_price AS mlp,
		average_listing_price AS alp,
		total_listing_count AS tlc,
		med_listing_price_per_sq_ft AS mlpsf,
		median_days AS md
	FROM "housing_data"
	WHERE month = '201701'
),

h_2025 AS (
	SELECT cbsa_title, 
		state, 
		region, 
		median_listing_price AS mlp,
		average_listing_price AS alp,
		total_listing_count AS tlc,
		med_listing_price_per_sq_ft AS mlpsf,
		median_days AS md
	FROM "housing_data"
	WHERE month = '202501'
)

SELECT h_2025.cbsa_title, 
	h_2025.state, 
	h_2025.region,
	ROUND(100*((h_2025.mlp*1.0)/h_2017.mlp)-100, 2) AS percent_change_mlp,
	ROUND(100*((h_2025.alp*1.0)/h_2017.alp)-100, 2) AS percent_change_alp,
	ROUND(100*((h_2025.tlc*1.0)/h_2017.tlc)-100, 2) AS percent_change_tlc,
	ROUND(100*((h_2025.mlpsf*1.0)/h_2017.mlpsf)-100, 2) AS percent_change_mlpsf,
	ROUND(100*((h_2025.md*1.0)/h_2017.md)-100, 2) AS percent_change_md
FROM h_2025 JOIN h_2017 ON h_2025.cbsa_title = h_2017.cbsa_title
ORDER BY percent_change_mlp DESC

/* Year-over-year growth */
SELECT cbsa_title, 
	region, 
	m_date, 
	mlp_change_year*100 AS percent_change_mlp, 
	alp_change_year*100 AS percent_change_alp, 
	tlc_change_year*100 AS percent_change_tlc, 
	mlpsf_change_year*100 AS percent_change_mlpsf,
	md_change_year*100 AS percent_change_md
FROM "housing_data"
ORDER BY m_date DESC, cbsa_code;

/* Month-over-month growth */
SELECT cbsa_title, 
	region, 
	m_date, 
	mlp_change_month+1 AS change_mlp, 
	alp_change_month+1 AS change_alp, 
	tlc_change_month+1 AS change_tlc, 
	mlpsf_change_month+1 AS change_mlpsf,
	md_change_month+1 AS change_md
FROM "housing_data"
ORDER BY m_date DESC, cbsa_code;

/* Highest yearly price growth each month */
CREATE TEMPORARY TABLE max_growth AS
SELECT cbsa_title, 
	region, 
	m_date,
	alp_change_year*100 AS alp_change_year,
	MIN(alp_change_year*100) OVER (PARTITION BY m_date) AS max_growth_alp
FROM "housing_data";

SELECT *
FROM max_growth
WHERE alp_change_year = max_growth_alp
ORDER BY m_date DESC;

DROP TABLE max_growth;

/* Housing data with population and income */
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2023 AS population,
	i.income_2023 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202307'
UNION
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2022 AS population,
	i.income_2022 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202207'
UNION
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2021 AS population,
	i.income_2021 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202107'
UNION
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2020 AS population,
	i.income_2020 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202007'
UNION
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2019 AS population,
	i.income_2019 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201907'
UNION
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2018 AS population,
	i.income_2018 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201807'
UNION
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2017 AS population,
	i.income_2017 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201707'
UNION
SELECT h.cbsa_title, 
	h.region, 
	h.m_date, 
	h.median_listing_price, 
	h.average_listing_price, 
	h.total_listing_count, 
	h.med_listing_price_per_sq_ft, 
	h.median_days,
	p.est_2016 AS population,
	i.income_2016 AS income
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201607'
ORDER BY m_date DESC, cbsa_title;

/* Percentage growth of hosuing data columns with population growth from July 2016 to July 2023 */
WITH h_2016 AS (
	SELECT cbsa_title, 
		cbsa_code,
		state, 
		region, 
		median_listing_price AS mlp,
		average_listing_price AS alp,
		total_listing_count AS tlc,
		med_listing_price_per_sq_ft AS mlpsf,
		median_days AS md
	FROM "housing_data"
	WHERE month = '201607'
),

h_2023 AS (
	SELECT cbsa_title,
		cbsa_code,
		state, 
		region, 
		median_listing_price AS mlp,
		average_listing_price AS alp,
		total_listing_count AS tlc,
		med_listing_price_per_sq_ft AS mlpsf,
		median_days AS md
	FROM "housing_data"
	WHERE month = '202307'
)

SELECT h_2023.cbsa_title, 
	h_2023.state, 
	h_2023.region,
	ROUND(100*((h_2023.mlp*1.0)/h_2016.mlp)-100, 2) AS percent_change_mlp,
	ROUND(100*((h_2023.alp*1.0)/h_2016.alp)-100, 2) AS percent_change_alp,
	ROUND(100*((h_2023.tlc*1.0)/h_2016.tlc)-100, 2) AS percent_change_tlc,
	ROUND(100*((h_2023.mlpsf*1.0)/h_2016.mlpsf)-100, 2) AS percent_change_mlpsf,
	ROUND(100*((h_2023.md*1.0)/h_2016.md)-100, 2) AS percent_change_md,
	ROUND(100*((p.est_2023*1.0)/p.est_2016)-100, 2) AS population_growth
FROM h_2023 JOIN h_2016 ON h_2023.cbsa_code = h_2016.cbsa_code 
JOIN "population_data" AS p ON h_2023.cbsa_code = p.cbsa_code
ORDER BY percent_change_md

/* Year-over-year growth with population and income data */
SELECT h.cbsa_title, 
	h.cbsa_code,
	h.state, 
	h.region, 
	h.m_date,
	h.mlp_change_year+1 AS percent_change_mlp, 
	h.alp_change_year+1 AS percent_change_alp, 
	h.tlc_change_year+1 AS percent_change_tlc, 
	h.mlpsf_change_year+1 AS percent_change_mlpsf,
	h.md_change_year+1 AS percent_change_md,
	ROUND(p.est_2023*1.0)/p.est_2022 AS population_growth,
	ROUND(i.income_2023*1.0)/i.income_2022 AS income_growth
FROM "housing_data" h JOIN "population_data" p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202307'
UNION
SELECT h.cbsa_title, 
	h.cbsa_code,
	h.state, 
	h.region, 
	h.m_date,
	h.mlp_change_year+1 AS percent_change_mlp, 
	h.alp_change_year+1 AS percent_change_alp, 
	h.tlc_change_year+1 AS percent_change_tlc, 
	h.mlpsf_change_year+1 AS percent_change_mlpsf,
	h.md_change_year+1 AS percent_change_md,
	ROUND(p.est_2022*1.0)/p.est_2021 AS population_growth,
	ROUND(i.income_2022*1.0)/i.income_2021 AS income_growth
FROM "housing_data" h JOIN "population_data" p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202207'
UNION
SELECT h.cbsa_title, 
	h.cbsa_code,
	h.state, 
	h.region, 
	h.m_date,
	h.mlp_change_year+1 AS percent_change_mlp, 
	h.alp_change_year+1 AS percent_change_alp, 
	h.tlc_change_year+1 AS percent_change_tlc, 
	h.mlpsf_change_year+1 AS percent_change_mlpsf,
	h.md_change_year+1 AS percent_change_md,
	ROUND(p.est_2021*1.0)/p.est_2020 AS population_growth,
	ROUND(i.income_2021*1.0)/i.income_2020 AS income_growth
FROM "housing_data" h JOIN "population_data" p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202107'
UNION
SELECT h.cbsa_title, 
	h.cbsa_code,
	h.state, 
	h.region, 
	h.m_date,
	h.mlp_change_year+1 AS percent_change_mlp, 
	h.alp_change_year+1 AS percent_change_alp, 
	h.tlc_change_year+1 AS percent_change_tlc, 
	h.mlpsf_change_year+1 AS percent_change_mlpsf,
	h.md_change_year+1 AS percent_change_md,
	ROUND(p.est_2020*1.0)/p.est_2019 AS population_growth,
	ROUND(i.income_2020*1.0)/i.income_2019 AS income_growth
FROM "housing_data" h JOIN "population_data" p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202007'
UNION
SELECT h.cbsa_title, 
	h.cbsa_code,
	h.state, 
	h.region, 
	h.m_date,
	h.mlp_change_year+1 AS percent_change_mlp, 
	h.alp_change_year+1 AS percent_change_alp, 
	h.tlc_change_year+1 AS percent_change_tlc, 
	h.mlpsf_change_year+1 AS percent_change_mlpsf,
	h.md_change_year+1 AS percent_change_md,
	ROUND(p.est_2019*1.0)/p.est_2018 AS population_growth,
	ROUND(i.income_2019*1.0)/i.income_2018 AS income_growth
FROM "housing_data" h JOIN "population_data" p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201907'
UNION
SELECT h.cbsa_title, 
	h.cbsa_code,
	h.state, 
	h.region, 
	h.m_date,
	h.mlp_change_year+1 AS percent_change_mlp, 
	h.alp_change_year+1 AS percent_change_alp, 
	h.tlc_change_year+1 AS percent_change_tlc, 
	h.mlpsf_change_year+1 AS percent_change_mlpsf,
	h.md_change_year+1 AS percent_change_md,
	ROUND(p.est_2018*1.0)/p.est_2017 AS population_growth,
	ROUND(i.income_2018*1.0)/i.income_2017 AS income_growth
FROM "housing_data" h JOIN "population_data" p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201807'
UNION
SELECT h.cbsa_title, 
	h.cbsa_code,
	h.state, 
	h.region, 
	h.m_date,
	h.mlp_change_year+1 AS percent_change_mlp, 
	h.alp_change_year+1 AS percent_change_alp, 
	h.tlc_change_year+1 AS percent_change_tlc, 
	h.mlpsf_change_year+1 AS percent_change_mlpsf,
	h.md_change_year+1 AS percent_change_md,
	ROUND(p.est_2017*1.0)/p.est_2016 AS population_growth,
	ROUND(i.income_2017*1.0)/i.income_2016 AS income_growth
FROM "housing_data" h JOIN "population_data" p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201707'
ORDER BY m_date DESC, cbsa_title;

/* Percentage growth of hosuing data columns with income growth from July 2016 to July 2023 */
WITH h_2016 AS (
	SELECT cbsa_title, 
		cbsa_code,
		state, 
		region, 
		median_listing_price AS mlp,
		average_listing_price AS alp,
		total_listing_count AS tlc,
		med_listing_price_per_sq_ft AS mlpsf,
		median_days AS md
	FROM "housing_data"
	WHERE month = '201607'
),

h_2023 AS (
	SELECT cbsa_title,
		cbsa_code,
		state, 
		region, 
		median_listing_price AS mlp,
		average_listing_price AS alp,
		total_listing_count AS tlc,
		med_listing_price_per_sq_ft AS mlpsf,
		median_days AS md
	FROM "housing_data"
	WHERE month = '202307'
)

SELECT h_2023.cbsa_title, 
	h_2023.state, 
	h_2023.region,
	ROUND(100*((h_2023.mlp*1.0)/h_2016.mlp)-100, 2) AS percent_change_mlp,
	ROUND(100*((h_2023.alp*1.0)/h_2016.alp)-100, 2) AS percent_change_alp,
	ROUND(100*((h_2023.tlc*1.0)/h_2016.tlc)-100, 2) AS percent_change_tlc,
	ROUND(100*((h_2023.mlpsf*1.0)/h_2016.mlpsf)-100, 2) AS percent_change_mlpsf,
	ROUND(100*((h_2023.md*1.0)/h_2016.md)-100, 2) AS percent_change_md,
	ROUND(100*((i.income_2023*1.0)/i.income_2016)-100, 2) AS income_growth
FROM h_2023 JOIN h_2016 ON h_2023.cbsa_code = h_2016.cbsa_code 
JOIN "income_data" AS i ON h_2023.cbsa_code = i.cbsa_code
ORDER BY income_growth DESC;

/* Affordability index by metro and year */
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2023,
	ROUND((h.median_listing_price*1.0)/i.income_2023,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202307'
UNION
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2022,
	ROUND((h.median_listing_price*1.0)/i.income_2022,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202207'
UNION
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2021,
	ROUND((h.median_listing_price*1.0)/i.income_2021,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202107'
UNION
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2020,
	ROUND((h.median_listing_price*1.0)/i.income_2020,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202007'
UNION
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2019,
	ROUND((h.median_listing_price*1.0)/i.income_2019,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201907'
UNION
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2018,
	ROUND((h.median_listing_price*1.0)/i.income_2018,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201807'
UNION
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2017,
	ROUND((h.median_listing_price*1.0)/i.income_2017,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201707'
UNION
SELECT h.cbsa_title,
	h.state,
	h.region,
	h.m_date,
	h.median_listing_price,
	i.income_2016,
	ROUND((h.median_listing_price*1.0)/i.income_2016,3) AS affordability_index
FROM "housing_data" h JOIN "income_data" i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201607'
ORDER BY m_date DESC, affordability_index;

/* Affordability Index Growth since 2016 by metro and year */
WITH aff_2016 AS (
	SELECT h.cbsa_title,
		h.cbsa_code,
		(h.median_listing_price*1.0)/i.income_2016 AS ai_2016
	FROM "housing_data" AS h JOIN "income_data" AS i
	ON h.cbsa_code = i.cbsa_code
	WHERE h.month = '201607'
)

SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2023-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '202307'
UNION
SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2022-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '202207'
UNION
SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2021-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '202107'
UNION
SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2020-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '202007'
UNION
SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2019-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '201907'
UNION
SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2018-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '201807'
UNION
SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2017-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '201707'
UNION
SELECT h.cbsa_title,
	h.region,
	h.m_date,
	(h.median_listing_price*1.0)/i.income_2016-a.ai_2016 AS ai_growth
FROM "housing_data" AS h JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
JOIN aff_2016 AS a ON h.cbsa_code = a.cbsa_code
WHERE h.month = '201607'
ORDER BY m_date DESC, ai_growth;

/* Housing data grouped by region */
SELECT region, 
	m_date, 
	AVG(median_listing_price) AS median_listing_price, 
	AVG(average_listing_price) AS average_listing_price, 
	SUM(total_listing_count) AS total_listing_count, 
	AVG(med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(median_days) AS median_days_on_market
FROM "housing_data"
GROUP BY region, m_date
ORDER BY m_date DESC, region;

/* Statistics grouped by region */
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2023) AS population,
	AVG(i.income_2023) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2023) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202307'
GROUP BY h.region, h.m_date
UNION
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2022) AS population,
	AVG(i.income_2022) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2022) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202207'
GROUP BY h.region, h.m_date
UNION
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2021) AS population,
	AVG(i.income_2021) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2021) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202107'
GROUP BY h.region, h.m_date
UNION
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2020) AS population,
	AVG(i.income_2020) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2020) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '202007'
GROUP BY h.region, h.m_date
UNION
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2019) AS population,
	AVG(i.income_2019) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2019) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201907'
GROUP BY h.region, h.m_date
UNION
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2018) AS population,
	AVG(i.income_2018) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2018) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201807'
GROUP BY h.region, h.m_date
UNION
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2017) AS population,
	AVG(i.income_2017) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2017) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201707'
GROUP BY h.region, h.m_date
UNION
SELECT h.region, 
	h.m_date, 
	AVG(h.median_listing_price) AS median_listing_price, 
	AVG(h.average_listing_price) AS average_listing_price, 
	SUM(h.total_listing_count) AS total_listing_count, 
	AVG(h.med_listing_price_per_sq_ft) AS mlp_per_sq_ft, 
	AVG(h.median_days) AS median_days_on_market,
	SUM(p.est_2016) AS population,
	AVG(i.income_2016) AS income,
	AVG((h.median_listing_price*1.0)/i.income_2016) AS affordability_index
FROM "housing_data" AS h JOIN "population_data" AS p ON h.cbsa_code = p.cbsa_code
JOIN "income_data" AS i ON h.cbsa_code = i.cbsa_code
WHERE h.month = '201607'
GROUP BY h.region, h.m_date
ORDER BY m_date DESC, region;