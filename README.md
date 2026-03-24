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

## Current Output
Currently, the final `SELECT` statement at the bottom of the script outputs the results from the uniqueness checks:
1. Total count of duplicate `order_id`s.
2. Total count of duplicate `customer_id`s.
