-- EDA


SELECT*FROM customers;
SELECT * FROM restaurants;
SELECT * FROM orders;
SELECT * FROM riders;
SELECT * FROM deliveries;

-- Handling Null values

SELECT COUNT(*) FROM customers
WHERE 
    customer_name IS NULL
    OR
    reg_date IS NULL

SELECT COUNT(*) FROM restaurants
WHERE 
    restaurant_name IS NULL
    OR
    city IS NULL
    OR
    opening_hours IS NULL

SELECT COUNT(*) FROM orders
WHERE 
    order_item IS NULL
    OR
    order_date IS NULL
    OR
    order_time IS NULL
    OR
    order_status IS NULL
    OR 
    total_amount IS NULL

SELECT COUNT(*) FROM riders
WHERE 
    rider_name IS NULL
    OR
    sign_up IS NULL


SELECT COUNT(*) FROM deliveries
WHERE 
    delivery_status IS NULL
    OR
    delivery_time IS NULL