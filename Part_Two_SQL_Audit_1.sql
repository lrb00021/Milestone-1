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
