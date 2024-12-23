WITH ranked_occurences as (
    SELECT   reaction, 
             COUNT(*) as n_occurences,
             RANK() OVER(ORDER BY COUNT(*) desc) as rn
    FROM     facebook_reactions
    WHERE    date_day=1
    GROUP BY reaction
)
SELECT reaction, n_occurences
FROM   ranked_occurences
WHERE  rn=1