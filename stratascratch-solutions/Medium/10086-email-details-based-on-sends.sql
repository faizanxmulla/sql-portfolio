WITH CTE as (
    SELECT   day
    FROM     google_gmail_emails
    GROUP BY day
    HAVING   COUNT(distinct to_user) > COUNT(distinct from_user)
)
SELECT g.id, g.from_user, g.to_user, c.day
FROM   google_gmail_emails g JOIN CTE c ON g.day=c.day



-- NOTE: couldn't first solve this on my own; but didn't put enough thought into it too.