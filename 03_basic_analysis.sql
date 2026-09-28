-- basic analysis

-- 1. How many customers are registered on the platform?
select count(*) as total_customers from customers;

-- 2. How many customers are currently active?
select count(*) as active_customers from customers
 where customer_status = 'active';
 
 -- 3. How many customers are there in each state?
select state, count(*) as total_customers from customers
 group by state 
 order by total_customers desc;
 
-- 4. How many customers are there in each city?
select city, count(*) as total_customers from customers
 group by city 
 order by total_customers desc;
 
 -- 5. How many male and female customers are registered?
select gender, count(*) as total_customers from customers  group by gender;

-- 6. How many products are available in each category?
select category, count(*) as total_products from products
 group by category order by total_products desc;
 
 -- 7. What is the average price of products in each category?
 select category, round(avg(unit_price), 2) as average_price from products 
 group by category order by average_price desc;
 
 -- 8. Which are the 10 most expensive products currently listed?
 select product_id, product_name, category, unit_price from products 
 order by unit_price desc
 limit 10;
 
 -- 9. Which products currently have stock below their reorder level?
 select product_id, product_name, category, stock_quantity, reorder_level from products 
 where stock_quantity < reorder_level;
 
 -- 10. How many products are currently active, inactive?
 select product_status, count(*) as total_products from products group by product_status;
 
-- 11. How many orders have been placed in total?
select count(*) as total_orders from orders;

--  12. How many orders are there for each order status?
 select order_status, count(*) as total_orders from orders group by order_status;
 
 -- 13. What is the total revenue generated from all orders?
 select round(sum(total_amount), 2) as total_revenue from orders;

-- 14. What is the average order value? 
 select  round(avg(total_amount), 2) as average_order_value from orders;
 
 -- 15. What is the highest-value order placed?
select customer_id, order_id, order_date, total_amount from orders
order by total_amount desc
limit 1;

-- 16. How many orders were placed in each year?
select 
     year(order_date) as order_year,
     count(order_id) as total_orders from orders
group by year(order_date)
order by order_year;

-- 17. How much revenue was generated in each year?
select 
	year(order_date) as order_year,
    round(sum(total_amount), 2) as total_revenue from orders
group by year(order_date)
order by order_year; 

-- 18. How many payments were made using each payment method?
select payment_method, count(*) as total_payments_method from payments 
 group by payment_method order by total_payments_method desc;
 
 -- 19. How much money was collected through each payment method?
select payment_method, round(sum(amount_paid), 2) as total_amount_collected from payments
 group by payment_method;
 
--  20. How many payments were successful and how many failed?
select payment_status, count(payment_id) as total_payments from payments group by payment_status;
