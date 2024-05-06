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

-- Агрегация
SELECT mark, model, rating,
    count(rating) over (partition by mark) count,
    min(rating) over (partition by mark) min_rating,
    max(rating) over (partition by mark) max_rating
FROM cars
WHERE rating > 4.5;

-- Ранжирование
SELECT mark, model, rating,
    row_number() over (partition by mark order by rating ASC) row_num
FROM cars;

-- Смещение
SELECT mark, model, rating,
    lag(rating) over (order by mark) previous_rating,
    lead(rating) over (order by mark) next_rating
FROM cars;
