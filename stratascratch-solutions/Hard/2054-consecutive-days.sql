WITH surrounding_dates as (
    SELECT user_id,
           date, 
           LAG(date) OVER(PARTITION BY user_id ORDER BY date) as prev_date,
           LEAD(date) OVER(PARTITION BY user_id ORDER BY date) as next_date
    FROM   sf_events
)
SELECT user_id
FROM   surrounding_dates
WHERE  date = prev_date + INTERVAL '1 day' and 
       next_date = date + INTERVAL '1 day';