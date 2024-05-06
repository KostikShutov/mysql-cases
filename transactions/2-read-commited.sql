-- Read commited

/*
Для этого уровня параллельно исполняющиеся транзакции видят только зафиксированные изменения из других транзакций. Таким образом, данный уровень обеспечивает защиту от грязного чтения.
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
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

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
UPDATE users SET balance = 100 WHERE name = 'Boris';
INSERT INTO users (name, balance) VALUES ('Ivan', 450);
DELETE FROM users WHERE name = 'Vova';

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
COMMIT;

-- 1 терминал (видим коммитнутые из другой транзакции изменения – неповторяющееся чтение и чтение фантомов)
SELECT * FROM users;

```
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | Boris |     100 |
|  3 | Ivan  |     450 |
+----+-------+---------+
```

-- 1 терминал
COMMIT;
