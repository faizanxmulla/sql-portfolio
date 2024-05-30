WITH step_differences AS (
    SELECT feature_id,
           user_id,
           step_reached,
           timestamp,
           LEAD(timestamp) OVER (PARTITION BY feature_id, user_id ORDER BY step_reached) AS next_timestamp
    FROM   facebook_product_features_realizations
),
time_differences AS (
    SELECT feature_id,
           EXTRACT(EPOCH FROM (next_timestamp - timestamp)) AS time_diff
    FROM   step_differences
    WHERE  next_timestamp IS NOT NULL
)
SELECT   feature_id,
         AVG(time_diff) AS avg_time_in_seconds
FROM     time_differences
GROUP BY 1
ORDER BY 1