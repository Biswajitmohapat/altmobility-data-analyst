--  Full Order and Payment Detail Report
SELECT
    co.order_id,
    co.customer_id,
    co.order_date,
    co.order_status,
    co.order_amount,
    p.payment_id,
    p.payment_date,
    p.payment_method,
    p.payment_status,
    p.payment_amount
FROM
    customer_orders co
LEFT JOIN
    payments p ON co.order_id = p.order_id
ORDER BY
    co.order_date DESC;
    
    
--  Payment Status Comparison Against Order Amount
SELECT
    co.order_id,
    co.customer_id,
    co.order_amount,
    IFNULL(SUM(p.payment_amount), 0) AS total_paid,
    (IFNULL(SUM(p.payment_amount), 0) - co.order_amount) AS payment_difference,
    CASE
        WHEN IFNULL(SUM(p.payment_amount), 0) = co.order_amount THEN 'Paid in Full'
        WHEN IFNULL(SUM(p.payment_amount), 0) > co.order_amount THEN 'Overpaid'
        WHEN IFNULL(SUM(p.payment_amount), 0) = 0 THEN 'No Payment'
        ELSE 'Underpaid'
    END AS payment_status
FROM
    customer_orders co
LEFT JOIN
    payments p ON co.order_id = p.order_id
GROUP BY
    co.order_id, co.customer_id, co.order_amount;


--  Time to Pay per Order
SELECT
    co.order_id,
    co.customer_id,
    co.order_date,
    MIN(p.payment_date) AS first_payment_date,
    DATEDIFF(MIN(p.payment_date), co.order_date) AS days_to_pay
FROM
    customer_orders co
JOIN
    payments p ON co.order_id = p.order_id
WHERE
    p.payment_status = 'Completed'
GROUP BY
    co.order_id, co.customer_id, co.order_date;
    
    
--  Summary Metrics: Orders, Revenue, Completion Rate
SELECT
    COUNT(DISTINCT co.order_id) AS total_orders,
    COUNT(DISTINCT p.payment_id) AS total_payments,
    SUM(co.order_amount) AS total_order_value,
    SUM(p.payment_amount) AS total_paid_amount,
    ROUND(SUM(p.payment_amount) * 100.0 / SUM(co.order_amount), 2) AS payment_completion_percentage
FROM
    customer_orders co
LEFT JOIN
    payments p ON co.order_id = p.order_id;


--  Orders Without Any Payment
SELECT
    co.order_id,
    co.customer_id,
    co.order_amount,
    co.order_date,
    co.order_status
FROM
    customer_orders co
LEFT JOIN
    payments p ON co.order_id = p.order_id
WHERE
    p.payment_id IS NULL;


--  Order Activity Timeline (Orders + Payments)
SELECT 
    co.order_id,
    co.customer_id,
    co.order_date,
    co.order_amount,
    p.payment_date,
    p.payment_method,
    p.payment_status,
    p.payment_amount
FROM 
    customer_orders co
LEFT JOIN 
    payments p ON co.order_id = p.order_id
ORDER BY 
    co.order_date, p.payment_date;

-- Customer Retention Segmentation BY ORDER: One-Time, Returning, and Loyal Buyers
SELECT
    CASE 
        WHEN order_count = 1 THEN 'One-Time Buyer'
        WHEN order_count BETWEEN 2 AND 3 THEN 'Returning Buyer'
        ELSE 'Loyal Buyer'
    END AS retention_group,
    COUNT(*) AS customer_count
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM customer_orders
    GROUP BY customer_id
) AS customer_orders_summary
GROUP BY
    CASE 
        WHEN order_count = 1 THEN 'One-Time Buyer'
        WHEN order_count BETWEEN 2 AND 3 THEN 'Returning Buyer'
        ELSE 'Loyal Buyer'
    END;
