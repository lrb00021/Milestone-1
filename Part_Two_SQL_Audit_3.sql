-- Products categories with a payment value above the overall average
SELECT
    p.product_category_name,
    p.product_id,
    o.order_id,
    op.payment_value
FROM products AS p
INNER JOIN order_items AS o on o.product_id = p.product_id
INNER JOIN order_payments AS op ON op.order_id = o.order_id
-- Filtering payment values higher than the average payment value
WHERE payment_value > (
    SELECT AVG(payment_value) FROM order_payments
)
-- Showing the highest payment values first
ORDER BY payment_value DESC;
