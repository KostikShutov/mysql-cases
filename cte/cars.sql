CREATE DATABASE cases;

USE DATABASE cases;

DROP TABLE IF EXISTS cars;

-- Создаем таблицу
CREATE TABLE cars (
    id INT AUTO_INCREMENT PRIMARY KEY,
    mark VARCHAR(50) NOT NULL,
    model VARCHAR(50) NOT NULL,
    rating VARCHAR(100) NOT NULL
) ENGINE=InnoDB;

-- Заполняем таблицу
DELIMITER $$

CREATE PROCEDURE generate_random_cars_data()
BEGIN
    DECLARE i INT DEFAULT 0;
    DECLARE j INT DEFAULT 0;
    DECLARE mark_prefix VARCHAR(10);
    DECLARE model_prefix VARCHAR(10);
    DECLARE rating DECIMAL(3,1);
    
    WHILE i < 100 DO
        SET i = i + 1;
        SET j = 0;
        WHILE j < 100 DO
            SET j = j + 1;
            SET mark_prefix = CONCAT('Mark', i);
            SET model_prefix = CONCAT('Model', j);
            SET rating = ROUND(RAND() * 4 + 1, 1);

            INSERT INTO cars (mark, model, rating) VALUES (mark_prefix, model_prefix, rating);
        END WHILE;
    END WHILE;
END$$

DELIMITER ;

CALL generate_random_cars_data();

DROP PROCEDURE IF EXISTS generate_random_cars_data;

-- Простой запрос
SELECT mark, COUNT(*) cnt
FROM cases.cars
WHERE cars.rating > 4.0
GROUP BY mark
ORDER BY mark;

-- Такой же, но через CTE
WITH TMP(mark, cnt) AS (
    SELECT mark, COUNT(*) cnt
    FROM cases.cars
    WHERE cars.rating > 4.0
    GROUP BY mark
)
SELECT *
FROM TMP
ORDER BY mark

-- Двойное переиспользование (тупой пример)
WITH TMP AS (
    SELECT mark, COUNT(*) cnt
    FROM cars
    WHERE rating > 4.0
    GROUP BY mark
)
SELECT 
    t1.mark mark1, t1.cnt cnt1, 
    t2.mark mark2, t2.cnt cnt2
FROM TMP t1
JOIN TMP t2 ON t1.mark = t2.mark
ORDER BY t1.mark;
