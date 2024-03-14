-- There is a queue of people waiting to board a bus. However, the bus has a weight limit of 1000 kilograms, so there may be some people who cannot board.

-- Write an SQL query to find the person_name of the last person that can fit on the bus without exceeding the weight limit. 

-- The testcases are generated such that the first person does not exceed the weight limit.



WITH cumulative_sum as (
    SELECT *, SUM(weight) OVER(ORDER BY turn) as total_weight
    FROM   Queue
),

last_person as (
    SELECT *, LEAD(person_name) OVER()
    FROM   cumulative_sum
    WHERE  total_weight >=1000
)

SELECT person_name
FROM   last_person
LIMIT  1


-- remarks: solved by own w/o hints. 