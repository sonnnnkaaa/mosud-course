-- Основной запрос
-- orders → customers: N:1
-- orders → order_reviews: 1:N
SELECT
    o.order_id,
    c.customer_id,
    r.review_score,
    CASE
        WHEN o.order_status = 'delivered'
             AND o.order_delivered_customer_date IS NOT NULL
             AND o.order_estimated_delivery_date IS NOT NULL
        THEN GREATEST(
            o.order_delivered_customer_date - o.order_estimated_delivery_date,
            INTERVAL '0'
        )
    END AS delay
FROM olist.orders AS o
JOIN olist.customers AS c ON c.customer_id = o.customer_id
JOIN olist.order_reviews AS r ON r.order_id = o.order_id;

-- LEFT JOIN (заказы без отзывов)
-- orders → order_reviews: 1:N
SELECT o.order_id, o.customer_id, r.review_score
FROM olist.orders AS o
LEFT JOIN olist.order_reviews AS r ON r.order_id = o.order_id;

-- Антисоединение (заказы, для которых нет ни одного отзыва)
SELECT o.order_id, o.customer_id
FROM olist.orders AS o
WHERE NOT EXISTS (
    SELECT 1
    FROM olist.order_reviews AS r
    WHERE r.order_id = o.order_id
);

-- Ошибочный подсчёт отзывов для заказов с товарными позициями.
-- orders → order_reviews: 1:N, orders → order_items: 1:N.
-- Отзывы и позиции образуют связь M:N через заказ.
-- Каждый отзыв повторяется для каждой позиции. Два отзыва и три позиции дают COUNT(*) = 6.
SELECT o.order_id, COUNT(*) AS review_count
FROM olist.orders AS o
JOIN olist.order_reviews AS r ON r.order_id = o.order_id
JOIN olist.order_items AS i ON i.order_id = o.order_id
GROUP BY o.order_id;

-- Агрегация позиций даёт одну строку на заказ с товарными позициями.
-- orders → items_by_order: 1:1 среди совпавших строк, orders → order_reviews: 1:N.
-- Для тех же двух отзывов и трёх позиций COUNT(*) = 2.
WITH items_by_order AS (
    SELECT order_id
    FROM olist.order_items
    GROUP BY order_id
)
SELECT o.order_id, COUNT(*) AS review_count
FROM olist.orders AS o
JOIN olist.order_reviews AS r ON r.order_id = o.order_id
JOIN items_by_order AS i ON i.order_id = o.order_id
GROUP BY o.order_id;
