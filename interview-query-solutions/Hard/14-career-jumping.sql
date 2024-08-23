WITH manager_promotions as (
    SELECT   user_id, MIN(start_date) as promotion_date 
    FROM     user_experiences
    WHERE    title='data science manager'
    GROUP BY 1
), 
jobs_cte as (
    SELECT   ue.user_id, 
             promotion_date, 
             COUNT(DISTINCT ue.id) as jobs_switched_counter,
             MIN(start_date) as career_start_date
    FROM     user_experiences ue JOIN manager_promotions mp USING(user_id)
    WHERE    start_date = promotion_date
    GROUP BY 1, 2
)
SELECT   jobs_switched_counter, 
         AVG(TIMESTAMPDIFF(MONTH, career_start_date, promotion_date)) as months_to_promotion
FROM     jobs_cte
GROUP BY 1
ORDER BY 2 DESC



-- NOTE: couldn't find the solution on my own. had this idea but couldn't implement it.