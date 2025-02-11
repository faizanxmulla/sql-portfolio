WITH ranked_scores as (
    SELECT distinct from_user, 
           nationality,
           RANK() OVER(PARTITION BY from_user ORDER BY review_score desc) as rn 
    FROM   airbnb_reviews r JOIN airbnb_hosts h ON r.to_user=h.host_id
    WHERE  from_type='guest'
)
SELECT   from_user, nationality
FROM     ranked_scores
WHERE    rn=1
ORDER BY from_user