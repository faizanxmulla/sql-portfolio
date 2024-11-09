WITH CTE as (
    SELECT   account_id, date, COUNT(DISTINCT user_id) as user_count
    FROM     sf_events
    WHERE    date BETWEEN '2021-01-01' and '2021-01-31'
    GROUP BY 1, 2
)
SELECT   account_id, SUM(user_count)/31.0 as average
FROM     CTE
GROUP BY 1



-- NOTE: was doing AVG(user_count) initially; also couldn't figure out to divide by 31 on own.