-- Read uncommited

CREATE DATABASE test;

USE DATABASE test;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT(11) NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    balance INT(11),
    PRIMARY KEY (id)
) ENGINE=InnoDB;

INSERT INTO users (name, balance) VALUES ('Boris', 200);

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
+----+-------+---------+
```

-- 2 терминал
UPDATE users SET balance = 100;

-- 1 терминал (грязное чтение)
SELECT * FROM users;

```
+----+-------+---------+
| id | name  | balance |
+----+-------+---------+
|  1 | Boris |     100 |
+----+-------+---------+
```

-- 1 и 2 терминал
COMMIT;
