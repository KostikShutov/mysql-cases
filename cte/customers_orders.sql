CREATE DATABASE cases;

USE DATABASE cases;

DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS orders;

-- Создаем таблицы
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Заполняем таблицы
INSERT INTO customers (customer_id, customer_name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

INSERT INTO orders (order_id, customer_id, order_date, amount) VALUES
(1, 1, '2023-01-01', 100.00),
(2, 1, '2023-01-02', 150.00),
(3, 2, '2023-01-03', 200.00),
(4, 3, '2023-01-04', 250.00),
(5, 3, '2023-01-05', 300.00);

-- Запрос с CTE
EXPLAIN ANALYZE
WITH OrderCounts AS (
    SELECT customer_id, COUNT(*) AS order_count
    FROM orders
    GROUP BY customer_id
)
SELECT c.customer_name, oc.order_count
FROM customers c
LEFT JOIN OrderCounts oc ON c.customer_id = oc.customer_id;

-- Запрос без CTE
EXPLAIN ANALYZE
SELECT c.customer_name, COUNT(o.order_id) AS order_count
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;
