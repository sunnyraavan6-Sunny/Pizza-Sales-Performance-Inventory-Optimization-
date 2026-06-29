show tables;
select * from cleaned_pizza_sales;
DESCRIBE cleaned_pizza_sales;

-- Business Problem Statements-- 
-- 1Q:-Sales Trends: What are the peak hours and days for orders?
SELECT 
    HOUR(time) AS order_hour, 
    COUNT(order_id) AS total_orders
FROM cleaned_pizza_sales
GROUP BY order_hour
ORDER BY total_orders DESC;
-- 2QProduct Performance: Which pizzas are the best and worst sellers (Revenue vs. Quantity)?
SELECT 
    name, 
    SUM(quantity) AS total_quantity, 
    SUM(quantity * price) AS total_revenue
FROM cleaned_pizza_sales
GROUP BY name
ORDER BY total_revenue DESC
LIMIT 5;
-- 3QInventory: Based on ingredients, what should be the daily stock levels for "Best Seller" months?
SELECT 
    MONTHNAME(date) AS month_name, 
    COUNT(order_id) AS total_orders
FROM cleaned_pizza_sales
GROUP BY month_name
ORDER BY total_orders DESC;
-- 4QPricing Strategy: How does pizza size affect the total revenue?
SELECT 
    size, 
    COUNT(order_id) AS total_orders,
    SUM(quantity) AS total_pizzas_sold,
    ROUND(SUM(quantity * price), 2) AS total_revenue,
    ROUND(AVG(price), 2) AS avg_unit_price
FROM cleaned_pizza_sales
GROUP BY size
ORDER BY total_revenue DESC;


-- The "Top 5" Performers (Revenue vs. Quantity)
SELECT 
    name, 
    SUM(quantity) AS total_quantity, 
    SUM(quantity * price) AS total_revenue
FROM cleaned_pizza_sales
GROUP BY name
ORDER BY total_revenue DESC
LIMIT 5;

-- The "Bottom 5" Performers (The Underperformers) 
SELECT 
    name, 
    SUM(quantity) AS total_quantity, 
    SUM(quantity * price) AS total_revenue
FROM cleaned_pizza_sales
GROUP BY name
ORDER BY total_revenue ASC
LIMIT 5;

-- On which day do customers spend the most per order?
SELECT 
    DAYNAME(date) AS day_of_week, 
    ROUND(SUM(quantity * price) / COUNT(DISTINCT order_id), 2) AS avg_order_value
FROM cleaned_pizza_sales
GROUP BY day_of_week
ORDER BY avg_order_value DESC;

-- Which pizza category (Classic, Veggie, Supreme, Chicken) gives us the most "bang for our buck"?
SELECT 
    category, 
    COUNT(DISTINCT name) AS number_of_unique_pizzas,
    SUM(quantity) AS total_quantity_sold,
    ROUND(SUM(quantity * price), 2) AS total_revenue
FROM cleaned_pizza_sales
GROUP BY category
ORDER BY total_revenue DESC;

-- What is the average number of pizzas per order?
WITH pizzas_per_order AS (
    SELECT order_id, SUM(quantity) AS total_pizzas
    FROM cleaned_pizza_sales
    GROUP BY order_id
)
SELECT ROUND(AVG(total_pizzas), 2) AS avg_pizzas_per_order
FROM pizzas_per_order;