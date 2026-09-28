create database ecommerce_analytics;

use ecommerce_analytics;

create table customers (
customer_id int primary key,
first_name varchar(50),
last_name varchar(50),
email varchar(50) unique,
gender varchar(10),
date_of_birth date,
city varchar(50),
state varchar(50),
country varchar(50),
registration_date date,
customer_status varchar(20) );

create table products (
product_id int primary key,
product_name varchar(100),
category varchar(50),
subcategory varchar(50),
brand varchar(50),
unit_price decimal(10,2),
stock_quantity int,
reorder_level int,
supplier_name varchar(100),
product_status varchar(20),
product_added_date date);

create table orders(
order_id int primary key,
customer_id int,
order_date date,
order_status varchar(20),
shipping_city varchar(50),
shipping_state varchar(50),
total_amount decimal(10,2),
foreign key (customer_id) references customers(customer_id) );

create table order_items (
   order_item_id int primary key,
   order_id int,
   product_id int,
   quantity int,
   unit_price decimal(10,2),
   discount_amount decimal(10,2),
   item_total decimal(10,2),
   foreign key(order_id) references orders(order_id),
   foreign key(product_id) references products(product_id) );
   
create table payments (
       payment_id int primary key,
       order_id int,
       payment_date date,
       payment_method varchar(30),
       payment_status varchar(20),
       amount_paid decimal(10,2),
       transaction_id varchar(100) unique,
       foreign key(order_id) references orders(order_id) );
       select count(*) as total_payments from payments