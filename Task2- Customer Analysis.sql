-- Count total orders per customer to find repeat buyers
SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_spent,
    AVG(order_amount) AS avg_order_value
FROM customer_orders
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_orders DESC;


-- Segment customers into spending categories: Low, Medium, High
SELECT
    customer_id,
    COUNT(order_id) AS order_count,
    SUM(order_amount) AS total_spent,
    CASE
        WHEN SUM(order_amount) < 500 THEN 'Low Spender'
        WHEN SUM(order_amount) BETWEEN 500 AND 2000 THEN 'Medium Spender'
        ELSE 'High Spender'
    END AS spending_segment
FROM customer_orders
GROUP BY customer_id;


-- Segment by preferred payment method (most used by each customer)
SELECT
    co.customer_id,
    p.payment_method,
    COUNT(*) AS method_usage
FROM customer_orders co
JOIN payments p ON co.order_id = p.order_id
GROUP BY co.customer_id, p.payment_method
HAVING COUNT(*) = (
    SELECT COUNT(*)
    FROM customer_orders co2
    JOIN payments p2 ON co2.order_id = p2.order_id
    WHERE co2.customer_id = co.customer_id
    GROUP BY p2.payment_method
    ORDER BY COUNT(*) DESC
    LIMIT 1
);


-- Monthly order volume trend
SELECT
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS orders,
    SUM(order_amount) AS total_revenue
FROM customer_orders
GROUP BY month
ORDER BY month;

-- Monthly repeat vs first-time orders
WITH customer_first_order AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM customer_orders
    GROUP BY customer_id
)
SELECT
    DATE_FORMAT(co.order_date, '%Y-%m') AS month,
    COUNT(CASE WHEN co.order_date = cfo.first_order_date THEN 1 END) AS first_time_orders,
    COUNT(CASE WHEN co.order_date > cfo.first_order_date THEN 1 END) AS repeat_orders
FROM customer_orders co
JOIN customer_first_order cfo ON co.customer_id = cfo.customer_id
GROUP BY month
ORDER BY month; 



-- Estimate Customer Lifetime Value (total revenue per customer)
SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS total_revenue,
    ROUND(AVG(order_amount), 2) AS avg_order_value
FROM customer_orders
GROUP BY customer_id
ORDER BY total_revenue DESC;


-- Calculate average days between orders per customer
WITH order_times AS (
    SELECT
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM customer_orders
)
SELECT
    customer_id,
    COUNT(*) AS repeat_orders,
    ROUND(AVG(DATEDIFF(order_date, prev_order_date)), 2) AS avg_days_between_orders
FROM order_times
WHERE prev_order_date IS NOT NULL
GROUP BY customer_id
ORDER BY avg_days_between_orders;


-- Find the top 10% of customers by total spending
SELECT *
FROM (
    SELECT
        customer_id,
        SUM(order_amount) AS total_spent,
        NTILE(10) OVER (ORDER BY SUM(order_amount) DESC) AS decile
    FROM customer_orders
    GROUP BY customer_id
) AS ranked
WHERE decile = 1;

-- Identify orders with issues (e.g., pending orders or failed payments)
SELECT
    co.order_id,
    co.customer_id,
    co.order_status,
    p.payment_status
FROM customer_orders co
JOIN payments p ON co.order_id = p.order_id
WHERE co.order_status = 'pending' OR p.payment_status = 'failed';


-- Compare revenue from new vs repeat customers
WITH first_order AS (
    SELECT customer_id, MIN(order_date) AS first_order_date
    FROM customer_orders
    GROUP BY customer_id
)
SELECT
    CASE 
        WHEN co.order_date = fo.first_order_date THEN 'First-Time'
        ELSE 'Repeat'
    END AS customer_type,
    COUNT(co.order_id) AS order_count,
    SUM(co.order_amount) AS total_revenue,
    ROUND(SUM(co.order_amount) * 100.0 / (SELECT SUM(order_amount) FROM customer_orders), 2) AS revenue_share_pct
FROM customer_orders co
JOIN first_order fo ON co.customer_id = fo.customer_id
GROUP BY customer_type;


-- Most active shipping states or regions
SELECT
    SUBSTRING_INDEX(SUBSTRING_INDEX(shipping_address, ',', -1), ' ', -2) AS state_region,
    COUNT(*) AS total_orders,
    SUM(order_amount) AS total_revenue
FROM customer_orders
GROUP BY state_region
ORDER BY total_orders DESC
LIMIT 10;


-- Identify customers who haven't ordered in the last 6 months
SELECT customer_id,
       MAX(order_date) AS last_order_date
FROM customer_orders
GROUP BY customer_id
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY last_order_date;


