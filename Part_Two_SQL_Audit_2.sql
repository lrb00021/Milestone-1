-- Business Question:
-- Which customer states generate the highest revenue for Olist?

-- Approach:
-- Step 1: Compute total revenue at the order level (to avoid double counting item rows)
-- Step 2: Join orders with customers to attach geographic (state) information
-- Step 3: Aggregate revenue and activity metrics at the state level
-- Step 4: Rank states by total revenue using a window function
