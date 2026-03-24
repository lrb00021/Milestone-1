-- Which product categories are most popular with our top cities
With city_order_counts AS(
-- Step 1: Total orders per city
select c.customer_city,
count(o.order_id) as total_orders
from orders o
inner join customers as c on o.customer_id = c.customer_id
group by c.customer_city
order by total_orders desc
),
top_cities as(
-- Step 2: Select top 10 cities by total orders
select customer_city
from city_order_counts
order by total_orders desc
limit 10
),
city_category_orders as (
-- Step 3: Count orders per category in top cities
select
c.customer_city,
p.product_category_name,
count(oi.order_id) as category_orders
from orders o
inner join customers as c on o.customer_id = c.customer_id
inner join order_items as oi on oi.order_id =o.order_id
inner join products as p on oi.product_id = p.product_id
where c.customer_city in (select customer_city from top_cities)
group by c.customer_city, p.product_category_name
),
ranked_categories as (
--step 4: Rank categories per city by number of orders
Select
customer_city,
product_category_name,
category_orders,
rank() over (partition by customer_city order by category_orders desc) as category_rank
from city_category_orders
)
--Step 5: Show top categories per city
select
customer_city,
product_category_name,
category_orders
from ranked_categories
where category_rank = 1
order by category_orders desc, customer_city;
