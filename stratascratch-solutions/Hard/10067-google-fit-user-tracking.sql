-- avg session dist. 
-- 2 scenarios : 1. consider curvature ; 2. consider curvature as flat earth

-- 1 session --> distnace betn biggest and smallest step
-- greater than 1 step id 

-- 2 scenarios, diff betwn them 



WITH get_session_distance AS (
    SELECT   user_id, 
             session_id, 
             MAX(step_id) AS biggest_step, 
             MIN(step_id) AS smallest_step,
             MAX(step_id) - MIN(step_id) AS session_distance
    FROM     google_fit_location
    GROUP BY 1, 2
    HAVING   COUNT(step_id) > 1
    ORDER BY 1, 2
),
get_coordinates AS (
    SELECT gs.user_id, 
           g1.latitude AS lat1, 
           g1.longitude AS long1, 
           g2.latitude AS lat2, 
           g2.longitude AS long2
    FROM   get_session_distance gs JOIN google_fit_location g1 
           ON   gs.user_id=g1.user_id AND gs.session_id=g1.session_id AND gs.smallest_step = g1.step_id 
           JOIN google_fit_location g2 
           ON   gs.user_id=g1.user_id AND gs.session_id=g1.session_id AND gs.biggest_step = g2.step_id
),
get_scenarios_distances AS (
    SELECT user_id,
           ACOS(
                SIN(lat1 * pi() / 180) * SIN(lat2 * pi() / 180) +
                COS(lat1 * pi() / 180) * COS(lat2 * pi() / 180) * COS(long2 * pi() / 180 - long1 * pi() / 180)
                ) * 6371 as curv_dist,
           SQRT((lat2 - lat1) ^2 + (long2 - long1) ^2) * 111 as flat_dist
    FROM   get_coordinates
)
SELECT   user_id,
         AVG(curv_dist) as avg_curv_dist,
         AVG(flat_dist) as avg_flat_dist
FROM     get_scenarios_distances
GROUP BY 1
ORDER BY 1



