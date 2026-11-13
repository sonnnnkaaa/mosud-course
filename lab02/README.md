# LAB02
|set|cardinality|
|---|-----------|
|A|3799|
|A distinct|2638|
|B|1806|
|B distinct|1356|
|A∪B|3628|
|A∩B|366|
|A−B|2272|
|B−A|990|

Queries with duplicates:
```sql
WITH A_and_B_dup AS (
	SELECT product_id 
	FROM A 
	WHERE EXISTS (SELECT 1 FROM B WHERE B.product_id = A.product_id)
)
SELECT count(*) AS n_rows
FROM A_and_B_dup;
```
```sql
WITH A_union_all_B AS (
	SELECT product_id FROM A 
	UNION ALL
	SELECT product_id FROM B 
)
SELECT count(*) AS n_rows
FROM A_union_all_B;
```