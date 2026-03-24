-- How do product catgeories perform in terms of orders, product variety, revenue and average item value
SELECT
    COALESCE(tr.product_category_name_english, pr.product_category_name) AS category_english,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_item_value
FROM order_items oi
JOIN products pr
    ON oi.product_id = pr.product_id
LEFT JOIN category_translation tr
    ON pr.product_category_name = tr.product_category_name
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY
    COALESCE(tr.product_category_name_english, pr.product_category_name)
ORDER BY total_revenue DESC;
