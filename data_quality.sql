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
