-- Serializable

/*
Уровень, при котором транзакции ведут себя как будто ничего более не существует, никакого влияния друг на друга нет. В классическом представлении этот уровень избавляет от эффекта чтения фантомов.
*/

CREATE DATABASE cases;

USE DATABASE cases;

DROP TABLE IF EXISTS users;

-- Создаем таблицу
CREATE TABLE users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    balance INT(11),
    PRIMARY KEY (id)
) ENGINE=InnoDB;

-- Вставляем начальные данные
INSERT INTO users (name, balance) VALUES ('Boris', 200);
INSERT INTO users (name, balance) VALUES ('Vova', 400);

-- Проверяем начальные данные
SELECT * FROM users;

-- 1 и 2 терминал
SET SESSION TRANSACTION ISOLATION LEVEL SERIALIZABLE;

-- 1 и 2 терминал
START TRANSACTION;

-- 1 терминал
SELECT * FROM users;

```
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | Boris |     200 |
|  2 | Vova  |     400 |
+----+-------+---------+
```

-- 2 терминал
UPDATE users SET balance = 100 WHERE name = 'Boris'; -- Приводит к локу
INSERT INTO users (name, balance) VALUES ('Ivan', 450); -- Приводит к локу
DELETE FROM users WHERE name = 'Vova'; -- Приводит к локу

-- 1 и 2 терминал
COMMIT;
