-- Repeatable read

/*
Уровень, позволяющий предотвратить феномен неповторяющегося чтения. Т.е. мы не видим в исполняющейся транзакции измененные и удаленные записи другой транзакцией. Но все еще видим вставленные записи из другой транзакции. Чтение фантомов никуда не уходит.

На самом деле в MySQL отсутствует эффект чтения фантомов для уровня repeatable read. И в PostgreSQL от него тоже избавились для этого уровня. Хотя в классическом представлении этого уровня, мы должны наблюдать этот эффект.
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
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;

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

-- 1 терминал (ничего не изменилось, так как данные заснапшотились на первом селекте)
SELECT * FROM users;

```
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | Boris |     200 |
|  2 | Vova  |     400 |
+----+-------+---------+
```

-- 1 терминал
COMMIT;
