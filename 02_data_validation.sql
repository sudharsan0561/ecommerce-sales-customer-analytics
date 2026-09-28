-- data_validation
       
-- checking row counts;

select 'customers' as table_name, count(*) as 'total_rows' from customers  
union all
select 'products', count(*) from products 
union all
select 'orders', count(*) from orders 
union all
select 'order_items', count(*) from order_items 
union all
select 'payments', count(*) from payments;

-- checking duplicates

SELECT
    SUM(customer_id IS NULL) AS customer_id_nulls,
    SUM(first_name IS NULL) AS first_name_nulls,
    SUM(last_name IS NULL) AS last_name_nulls,
    SUM(email IS NULL) AS email_nulls,
    SUM(gender IS NULL) AS gender_nulls,
    SUM(city IS NULL) AS city_nulls,
    SUM(state IS NULL) AS state_nulls,
    SUM(country IS NULL) AS country_nulls
FROM customers;

select customer_id, count(*) as duplicate_count from customers
group by customer_id
having count(*) > 1;

select product_id, count(*) as duplicate_count from products
group by product_id
having count(*) > 1;

select order_id, count(*) as duplicate_count from orders
group by order_id
having count(*) > 1;

select order_item_id, count(*) as duplicate_count from order_items
group by order_item_id
having count(*) > 1;

select payment_id, count(*) as duplicate_count from payments
group by payment_id
having count(*) > 1;

select email , count(*) as duplicate_count from customers
group by email
having count(*) > 1;

-- checking null values

select
      count(*) as total_rows,
      count(customer_id) as customer_id_present,
      count(*) - count(customer_id) as customer_id_missing from customers;
      
select
	count(*) as total_rows,
	count(product_id) as product_id_present,
	count(*) - count(product_id) as product_id_missing from products;
    
select
	count(*) as total_rows,
	count(order_id) as order_id_present,
	count(*) - count(order_id) as order_id_missing from orders;
    
select
	count(*) as total_rows,
	count(order_item_id) as order_item_id_present,
	count(*) - count(order_item_id) as order_item_id_missing from order_items;
    
    select
	count(*) as total_rows,
	count(payment_id) as payment_id_present,
	count(*) - count(payment_id) as payment_id_missing from payments;
    
-- checking broken relationship between tables / orphan record check

select
	count(*) as total_rows,
	count(customer_id) as customer_id_present,
	count(*) - count(customer_id) as customer_id_missing from orders;

select o.order_id, o.customer_id from orders o
left join customers c
  on o.customer_id = c.customer_id
where c.customer_id is null;

select oi.order_item_id, oi.order_id from order_items oi
left join orders o
   on oi.order_id = o.order_id
where o.order_id is null;

select oi.order_item_id, oi.order_id from order_items oi
left join products p
   on oi.product_id = p.product_id
where p.product_id is null;

 select
	count(*) as total_rows,
	count(order_id) as order_id_present,
	count(*) - count(order_id) as order_id_missing from payments;
    
select p.payment_id, p.order_id from payments p 
left join orders o
   on p.order_id = o.order_id
where o.order_id is null;

-- Check invalid/negative prices and amounts
-- check product prices

SELECT *
FROM products
WHERE unit_price < 0
   OR stock_quantity < 0
   OR reorder_level < 0;
SELECT *
FROM order_items
WHERE quantity <= 0
   OR unit_price < 0
   OR discount_amount < 0
   OR item_total < 0;
SELECT *
FROM orders
WHERE total_amount < 0;

-- Check available categories/statuses

select distinct category from products;
select distinct order_status from orders;
select distinct payment_method from payments;
select distinct payment_status from payments;

-- Check invalid dates

select 
     min(order_date) as earliest_date,
     max(order_date) as latest_date
from orders;