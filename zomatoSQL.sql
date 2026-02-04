-- Active: 1770222622769@@127.0.0.1@5433@zomato
-- Zomato Data Analysis using SQL

CREATE TABLE customers
    (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR (25),
    reg_date DATE 
    );

CREATE TABLE restaurants
    (
    restaurant_id INT PRIMARY KEY,
    restaurant_name VARCHAR(55),
    city VARCHAR(25),
    opening_hours INT
    );

CREATE TABLE orders
    (
    order_id INT PRIMARY KEY,
    customer_id INT,--This is coming from the cx table
    restaurant_id,--This is comiing from the restaurant table
    order_item VARCHAR(55),
    order_date DATE,
    order_time TIME,
    order_status VARCHAR(55),
    total_amount FLOAT
    );

CREATE TABLE riders
    (
    rider_id INT PRIMARY KEY,
    rider_name VARCHAR (55),
    sign_up DATE      
    );

CREATE TABLE deliveries
    (
    delivery_id INT PRIMARY KEY,
    order_id INT, --this is coming orders table
    delivery_status VARCHAR(35),
    delivery_time TIME,
    rider_id INT --this is coming from riders table
    )