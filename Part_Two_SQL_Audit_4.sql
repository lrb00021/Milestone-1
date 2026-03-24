-- How do product catgeories perform in terms of orders, product variety, revenue and average item value
SELECT
    COALESCE(tr.product_category_name_english, pr.product_category_name) AS category_english,
    COUNT(DISTINCT oi.order_id) AS total_orders,
    COUNT(DISTINCT oi.product_id) AS unique_products,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_item_value
