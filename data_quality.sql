-- Part 1 of Data Quality Audit
WITH table_row_counts AS (
  --CTE of Document row counts per table in the database
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
sum(case when order_id is null then 1 else 0 end) * 1.0/ count(*) as null_rate
from orders
UNION ALL
select 'customers' as table_name,
sum(case when customer_id is null then 1 else 0 end) * 1.0/ count(*) as null_rate
from customers
UNION ALL
select 'products' as table_name,
sum(case when product_id is null then 1 else 0 end) * 1.0/ count(*) as null_rate
from products
UNION ALL
select 'sellers' as table_name,
sum(case when seller_id is null then 1 else 0 end) * 1.0/ count(*) as null_rate
from sellers
),

orphaned_records AS (
 --CTE of Counts customer_ids that dont match on orders and customers table
    SELECT
        'orders_without_customers' AS anomaly_type,
        COUNT(*) AS anomaly_count
    FROM orders AS o
    LEFT JOIN customers c ON o.customer_id = c.customer_id
    WHERE c.customer_id IS NULL
),

date_coverage_and_gaps AS(
--CTE of Getting date start and end, range, distinct days, all possible days, and gap days
    SELECT
        MIN(order_purchase_timestamp) AS start_date,
        MAX(order_purchase_timestamp) AS end_date,
        COUNT(DISTINCT DATE(order_purchase_timestamp)) AS active_days,
        -- +1 for inclusive counting of total possible days
        DATE(MAX(order_purchase_timestamp)) - DATE(MIN(order_purchase_timestamp)) + 1 AS total_possible_days,
        total_possible_days - active_days AS gap_days
     FROM orders
),
duplicate_orders AS (
    --Duplicate orders CTE
    SELECT order_id, COUNT(*) AS cnt
    FROM orders
    GROUP BY order_id
    HAVING COUNT(*) > 1
),
duplicate_customers AS (
    --Duplicate Customers CTE
    SELECT customer_id, COUNT(*) AS cnt
    FROM customers
    GROUP BY customer_id
    HAVING COUNT(*) > 1
)

-- Combining all the CTEs into one readable table
-- Union all each CTE and rename columns into audit category, metric name, and metric value


-- Table Row Counts output
SELECT
    'Row Counts' AS audit_category,
    table_name AS metric_name,
    row_count AS metric_value
FROM table_row_counts

UNION ALL

-- Null Rates output
SELECT
    'Primary Key Null Rates' AS audit_category,
    table_name AS metric_name,
    null_rate AS metric_value
FROM null_rates

UNION ALL

-- Orphaned Records output
SELECT
    'Orphaned Records' AS audit_category,
    anomaly_type AS metric_name,
    anomaly_count AS metric_value
FROM orphaned_records

UNION ALL

-- Date Coverage (Unpivoted for the final output format)
-- Use cast VARCHAR to keep data as is from the CTE (If not an error occurs)
SELECT 'Date Coverage' AS audit_category, 'Start Date' AS metric_name, CAST(start_date AS VARCHAR) FROM date_coverage_and_gaps AS metric_value
UNION ALL
SELECT 'Date Coverage' AS audit_category, 'End Date' AS metric_name, CAST(end_date AS VARCHAR) FROM date_coverage_and_gaps AS metric_value
UNION ALL
SELECT 'Date Coverage' AS audit_category, 'Active Days' AS metric_name, CAST(active_days AS VARCHAR) FROM date_coverage_and_gaps AS metric_value
UNION ALL
SELECT 'Date Coverage' AS audit_category, 'Total Possible Days' AS metric_name, CAST(total_possible_days AS VARCHAR) FROM date_coverage_and_gaps AS metric_value
UNION ALL
SELECT 'Date Coverage' AS audit_category, 'Gap Days' AS metric_name, CAST(gap_days AS VARCHAR) FROM date_coverage_and_gaps AS metric_value

UNION ALL

-- Duplicates output
SELECT
    'Duplicates' AS audit_category,
    'Duplicate Orders Count' AS metric_name,
    CAST(COUNT(*) AS VARCHAR) AS metric_value
FROM duplicate_orders

UNION ALL

SELECT
    'Duplicates' AS audit_category,
    'Duplicate Customers Count' AS metric_name,
    CAST(COUNT(*) AS VARCHAR) AS metric_value
FROM duplicate_customers;
