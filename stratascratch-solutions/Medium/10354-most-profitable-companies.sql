WITH cte as (
    SELECT company, profits, DENSE_RANK() OVER(ORDER BY profits desc) as rn
    FROM   forbes_global_2010_2014
)
SELECT company, profits
FROM   cte
WHERE  rn <= 3 