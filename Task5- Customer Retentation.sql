-- PART 1: Find the first order date for every customer (i.e., cohort start date)
WITH customer_cohort AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM 
        customer_orders
    GROUP BY 
        customer_id
)

-- View output
SELECT * FROM customer_cohort;


-- PART 2: Join orders with cohort info and calculate cohort_index (months since first order)
WITH customer_cohort AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM 
        customer_orders
    GROUP BY 
        customer_id
),
orders_with_cohort AS (
    SELECT 
        o.customer_id,
        o.order_id,
        DATE_FORMAT(c.first_order_date, '%Y-%m') AS cohort_month,  -- First order month
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,         -- Current order month
        TIMESTAMPDIFF(MONTH, c.first_order_date, o.order_date) AS cohort_index
    FROM 
        customer_orders o
    JOIN 
        customer_cohort c ON o.customer_id = c.customer_id
)

-- View output
SELECT * FROM orders_with_cohort;


-- PART 3: Count distinct active customers for each cohort and month offset
WITH customer_cohort AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM 
        customer_orders
    GROUP BY 
        customer_id
),
orders_with_cohort AS (
    SELECT 
        o.customer_id,
        o.order_id,
        DATE_FORMAT(c.first_order_date, '%Y-%m') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        TIMESTAMPDIFF(MONTH, c.first_order_date, o.order_date) AS cohort_index
    FROM 
        customer_orders o
    JOIN 
        customer_cohort c ON o.customer_id = c.customer_id
),
active_customers AS (
    SELECT 
        cohort_month,
        cohort_index,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM 
        orders_with_cohort
    GROUP BY 
        cohort_month, cohort_index
)

-- View output
SELECT * FROM active_customers;


-- PART 4: Count how many customers are in each cohort (in their first month only)
WITH customer_cohort AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM 
        customer_orders
    GROUP BY 
        customer_id
),
orders_with_cohort AS (
    SELECT 
        o.customer_id,
        o.order_id,
        DATE_FORMAT(c.first_order_date, '%Y-%m') AS cohort_month,
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        TIMESTAMPDIFF(MONTH, c.first_order_date, o.order_date) AS cohort_index
    FROM 
        customer_orders o
    JOIN 
        customer_cohort c ON o.customer_id = c.customer_id
),
total_customers AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM 
        orders_with_cohort
    WHERE 
        cohort_index = 0
    GROUP BY 
        cohort_month
)

-- View output
SELECT * FROM total_customers;


-- FINAL QUERY with Cohort Month as 'Jan 2020' format
WITH customer_cohort AS (
    SELECT 
        customer_id,
        MIN(order_date) AS first_order_date
    FROM 
        customer_orders
    GROUP BY 
        customer_id
),
orders_with_cohort AS (
    SELECT 
        o.customer_id,
        o.order_id,
        DATE_FORMAT(c.first_order_date, '%Y-%m') AS cohort_month,
        DATE_FORMAT(c.first_order_date, '%b %Y') AS cohort_month_name,  -- 'Jan 2020' format
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        TIMESTAMPDIFF(MONTH, c.first_order_date, o.order_date) AS cohort_index
    FROM 
        customer_orders o
    JOIN 
        customer_cohort c ON o.customer_id = c.customer_id
),
active_customers AS (
    SELECT 
        cohort_month,
        cohort_month_name,
        cohort_index,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM 
        orders_with_cohort
    GROUP BY 
        cohort_month, cohort_month_name, cohort_index
),
total_customers AS (
    SELECT 
        cohort_month,
        cohort_month_name,
        COUNT(DISTINCT customer_id) AS total_customers
    FROM 
        orders_with_cohort
    WHERE 
        cohort_index = 0
    GROUP BY 
        cohort_month, cohort_month_name
)

-- Final Output
SELECT 
    ac.cohort_month,
    ac.cohort_month_name,  -- human-readable
    ac.cohort_index,
    ac.active_customers,
    tc.total_customers,
    CONCAT(ROUND((ac.active_customers * 100.0) / tc.total_customers, 2), '%') AS retention_rate
FROM 
    active_customers ac
JOIN 
    total_customers tc ON ac.cohort_month = tc.cohort_month
ORDER BY 
    ac.cohort_month, ac.cohort_index;
    
    
    
    
    
    
    
  