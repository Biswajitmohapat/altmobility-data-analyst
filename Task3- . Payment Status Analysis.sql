-- 1. Payment Status Distribution
SELECT 
    payment_status, 
    COUNT(*) AS total_payments,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM payments), 2) AS percentage
FROM payments
GROUP BY payment_status;

-- 2. Payment Method vs. Payment Status Breakdown
SELECT 
    payment_method,
    SUM(CASE WHEN payment_status = 'Completed' THEN 1 ELSE 0 END) AS completed,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed,
    SUM(CASE WHEN payment_status = 'Pending' THEN 1 ELSE 0 END) AS pending,
    COUNT(*) AS total
FROM payments
GROUP BY payment_method;

-- 3. Average Payment Amount by Payment Status
SELECT 
    payment_status,
    ROUND(AVG(payment_amount), 2) AS avg_payment_amount
FROM payments
GROUP BY payment_status;

-- 4.Payment Delay Insights (Average days between order and payment)
SELECT 
    p.payment_id,
    p.order_id,
    co.customer_id,
    DATEDIFF(p.payment_date, co.order_date) AS payment_delay_days
FROM 
    payments p
JOIN 
    customer_orders co ON p.order_id = co.order_id
WHERE 
    p.payment_status = 'Completed'
ORDER BY 
    payment_delay_days DESC;

-- 5.Monthly Failed Payments Trend
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS payment_month,
    COUNT(*) AS failed_payments
FROM 
    payments
WHERE 
    payment_status = 'Failed'
GROUP BY 
    payment_month
ORDER BY 
    payment_month;

-- 6.Delivered Orders Without Payment 
SELECT 
    co.order_id,
    co.customer_id,
    co.order_status,
    co.order_amount
FROM 
    customer_orders co
LEFT JOIN 
    payments p ON co.order_id = p.order_id
WHERE 
    co.order_status = 'Delivered' AND p.payment_id IS NULL;

-- 7. Avg. Payment Amount by Method (highlighting high-value method types)
SELECT 
    payment_method,
    COUNT(*) AS total_transactions,
    ROUND(AVG(payment_amount), 2) AS avg_payment_value,
    SUM(CASE WHEN payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_transactions
FROM 
    payments
GROUP BY 
    payment_method
ORDER BY 
    avg_payment_value DESC;

-- 8. Estimate of Unpaid Revenue (orders not fully paid)
SELECT 
    co.order_id,
    co.customer_id,
    co.order_amount,
    IFNULL(SUM(p.payment_amount), 0) AS total_paid,
    (co.order_amount - IFNULL(SUM(p.payment_amount), 0)) AS outstanding_amount
FROM 
    customer_orders co
LEFT JOIN 
    payments p ON co.order_id = p.order_id
GROUP BY 
    co.order_id, co.customer_id, co.order_amount
HAVING 
    outstanding_amount > 0
ORDER BY 
    outstanding_amount DESC;


-- 9.  Estimate Lost Revenue from Failed Payments
SELECT
    SUM(co.order_amount) AS total_lost_revenue
FROM
    customer_orders co
JOIN
    payments p ON co.order_id = p.order_id
WHERE
    p.payment_status = 'Failed';
    
    
-- 10. Monthly Payment Failure Trend
SELECT
    DATE_FORMAT(p.payment_date, '%Y-%m') AS payment_month,
    COUNT(*) AS total_attempts,
    SUM(CASE WHEN p.payment_status = 'Failed' THEN 1 ELSE 0 END) AS failed_payments,
    ROUND(SUM(CASE WHEN p.payment_status = 'Failed' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS failure_rate_pct
FROM
    payments p
GROUP BY
    payment_month
ORDER BY
    payment_month;
