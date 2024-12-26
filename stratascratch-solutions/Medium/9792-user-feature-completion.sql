WITH most_recent_steps as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id, feature_id ORDER BY timestamp desc) as rn
    FROM   facebook_product_features_realizations
)
, filtered_recent_step as (
    SELECT feature_id, user_id, step_reached
    FROM   most_recent_steps
    WHERE  rn=1
)
SELECT   pf.feature_id, 
         100.0 * AVG(COALESCE(fs.step_reached, 0)) / pf.n_steps as avg_share_of_completion
FROM     facebook_product_features pf LEFT JOIN filtered_recent_step fs 
ON       fs.feature_id=pf.feature_id
GROUP BY pf.feature_id, pf.n_steps




-- my initial attempt : 

WITH CTE as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id, feature_id ORDER BY timestamp desc) as rn
    FROM   facebook_product_features_realizations
)
SELECT   c.feature_id, 100.0 * AVG(c.step_reached / pf.n_steps) as avg_share_of_completion
FROM     CTE c RIGHT JOIN facebook_product_features pf ON c.feature_id=pf.feature_id
WHERE    c.rn=1
GROUP BY c.feature_id