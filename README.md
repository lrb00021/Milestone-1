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
