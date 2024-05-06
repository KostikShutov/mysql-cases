-- Read uncommited

/*
Уровень, имеющий самую плохую согласованность данных, но самую высокую скорость выполнения транзакций. Название уровня говорит само за себя — каждая транзакция видит незафиксированные изменения другой транзакции (феномен грязного чтения). Посмотрим какое влияние оказывают друг на друга такие транзакции.
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
SET SESSION TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

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

-- 1 терминал (видим изменения из другой незакрытой транзакции – грязное чтение)
SELECT * FROM users;

```
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | Boris |     100 |
|  3 | Ivan  |     450 |
+----+-------+---------+
```

-- 1 и 2 терминал
COMMIT;
