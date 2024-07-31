CREATE DATABASE cases;

USE DATABASE cases;

DROP TABLE IF EXISTS employees;

-- Создать таблицу
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    manager_id INT
);

-- Заполняем таблицу
INSERT INTO employees (employee_id, employee_name, manager_id) VALUES
(1, 'Alice', NULL),
(2, 'Bob', 1),
(3, 'Charlie', 1),
(4, 'David', 2),
(5, 'Eve', 2),
(6, 'Frank', 3),
(7, 'Grace', 3),
(8, 'Hank', 4),
(9, 'Ivy', 4),
(10, 'Jack', 5);

-- Запрос с CTE
EXPLAIN ANALYZE
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT employee_id, employee_name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.employee_name, e.manager_id
    FROM employees e
    JOIN EmployeeHierarchy eh ON e.manager_id = eh.employee_id
)
SELECT employee_id, employee_name, manager_id
FROM EmployeeHierarchy
ORDER BY manager_id, employee_id;

-- Запрос без CTE
EXPLAIN ANALYZE
SELECT e1.employee_id, e1.employee_name, e1.manager_id, e2.employee_name AS manager_name
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;
