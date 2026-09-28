-- advance level 

-- 1.  Rank customers based on their total spending, with the highest spender receiving rank 1?
select c.customer_id, concat(c.first_name," ", c.last_name) as customer_name, sum(o.total_amount) as total_spending, 
 rank() over(order by sum(O.total_amount) desc) as spending_rank
 from customers c
join orders o  
on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name
order by spending_rank;

-- 2.  Identify customers who have placed more than one order and calculate their number of orders, total spending, and average order value.

select c.customer_id, concat(c.first_name," ", c.last_name) as customer_name, count(o.order_id) as total_orders,  
sum(o.total_amount) as total_spending, avg(o.total_amount) as average_order_value from customers c
join orders o
on c.customer_id = o.customer_id
group by c.customer_id, c.first_name, c.last_name
having count(o.order_id) > 1
order by total_spending desc;

-- 3. Find customers whose total spending is higher than the average customer spending.
with customer_spending as (
select c.customer_id, concat(c.first_name," ", c.last_name) as customer_name,   
sum(o.total_amount) as total_spending from customers c
join orders o
 on c.customer_id = o.customer_id
 group by c.customer_id, c.first_name, c.last_name )
   select customer_id, customer_name, round(total_spending, 2) as total_spending from customer_spending
   where total_spending > ( select avg(total_spending) from customer_spending )
   order by total_spending desc;
   
-- 4.  Classify customers into High Value, Medium Value, and Low Value based on their total spending
 with customer_spending as (
   select c.customer_id, concat(c.first_name, " ", c.last_name) as customer_name, sum(o.total_amount) as total_spending from customers c
   join orders o
     on c.customer_id = o.customer_id
	group by c.customer_id, c.first_name, c.last_name )
    select
           customer_id, customer_name, total_spending,
		case
            when total_spending >= 30000 then 'high value'
            when total_spending >= 15000 then 'medium value'
            else 'low value'
		end as customer_segments
from customer_spending
order by total_spending desc;

-- 5.  For every customer, rank their orders from highest-value order to lowest-value order.
select o.customer_id, o.order_id, o.order_date, o.total_amount,
       rank() over( partition by  o.customer_id 
					order by o.total_amount desc) as order_rank from orders o
order by customer_id, order_rank;
              
-- 6.  Within each category, rank products based on their total revenue
with product_revenue as ( 
					select p.product_id, p.product_name, p.category, sum(oi.item_total) as total_revenue from products p 
                    join order_items oi
                     on p.product_id = oi.product_id
                     group by p.product_id, p.product_name, p.category)
			select product_id, product_name, category, round(total_revenue, 2) as total_revenue,
				  rank() over( partition by category 
                               order by total_revenue desc) as category_rank
from product_revenue
order by category, category_rank;         

-- 7. Calculate each product category's revenue, total revenue, and percentage contribution
with category_revenue as (
        select p.category, sum(oi.item_total) as category_revenue from products p 
        join order_items oi
         on p.product_id = oi.product_id
		group by p.category)
	select category, round(category_revenue) as category_revenue,
    round( sum(category_revenue) over(), 2) as total_revenue,
    round( category_revenue * 100.0 / sum(category_revenue) over(), 2) as revenue_percentage 
from category_revenue
order by revenue_percentage desc;

-- 8. Find products whose revenue is higher than the average revenue of products within their own category.
with product_revenue as (
      select p.product_id, p.product_name, p.category, SUM(oi.item_total) as total_revenue from products p
      join order_items oi
        on p.product_id = oi.product_id
      group by p.product_id, p.product_name, p.category),
      
category_averages as (
      select product_id, product_name, category, total_revenue,
      avg(total_revenue) over (partition by category) as category_average_revenue
      from product_revenue)
      
   select product_id, product_name, category,
    ROUND(total_revenue, 2) as total_revenue,
    ROUND(category_average_revenue, 2) as category_average_revenue
   FROM category_averages
WHERE total_revenue > category_average_revenue
ORDER BY category, total_revenue DESC;

-- 9. Calculate monthly revenue and compare each month's revenue with the previous month's revenue.
with monthly_revenue as(
		select year(order_date) as order_year, month(order_date) as order_month, sum(total_amount) as monthly_revenue from orders
        group by year(order_date), month(order_date) ),
        
revenue_comparison as ( 
		select order_year, order_month, monthly_revenue,
               lag(monthly_revenue) over( order by order_year, order_month) as previous_month_revenue
		from monthly_revenue)
        
        select order_year, order_month,
               round(monthly_revenue, 2) as monthly_revenue,
               round(previous_month_revenue, 2) as previous_month_revenue,
               
               round( monthly_revenue - previous_month_revenue, 2) as revenue_difference 
	   from revenue_comparison
       
order by order_year, order_month;

-- 10. Find the top 3 revenue-generating products within every category.
with product_revenue as (
            select
				   p.product_id, p.product_name, p.category,
                   sum(oi.item_total) as total_revenue 
			from products p
            
            join order_items oi
             on p.product_id = oi.product_id
             
             group by p.product_id, p.product_name, p.category ),
             
ranked_products as (
		select
               product_id, product_name, category, total_revenue,
		row_number() over( partition by category order by total_revenue desc) as product_rank
        from product_revenue )
        
select 
        product_id, product_name, category,
        round(total_revenue, 2) as total_revenue,
        product_rank
from ranked_products

where product_rank <= 3

order by category, product_rank;
