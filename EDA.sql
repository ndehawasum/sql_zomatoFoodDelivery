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

-- -------------------------
-- ANALYSIS & REPORTS
-- -------------------------

--  Q1. Top 5 Most Frequently Ordered Dishes 
-- Question:  Write a query to find the top 5 most frequently ordered dishes by the customer "Arjun Mehta" in the last 1 year. 

-- join customers and orders
-- filter for last one year
-- filter 'arjun mehta'
-- group by customers_id, dishes, count of the customer

SELECT 
    customer_name,
    dishes,
    total_orders
FROM
    (SELECT
        c.customer_id,
        c.customer_name,
        o.order_item as dishes,
        COUNT(*) as total_orders,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) as rank
    FROM orders as o
    JOIN
    customers as c
    ON c.customer_id = o.customer_id
    WHERE 
        o.order_date >= DATE '2025-01-25' - INTERVAL '2 Year'
        AND
        c.customer_name = 'Arjun Mehta'
    GROUP BY 1, 2, 3
    ORDER BY 1, 4 DESC )as t1
WHERE rank <= 5

-- Q2. Popular Time Slots 
-- Question:  Identify the time slots during which the most orders are placed, based on 2-hour intervals. 

-- Approach 1
SELECT 
    CASE 
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 0 AND 1 THEN  '00:00 - 2:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 2 AND 3 THEN  '02:00- 04:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 4 AND 5 THEN  '04:00- 06:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 6 AND 7 THEN  '06:00- 08:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 8 AND 9 THEN  '08:00- 10:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 10 AND 11 THEN  '10:00- 12:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 12 AND 13 THEN  '12:00- 14:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 14 AND 15 THEN  '14:00- 16:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 16 AND 17 THEN  '16:00- 18:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 18 AND 19 THEN  '18:00- 20:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 20 AND 21 THEN  '20:00- 22:00'
        WHEN EXTRACT(HOUR FROM order_time) BETWEEN 22 AND 23 THEN  '22:00- 00:00'
    END AS time_slot,
    COUNT (order_id) AS order_count
FROM orders
GROUP BY time_slot
ORDER BY order_count DESC;

-- Approach 2
SELECT 
    FLOOR(EXTRACT(HOUR FROM order_time)/2)*2 AS start_time,
    FLOOR(EXTRACT(HOUR FROM order_time)/2)*2+2 AS end_time,
    COUNT(*) AS total_orders
FROM orders
GROUP BY 1, 2
ORDER BY 3 DESC;

-- Q3. Order Value Analysis 
-- Question: Find the average order value (AOV) per customer who has placed more than 750 orders. 
-- Return: customer_name, aov (average order value). 
SELECT 
    --o.customer_id,
    c.customer_name,
    AVG(total_amount) as aov,
    COUNT (order_id) as total_orders
FROM orders as o
    JOIN customers as c
    ON c.customer_id = o.customer_id
GROUP BY 1
HAVING COUNT(order_id) > 750
   

-- Q4. High-Value Customers 
-- Question: List the customers who have spent more than 100K in total on food orders. 
--Return: customer_name, customer_id. 

SELECT 
    --o.customer_id,
    c.customer_name,
    SUM(total_amount) as total_spent
FROM orders as o
    JOIN customers as c
    ON c.customer_id = o.customer_id
GROUP BY 1
HAVING SUM(o.total_amount) > 100000
   

-- Q5. Orders Without Delivery 
-- Question: Write a query to find orders that were placed but not delivered. 
-- Return: restaurant_name, city, and the number of not delivered orders. 

SELECT 
    r.restaurant_name,
    COUNT(o.order_id) as cnt_not_delivered_orders
FROM orders as o
LEFT JOIN
restaurants as r
ON r.restaurant_id = o.restaurant_id
LEFT JOIN
deliveries as d
ON d.order_id = o.order_id
WHERE d.delivery_id IS NULL
GROUP BY 1
ORDER BY 2 DESC

SELECT *
FROM orders as o
LEFT JOIN
restaurants as r
ON r.restaurant_id = o.restaurant_id
WHERE
    o.order_id NOT IN (SELECT order_id FROM deliveries)


-- Q6. Restaurant Revenue Ranking
-- Question: Rank restaurants by their total revenue from the last year. 
-- Return: restaurant_name, total_revenue, and their rank within their city. 

-- Q7. Most Popular Dish by City 
-- Question: Identify the most popular dish in each city based on the number of orders. 

-- Q8. Customer Churn 
-- Question:  Find customers who haven’t placed an order in 2024 but did in 2023. 

-- Q9. Cancellation Rate Comparison 
-- Question:  Calculate and compare the order cancellation rate for each restaurant between the current year and the previous year. 

-- Q10. Rider Average Delivery Time 
-- Question: Determine each rider's average delivery time. 

-- Q11. Monthly Restaurant Growth Ratio 
-- Question:  Calculate each restaurant's growth ratio based on the total number of delivered orders since its joining. 

-- Q12. Customer Segmentation 
-- Question: Segment customers into 'Gold' or 'Silver' groups based on their total spending compared to the average order value (AOV). If a customer's total spending exceeds the AOV, label them as 'Gold'; otherwise, label them as 'Silver'. 
-- Return: The total number of orders and total revenue for each segment. 

-- Q13. Rider Monthly Earnings 
-- Question:  Calculate each rider's total monthly earnings, assuming they earn 8% of the order amount. 

-- Q14. Rider Ratings Analysis 
-- Question: 
-- Find the number of 5-star, 4-star, and 3-star ratings each rider has. 
-- Riders receive ratings based on delivery time: 
-- ● 5-star: Delivered in less than 15 minutes 
-- ● 4-star: Delivered between 15 and 20 minutes 
-- ● 3-star: Delivered after 20 minutes 

-- Q15. Order Frequency by Day 
-- Question: Analyze order frequency per day of the week and identify the peak day for each restaurant. 

-- Q16. Customer Lifetime Value (CLV) 
-- Question: Calculate the total revenue generated by each customer over all their orders. 

-- Q17. Monthly Sales Trends 
-- Question: Identify sales trends by comparing each month's total sales to the previous month. 

-- Q18. Rider Efficiency
-- Question: Evaluate rider efficiency by determining average delivery times and identifying those with the lowest and highest averages. 

-- Q19. Order Item Popularity 
-- Question: Track the popularity of specific order items over time and identify seasonal demand spikes. 

-- Q20. City Revenue Ranking 
-- Question: Rank each city based on the total revenue for the last year (2023).
