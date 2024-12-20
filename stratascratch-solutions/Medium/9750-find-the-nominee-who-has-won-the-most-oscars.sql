WITH ranked_winners as (
    SELECT   nominee, 
             COUNT(*) as n_times_won,
             RANK() OVER(ORDER BY COUNT(*) desc) as rn
    FROM     oscar_nominees
    WHERE    winner='TRUE'
    GROUP BY nominee
)
SELECT nominee, n_times_won
FROM   ranked_winners
WHERE  rn=1



-- NOTE: solved on first attempt