-- Множество A в виде материализованного представления
CREATE MATERIALIZED VIEW IF NOT EXISTS A AS
SELECT oi.product_id
FROM olist.orders o
JOIN olist.order_items oi
USING (order_id)
JOIN olist.customers c
USING (customer_id)
WHERE c.customer_state = 'BA';

-- Множество B в виде материализованного представления
CREATE MATERIALIZED VIEW IF NOT EXISTS B AS
SELECT oi.product_id
FROM olist.orders o
JOIN olist.order_items oi
USING (order_id)
JOIN olist.customers c
USING (customer_id)
WHERE c.customer_state = 'PE';

-- Число строк и число уникальных строк в A
SELECT 
	count(*) AS n_rows,
	count(DISTINCT product_id) "n_distinct"
FROM A;

-- Число строк и число уникальных строк в B
SELECT 
	count(*) AS n_rows,
	count(DISTINCT(product_id)) "n_distinct"
FROM B;

-- Проверка коммутативности A ∪ B, число строк 
WITH A_union_B AS (
	SELECT product_id FROM A 
	UNION 
	SELECT product_id FROM B 
),
B_union_A AS (
	SELECT product_id FROM B 
	UNION 
	SELECT product_id FROM A 
)
SELECT (
	SELECT count(*) FROM (
		SELECT product_id FROM A_union_B EXCEPT SELECT product_id FROM B_union_A
		UNION ALL
		SELECT product_id FROM B_union_A EXCEPT SELECT product_id FROM A_union_B)
) = 0 AS is_commutative,
	(SELECT count(*) FROM A_union_B) AS A_u_B_nrows,
	(SELECT count(*) FROM B_union_A) AS B_u_A_nrows;

-- Число строк в A ∪ B (UNION ALL)
-- мультимножество
WITH A_union_all_B AS (
	SELECT product_id FROM A 
	UNION ALL
	SELECT product_id FROM B 
)
SELECT count(*) AS n_rows
FROM A_union_all_B;

-- Проверка коммутативности A ∩ B, число строк
WITH A_intersect_B AS (
	SELECT product_id FROM A 
	INTERSECT
	SELECT product_id FROM B
),
B_intersect_A AS (
	SELECT product_id FROM B 
	INTERSECT
	SELECT product_id FROM A	
)
SELECT (
	SELECT count(*) FROM (
		SELECT product_id FROM A_intersect_B EXCEPT SELECT product_id FROM B_intersect_A
		UNION ALL
		SELECT product_id FROM B_intersect_A EXCEPT SELECT product_id FROM A_intersect_B)
) = 0 AS is_commutative,
	(SELECT count(*) FROM A_intersect_B) AS A_i_B_nrows,
	(SELECT count(*) FROM B_intersect_A) AS B_i_A_nrows;

-- Проверка коммутативности A - B, число строк
WITH A_except_B AS (
	SELECT product_id FROM A 
	EXCEPT 
	SELECT product_id FROM B
),
B_except_A AS (
	SELECT product_id FROM B 
	EXCEPT 
	SELECT product_id FROM A
)
SELECT (
	SELECT count(*) FROM (
		SELECT product_id FROM A_except_B EXCEPT SELECT product_id FROM B_except_A
		UNION ALL
		SELECT product_id FROM B_except_A EXCEPT SELECT product_id FROM A_except_B)	
) = 0 AS is_commutative,
	(SELECT count(*) FROM A_except_B) AS A_e_B_nrows,
	(SELECT count(*) FROM B_except_A) AS B_e_A_nrows;

-- Пересечение через EXISTS
SELECT DISTINCT product_id 
FROM A 
WHERE EXISTS (SELECT 1 FROM B WHERE B.product_id = A.product_id);

-- Проверка кол-ва строк
WITH A_and_B AS (
	SELECT DISTINCT product_id 
	FROM A 
	WHERE EXISTS (SELECT 1 FROM B WHERE B.product_id = A.product_id)
)
SELECT count(*) AS n_rows
FROM A_and_B;

-- Пересечение через EXISTS без DISTINCT
-- мультимножество
WITH A_and_B_dup AS (
	SELECT product_id 
	FROM A 
	WHERE EXISTS (SELECT 1 FROM B WHERE B.product_id = A.product_id)
)
SELECT count(*) AS n_rows
FROM A_and_B_dup;