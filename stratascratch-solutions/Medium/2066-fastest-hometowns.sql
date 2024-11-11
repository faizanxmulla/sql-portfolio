WITH ranked_hometown as (
    SELECT   hometown, 
             AVG(net_time) as avg_net_time, 
             DENSE_RANK() OVER(ORDER BY AVG(net_time)) as rn
    FROM     marathon_male
    GROUP BY 1
)
SELECT hometown, avg_net_time
FROM   ranked_hometown
WHERE  rn <= 3



-- NOTE: solved in first attempt