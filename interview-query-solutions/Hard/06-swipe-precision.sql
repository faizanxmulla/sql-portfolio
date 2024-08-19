WITH CTE as (
    SELECT   v.user_id, 
             variant,
             COUNT(is_right_swipe) as swipe_threshold, 
             COUNT(is_right_swipe) FILTER(WHERE is_right_swipe='1') as right_swipes
    FROM     variants v JOIN swipes s USING(user_id)
    GROUP BY 1, 2
    HAVING   COUNT(is_right_swipe) >= 10
)
SELECT   AVG(right_swipes) as mean_right_swipes, 
         COUNT(user_id) as num_users,
         swipe_threshold,
         variant
FROM     CTE
GROUP BY 3, 4



-- NOTE: solved in first attempt itself.