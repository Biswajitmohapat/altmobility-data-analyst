CREATE DATABASE alt_mobility;
USE alt_mobility;

CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(50),
    order_amount DECIMAL(10, 2)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    order_id INT,
    payment_date DATE,
    payment_amount DECIMAL(10, 2),
    payment_method VARCHAR(50)
);

SELECT * FROM customer_orders
SELECT * FROM payments