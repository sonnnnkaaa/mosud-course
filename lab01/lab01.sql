-- Вывод количества строк каждой таблицы
SELECT 'customers' AS table_name, count(*) AS num_rows FROM olist.customers
UNION ALL SELECT 'geolocation', count(*) FROM olist.geolocation
UNION ALL SELECT 'order_items', count(*) FROM olist.order_items
UNION ALL SELECT 'order_payments', count(*) FROM olist.order_payments
UNION ALL SELECT 'order_reviews', count(*) FROM olist.order_reviews
UNION ALL SELECT 'orders', count(*) FROM olist.orders
UNION ALL SELECT 'product_category_name_translation', count(*) FROM olist.product_category_name_translation
UNION ALL SELECT 'products', count(*) FROM olist.products
UNION ALL SELECT 'sellers', count(*) FROM olist.sellers
ORDER BY num_rows DESC;

-- Проверка различных полей на NULL
SELECT 'customers_without_unique_id' AS column_check, count(*) AS num_rows
FROM olist.customers c 
WHERE c.customer_unique_id IS NULL
UNION ALL 
SELECT 'orders_without_status', count(*)
FROM olist.orders o
WHERE o.order_status IS NULL
UNION ALL 
SELECT 'items_without_price', count(*)
FROM olist.order_items oi 
WHERE oi.price IS NULL
UNION ALL 
SELECT 'payments_without_type', count(*)
FROM olist.order_payments op 
WHERE op.payment_type IS NULL 
UNION ALL 
SELECT 'payments_without_value', count(*)
FROM olist.order_payments op 
WHERE op.payment_value IS NULL 
UNION ALL
SELECT 'reviews_without_score', count(*)
FROM olist.order_reviews orr
WHERE orr.review_score IS NULL
UNION ALL
SELECT 'products_without_category', count(*)
FROM olist.products p 
WHERE p.product_category_name IS NULL;

-- Проверка "осиротевших" ссылок
SELECT 'orders_without_customer_id' AS link, count(*) AS num_rows
FROM olist.orders o
LEFT JOIN olist.customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL
UNION ALL
SELECT 'items_without_order_id', count(*)
FROM olist.order_items oi 
LEFT JOIN olist.orders o ON oi.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'items_without_product_id', count(*)
FROM olist.order_items oi
LEFT JOIN olist.products p ON oi.product_id = p.product_id
WHERE p.product_id IS NULL
UNION ALL
SELECT 'items_without_seller_id', count(*)
FROM olist.order_items oi
LEFT JOIN olist.sellers s ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL
UNION ALL
SELECT 'payments_without_order_id', count(*)
FROM olist.order_payments op
LEFT JOIN olist.orders o ON op.order_id = o.order_id
WHERE o.order_id IS NULL
UNION ALL
SELECT 'reviews_without_order_id', count(*)
FROM olist.order_reviews orr
LEFT JOIN olist.orders o ON orr.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ANALYZE схемы olist
ANALYZE 
	olist.customers,
	olist.geolocation,
	olist.order_items,
	olist.order_payments,
	olist.order_reviews,
	olist.orders,
	olist.product_category_name_translation,
	olist.products,
	olist.sellers;
