-- Business Question:
-- Which customer states generate the highest revenue for Olist?

-- Approach:
-- Step 1: Compute total revenue at the order level (to avoid double counting item rows)
-- Step 2: Join orders with customers to attach geographic (state) information
-- Step 3: Aggregate revenue and activity metrics at the state level
-- Step 4: Rank states by total revenue using a window function

WITH order_revenue AS (
    -- Step 1:
    -- Each order can have multiple items, so we first calculate total revenue per order
    SELECT
        oi.order_id,
        SUM(oi.price + oi.freight_value) AS order_revenue
    FROM order_items oi
    GROUP BY oi.order_id
),
delivered_orders_with_state AS (
    -- Step 2:
    -- Join orders with customers to get customer location (state)
    -- Also attach the computed order-level revenue
    -- Filter only delivered orders to reflect completed transactions
    SELECT
        o.order_id,
        c.customer_id,
        c.customer_unique_id,
        c.customer_state,
        orv.order_revenue
    FROM orders o
    JOIN customers c
        ON o.customer_id = c.customer_id
    JOIN order_revenue orv
        ON o.order_id = orv.order_id
    WHERE o.order_status = 'delivered'
),
