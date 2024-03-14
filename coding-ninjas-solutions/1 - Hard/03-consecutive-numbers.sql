-- Write an SQL query to find all numbers that appear at least three times consecutively.


WITH surrounding_numbers as (
    SELECT id,
           num, 
           LAG(num) OVER(ORDER BY id) as prev_num,
           LEAD(num) OVER(ORDER BY id) as next_num
    FROM   Logs
)

SELECT num as ConsecutiveNums
FROM   surrounding_numbers
WHERE  num = prev_num and next_num = num;


-- remarks: solved in first attempt. 