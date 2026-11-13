-- Выражение в виде материализованного представления
CREATE MATERIALIZED VIEW IF NOT EXISTS lab03 AS
SELECT 
	customer_unique_id,
	customer_city AS city,
	customer_state AS state
FROM olist.customers
WHERE customer_state IN ('SP', 'RJ', 'MG') 
AND customer_city IS NOT NULL;

-- Разбиение на 2 выборки и проверка на эквивалентность 
WITH sample_1 AS (
	SELECT
		customer_unique_id,
		customer_city AS city,
		customer_state AS state
	FROM olist.customers
	WHERE customer_state IN ('SP', 'RJ', 'MG')
),
sample_2 AS (
	SELECT
		customer_unique_id,
		customer_city AS city,
		customer_state AS state
	FROM olist.customers
	WHERE customer_city IS NOT NULL 
)
SELECT (
	SELECT count(*) FROM (
		SELECT * FROM sample_1 INTERSECT SELECT * FROM sample_2 
		EXCEPT 
		SELECT * FROM olist.lab03
	)
) = 0 AS is_equivalent;

-- Раннее исключение ненужных столбцов
SELECT * 
FROM (
	SELECT 
		customer_unique_id,
		customer_city AS city,
		customer_state AS state
	FROM olist.customers
)
WHERE state IN ('SP', 'RJ', 'MG') 
AND city IS NOT NULL;

SELECT 
	'without distinct customer_unique_id' AS query, 
	count(*) AS n_rows 
FROM olist.lab03
UNION ALL 
SELECT 
	'with distinct customer_unique_id',
	count(DISTINCT customer_unique_id)
FROM olist.lab03;
