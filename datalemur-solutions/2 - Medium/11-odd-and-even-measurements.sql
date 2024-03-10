-- Assume you're given a table with measurement values obtained from a Google sensor over multiple days with measurements taken multiple times within each day.

-- Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular day and display the results in two different columns. Refer to the Example Output below for the desired format.

-- Definition:

-- Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.



-- Solution: 

WITH ranked_measurements AS (
  SELECT CAST(measurement_time AS DATE) AS measurement_day, 
         measurement_value, 
         ROW_NUMBER() OVER (PARTITION BY CAST(measurement_time AS DATE) ORDER BY measurement_time) AS measurement_num 
  FROM   measurements
) 
SELECT   measurement_day, 
         SUM(measurement_value) FILTER (WHERE measurement_num % 2 != 0) AS odd_sum, 
         SUM(measurement_value) FILTER (WHERE measurement_num % 2 = 0) AS even_sum 
FROM     ranked_measurements
GROUP BY 1



-- my approaches / attempts: 

-- 1. tried using "SUM filter" --> didn't work.
SELECT   measurement_time,
         SUM(FILTER(WHERE measurement_id % 2 = 1, measurement_value)) AS odd_sum,
         SUM(FILTER(WHERE measurement_id % 2 = 0, measurement_value)) AS even_sum
FROM     measurements
GROUP BY measurement_time, measurement_id;


-- 2. then switched to "SUM case when" --> error : operator does not exist: character varying % integer.

SELECT   measurement_time,
         SUM(CASE WHEN measurement_id%2 = 1 THEN measurement_value ELSE 0 END) AS odd_sum,
         SUM(CASE WHEN measurement_id%2 = 0 THEN measurement_value ELSE 0 END) AS even_sum
FROM     measurements
GROUP BY measurement_time, measurement_id;


-- 3. wrpng output

SELECT   measurement_time,
         SUM(CASE WHEN CAST(measurement_id AS INTEGER) % 2 = 1 THEN measurement_value ELSE 0 END) AS odd_sum,
         SUM(CASE WHEN CAST(measurement_id AS INTEGER) % 2 = 0 THEN measurement_value ELSE 0 END) AS even_sum
FROM     measurements
GROUP BY measurement_time


-- 4. error: aggregate function calls cannot contain window function calls.

SELECT   CAST(measurement_time AS DATE) AS measurement_day,
         SUM(CASE WHEN ROW_NUMBER() OVER (PARTITION BY CAST(measurement_time AS DATE) ORDER BY measurement_time) % 2 = 1 THEN measurement_value ELSE 0 END) AS odd_sum,
         SUM(CASE WHEN ROW_NUMBER() OVER (PARTITION BY CAST(measurement_time AS DATE) ORDER BY measurement_time) % 2 = 0 THEN measurement_value ELSE 0 END) AS even_sum
FROM     measurements
GROUP BY 1