WITH ranked_net_times as (
    SELECT person_name, net_time, DENSE_RANK() OVER(ORDER BY net_time) as rn
    FROM   marathon_male
)
SELECT 
    (SELECT net_time FROM marathon_male WHERE person_name='Chris Doe') -
    (SELECT distinct net_time FROM ranked_net_times WHERE rn=10) as difference



-- NOTE: got this idea from previous question's solution.