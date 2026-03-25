# Milestone-1
# Data Quality Audit - Part 1

## Overview
This SQL script performs a foundational data quality assessment on an e-commerce database. It uses a series of Common Table Expressions (CTEs) to evaluate the completeness, uniqueness, referential integrity, and validity of the core datasets. 

## Database Context
This script is designed for a relational e-commerce database containing the following core tables:
* `orders`
* `products`
* `sellers`
* `order_reviews`
* `order_payments`
* `order_items`
* `geolocation`
* `customers`
* `category_translation`

## Code Structure and Breakdown
The script is organized into several CTEs, each serving a specific data quality auditing function:

* **`table_row_counts`**: 
  * **Purpose**: Measures dataset volume.
  * **Action**: Returns the total row count for nine core tables in the database to ensure data is populated and tracking as expected.

* **`null_rates`**: 
  * **Purpose**: Checks data completeness.
  * **Action**: Calculates the percentage of `NULL` values in primary key columns across the `orders`, `customers`, `products`, and `sellers` tables. 

* **`orphaned_records`**: 
  * **Purpose**: Validates referential integrity.
  * **Action**: Uses a `LEFT JOIN` to identify any records in the `orders` table that do not have a corresponding, valid `customer_id` in the `customers` table.

* **`date_coverage_and_gaps`**: 
  * **Purpose**: Assesses time-series validity and continuity.
  * **Action**: Analyzes `order_purchase_timestamp` to determine the start date, end date, total active days, total possible days in the range, and the number of "gap days" (days where no orders were placed).

* **`duplicate_orders` & `duplicate_customers`**: 
  * **Purpose**: Checks data uniqueness.
  * **Action**: Groups by the primary keys (`order_id` and `customer_id`) to flag any IDs that appear more than once.

## Final Output
  * Combines all CTEs into a readable final table
  * Displays all of our metric values, metric names, and audit categories

# Data Quality Audit - Part 2

## 1st SQL Query

## Overview
This SQL script identifies the most popular product category within the highest-performing cities. It first determines the top 10 cities by overall order volume, and then isolates the number-one selling product category for each of those specific locations.

## Database Context
This script queries an e-commerce database, utilizing standard joins across the following tables to link customer locations to specific product categories:
* `orders`
* `customers`
* `order_items`
* `products`

## Code Structure and Breakdown
The query is organized into a sequential pipeline using Common Table Expressions (CTEs):

* **`city_order_counts`**: 
  * **Purpose**: Calculates total order volume for every city.
  * **Action**: Joins `orders` to `customers` and groups by `customer_city` to get a raw count of `order_id`s.

* **`top_cities`**: 
  * **Purpose**: Isolates the highest-performing locations.
  * **Action**: Queries the previous CTE and applies a `LIMIT 10` to get just the top 10 cities by total orders.

* **`city_category_orders`**: 
  * **Purpose**: Aggregates product category performance strictly within the target cities.
  * **Action**: Joins the core tables together. It uses a `WHERE IN` clause to filter only for the top 10 cities, then counts the number of times each `product_category_name` was ordered per city.

* **`ranked_categories`**: 
  * **Purpose**: Ranks the categories within each city based on popularity.
  * **Action**: Utilizes the `RANK()` window function—partitioning the data by `customer_city` and ordering by `category_orders` descending—to assign a sequential ranking to the categories.

## Final Output
The final `SELECT` statement acts as a filter on the `ranked_categories` CTE. By filtering `WHERE category_rank = 1`, the query outputs a final table showing the `customer_city`, the winning `product_category_name`, and the total `category_orders` for that top item.

## 2nd SQL Query

## Overview
This SQL script determines which customer states generate the highest revenue for the Olist platform. It calculates the total revenue per order, links those orders to geographic customer data, aggregates the financial metrics by state, and assigns a rank based on total revenue. 

## Database Context
This script queries the Olist e-commerce database, utilizing joins across the following tables to link financial performance to customer locations:
* `order_items`
* `orders`
* `customers`

## Code Structure and Breakdown
The query is organized into a sequential pipeline using Common Table Expressions (CTEs) to ensure accurate aggregation and avoid double-counting:

* **`order_revenue`**: 
  * **Purpose**: Calculates the true total revenue for each individual order.
  * **Action**: Sums the `price` and `freight_value` from the `order_items` table and groups by `order_id`. This prevents row-duplication issues when an order contains multiple items.

* **`delivered_orders_with_state`**: 
  * **Purpose**: Links revenue to geography and filters for completed transactions.
  * **Action**: Joins the `orders` table to `customers` (to get `customer_state`) and to the `order_revenue` CTE. Critically, it applies a `WHERE order_status = 'delivered'` filter so that only finalized, successful sales are counted toward state revenue.

* **`state_summary`**: 
  * **Purpose**: Aggregates the core business metrics at the state level.
  * **Action**: Groups the data by `customer_state` and calculates the total number of unique orders, total unique customers, total combined revenue, and the Average Order Value (AOV).

* **`ranked_states`**: 
  * **Purpose**: Establishes a leaderboard of states by revenue.
  * **Action**: Utilizes the `RANK()` window function—ordering by `total_revenue` descending—to assign a competitive rank to each state.

## Final Output
The final `SELECT` statement pulls from the `ranked_states` CTE. It cleans up the presentation by rounding the financial metrics (`total_revenue` and `avg_order_revenue`) to two decimal places and ordering the final dataset by the revenue rank and state name.

## 3rd SQL Query

## Overview
This SQL script identifies individual product sales that exceed the global average payment value. By isolating high-value transactions, this query helps highlight premium products, bulk orders, or categories that drive the largest individual payments within the e-commerce platform.

## Database Context
This script relies on joining three core tables to link product details with financial transaction data:
* `products`
* `order_items`
* `order_payments`

## Code Structure and Breakdown
Unlike previous scripts that heavily utilized Common Table Expressions (CTEs), this query uses a more direct approach with an inline subquery:

* **The Core Joins (`SELECT` & `FROM`)**: 
  * **Purpose**: Gathers the necessary descriptive and financial data.
  * **Action**: Starts with the `products` table, joins to `order_items` to find when those products were actually purchased, and finally joins to `order_payments` to retrieve the exact `payment_value` associated with those specific orders.

* **The Filter (`WHERE` clause)**: 
  * **Purpose**: Isolates the above-average transactions.
  * **Action**: Utilizes a scalar subquery `(SELECT AVG(payment_value) FROM order_payments)` to dynamically calculate the overall average payment across the entire database. It then filters the main query to only return rows where the individual `payment_value` is strictly greater than this global average.

* **The Sort (`ORDER BY` clause)**: 
  * **Purpose**: Highlights the most significant transactions first.
  * **Action**: Sorts the filtered results in descending order by `payment_value`, placing the absolute highest payments at the very top of the output.

## 4th SQL Query

## Overview
This SQL script evaluates the overall business performance of different product categories on the e-commerce platform. It aggregates key metrics—including total order volume, product variety, total revenue, and average item value—and translates category names into English for standardized reporting.

## Database Context
This script links transactional data with product catalog and translation tables to provide a comprehensive view of category performance. It utilizes the following tables:
* `order_items`
* `products`
* `category_translation`
* `orders`

## Code Structure and Breakdown
This query leverages aggregate functions and precise join logic to build a category-level summary:

* **The Core Metrics (`SELECT` clause)**: 
  * **Naming**: Uses `COALESCE(tr.product_category_name_english, pr.product_category_name)` to display the English translation of the category if available, and defaults to the original Portuguese name if a translation is missing.
  * **Volume & Variety**: Calculates `total_orders` by counting distinct `order_id`s and measures product variety (`unique_products`) by counting distinct `product_id`s within each category.
  * **Financials**: Computes `total_revenue` and `avg_order_item_value` by adding the `price` and `freight_value` for each item, rounding the results to two decimal places for clean financial reporting.

* **The Joins (`FROM` & `JOIN` clauses)**: 
  * **Action**: Starts with `order_items` as the base table for item-level financials. It uses an `INNER JOIN` to `products` to get category names, and an `INNER JOIN` to `orders` to check the order status. 
  * **Translation**: Crucially, it uses a `LEFT JOIN` to the `category_translation` table. This ensures that even if a product category hasn't been mapped to an English translation yet, the sales data isn't accidentally dropped from the final report.

* **The Filter (`WHERE` clause)**: 
  * **Purpose**: Ensures revenue isn't artificially inflated by canceled or unfulfilled orders.
  * **Action**: Filters `WHERE o.order_status = 'delivered'`, ensuring only completed, successful transactions are included in the performance metrics.

* **The Grouping & Sorting (`GROUP BY` & `ORDER BY` clauses)**: 
  * **Action**: Groups all the calculated metrics by the standardized category name. Finally, it sorts the output by `total_revenue DESC`, placing the highest-grossing product categories at the very top of the report.
