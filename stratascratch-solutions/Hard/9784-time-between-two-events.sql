WITH page_loads AS (
    SELECT user_id, timestamp AS load_time
    FROM   facebook_web_log
    WHERE  action = 'page_load'
),
scroll_downs AS (
    SELECT user_id, timestamp AS scroll_time
    FROM   facebook_web_log
    WHERE  action = 'scroll_down'
),
time_differences AS (
    SELECT pl.user_id,
           load_time,
           scroll_time,
           EXTRACT(EPOCH FROM (scroll_time - load_time)) AS time_diff
    FROM   page_loads pl JOIN scroll_downs sd ON pl.user_id = sd.user_id
                                              AND sd.scroll_time > pl.load_time
),
ranked_differences AS (
    SELECT *, RANK() OVER (ORDER BY time_diff ASC) AS rn
    FROM   time_differences
)
SELECT user_id, load_time, scroll_time, time_diff
FROM   ranked_differences
WHERE  rn = 1