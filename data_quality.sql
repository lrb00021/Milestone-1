WITH table_row_counts AS (
  -- Document row counts per table in the database
  Select  'orders' AS table_name, COUNT(*) AS row_count from orders
  union all
  Select  'products' AS table_name, COUNT(*) AS row_count from products
  union all
  Select  'sellers' AS table_name, COUNT(*) AS row_count from sellers
  union all
  Select  'order_reviews' AS table_name, COUNT(*) AS row_count from order_reviews
  union all
  Select  'order_payments' AS table_name, COUNT(*) AS row_count from order_payments
  union all
  Select  'order_items' AS table_name, COUNT(*) AS row_count from order_items
  union all
  Select  'geolocation' AS table_name, COUNT(*) AS row_count from geolocation
  union all
  Select  'customers' AS table_name, COUNT(*) AS row_count from customers
  union all
  Select  'category_translation' AS table_name, COUNT(*) AS row_count from category_translation
),

null_rates AS (
--NULL rates for key columns
select 'orders' as table_name,
sum(case when order_id is null then 1 else 0 end)/ count(*) as null_rate
from orders
UNION ALL
select 'customers' as table_name,
sum(case when customer_id is null then 1 else 0 end)/ count(*) as null_rate
from customers
UNION ALL
select 'products' as table_name,
sum(case when product_id is null then 1 else 0 end)/ count(*) as null_rate
from products
UNION ALL
select 'sellers' as table_name,
sum(case when seller_id is null then 1 else 0 end)/ count(*) as null_rate
from sellers
),

orphaned_records AS (
 --Counts customer_ids that dont match on orders and customers table
    SELECT
        'orders_without_customers' AS anomoaly_type,
        COUNT(*) AS anomaly_count
    FROM orders AS o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
),

date_coverage_and_gaps AS(
--Getting date start and end, range, distinct days, all possible days, and gap days
    SELECT
        MIN(order_purchase_timestamp) AS start_date,
        MAX(order_purchase_timestamp) AS end_date,
        COUNT(DISTINCT DATE(order_purchase_timestamp)) AS active_days,
        DATE(MAX(order_purchase_timestamp)) - DATE(MIN(order_purchase_timestamp)) + 1 AS total_possible_days,
        total_possible_days - active_days AS gap_days
     FROM orders
),
