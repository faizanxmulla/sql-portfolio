WITH hist as (
    SELECT   u.id, COUNT(c.user_id) AS frequency
    FROM     users u LEFT JOIN comments c ON u.id=c.user_id
    GROUP BY 1
),
freq as (
    SELECT   frequency, COUNT(*) AS num_users
    FROM     hist
    GROUP BY 1
)
SELECT   f1.frequency, SUM(f2.num_users) AS cum_total
FROM     freq f1 LEFT JOIN freq f2 ON f1.frequency >= f2.frequency
GROUP BY 1



-- NOTE: was easy in hindsight but couldn't figure out on own.