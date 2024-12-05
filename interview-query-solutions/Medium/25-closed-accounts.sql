WITH CTE as (
    SELECT account_id,
           date,
           status,
           LEAD(status) OVER(PARTITION BY account_id ORDER BY date) as next_status
    FROM   account_status
)
SELECT ROUND(1.0 * COUNT(account_id) / 
                   (SELECT COUNT(account_id) FROM CTE WHERE date = '2019-12-31' AND status = 'open')
        , 2) as percentage_closed
FROM   CTE
WHERE  date='2019-12-31'
       and status='open'
       and next_status='closed'



-- NOTE: solved on second attempt; initially wasn't using the WHERE condition in the subquery