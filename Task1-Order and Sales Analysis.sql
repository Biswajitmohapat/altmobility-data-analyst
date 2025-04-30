-- 1. Shows how many orders fall under each status (e.g., Delivered, Cancelled, Pending)
SELECT order_status, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_status;

-- 2. Displays total sales revenue per month for delivered orders to track trends over time
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(order_amount) AS monthly_revenue
FROM customer_orders
WHERE order_status = 'Delivered'
GROUP BY month
ORDER BY month;


-- 3. Calculates the average order amount grouped by order status
SELECT order_status, AVG(order_amount) AS avg_order_value
FROM customer_orders
GROUP BY order_status;

-- 4. Sums up the total amount paid across all payment records
SELECT 
    SUM(payment_amount) AS total_payments_received
FROM payments;



-- 5. Shows which payment methods are most used and their contribution to revenue
SELECT payment_method, COUNT(*) AS usage_count, SUM(payment_amount) AS total_paid
FROM payments
GROUP BY payment_method
ORDER BY total_paid DESC;


-- 6. Lists the top 5 orders with the highest total amount
SELECT order_id, customer_id, order_amount
FROM customer_orders
ORDER BY order_amount DESC
LIMIT 5;



-- 7. Finds top customers based on total money spent
SELECT customer_id, SUM(order_amount) AS total_spent
FROM customer_orders
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;


-- 8.  Identifies orders where payment is less than the total order amount, including customer info
SELECT 
    co.order_id,
    co.customer_id,
    co.order_amount,
    IFNULL(SUM(p.payment_amount), 0) AS paid,
    (co.order_amount - IFNULL(SUM(p.payment_amount), 0)) AS outstanding
FROM customer_orders co
LEFT JOIN payments p ON co.order_id = p.order_id
GROUP BY co.order_id, co.customer_id, co.order_amount
HAVING outstanding > 0;



-- 9. Shows how many orders were placed each day
SELECT order_date, COUNT(*) AS total_orders
FROM customer_orders
GROUP BY order_date
ORDER BY order_date;


-- 10. Calculates the percentage of orders that were successfully delivered
SELECT 
    (COUNT(CASE WHEN order_status = 'Delivered' THEN 1 END) / COUNT(*)) * 100 AS fulfillment_rate
FROM customer_orders;





-- 11. Measures how much revenue comes from each type of order status
SELECT order_status, SUM(order_amount) AS revenue
FROM customer_orders
GROUP BY order_status
ORDER BY revenue DESC;


-- 12. Lists orders where no payment has been recorded at all
SELECT co.order_id, co.customer_id, co.order_amount
FROM customer_orders co
LEFT JOIN payments p ON co.order_id = p.order_id
WHERE p.payment_id IS NULL;


