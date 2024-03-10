-- Write an SQL query to evaluate the boolean expressions in Expressions table.
-- Return the result table in any order.


with cte as (
    SELECT e.*,
           v1.value as left_value, 
           v2.value as right_value
    FROM   Expressions e JOIN Variables v1 on e.left_operand=v1.name 
                         JOIN Variables v2 on e.right_operand=v2.name
)
select left_operand, 
       operator, 
       right_operand, 
       CASE 
            WHEN operator='=' and left_value=right_value THEN 'true'
            WHEN operator='>' and left_value>right_value THEN 'true'
            WHEN operator='<' and left_value<right_value THEN 'true'
          ELSE 'false'
       END
from   cte


-- remarks: couldnt figure out on how to assign values to variables. 