WITH CTE as (
    SELECT   media_type,
             SUM(cost) as money_spent,
             DENSE_RANK() OVER(ORDER BY SUM(cost) desc) as rn
    FROM     online_sales_promotions
    GROUP BY media_type
)
SELECT media_type, money_spent
FROM   CTE
WHERE  rn < 3



-- NOTE: initially in the DENSE_RANK was doing PARTITION BY media_type