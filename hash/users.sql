CREATE DATABASE cases;

USE DATABASE cases;

DROP TABLE IF EXISTS users_1;

DROP TABLE IF EXISTS users_2;

-- Создаем таблицы
CREATE TABLE users_1 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE users_2 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=MEMORY; -- Хранится в ОЗУ

-- Создаем индексы
CREATE INDEX idx_username ON users_1 (username) USING HASH;

CREATE INDEX idx_username ON users_2 (username) USING HASH;

-- Проверяем индексы
SHOW INDEX FROM users_1 FROM cases; -- Mysql должен заменить hash на b-tree из-за InnoDB движка

SHOW INDEX FROM users_2 FROM cases;

-- Заполняем таблицы
DELIMITER $$

CREATE PROCEDURE populate_users()
BEGIN
    DECLARE i INT DEFAULT 1;
    WHILE i <= 100000 DO
        INSERT INTO users_1 (username, email) -- users_2
        VALUES (CONCAT('user', i), CONCAT('user', i, '@example.com'));
        SET i = i + 1;
    END WHILE;
END$$

DELIMITER ;

CALL populate_users();

DROP PROCEDURE IF EXISTS populate_users;

-- Делаем различные запросы

EXPLAIN SELECT * FROM users_1 WHERE username = 'user90000'; -- Типо b-tree хуже

EXPLAIN SELECT * FROM users_2 WHERE username = 'user90000'; -- Типо hash лучше

EXPLAIN SELECT * FROM users_1 WHERE id BETWEEN 50000 AND 60000; -- B-tree лучше

EXPLAIN SELECT * FROM users_2 WHERE id BETWEEN 50000 AND 60000; -- Hash хуже

EXPLAIN SELECT * FROM users_1 ORDER BY id; -- B-tree лучше

EXPLAIN SELECT * FROM users_2 ORDER BY id; -- Hash хуже

EXPLAIN SELECT COUNT(*) FROM users_1 WHERE id BETWEEN 50000 AND 60000; -- B-tree лучше

EXPLAIN SELECT COUNT(*) FROM users_2 WHERE id BETWEEN 50000 AND 60000; -- Hash хуже
