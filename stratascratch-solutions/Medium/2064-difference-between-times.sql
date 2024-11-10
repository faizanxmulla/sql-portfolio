WITH combined_corpus as (
    SELECT *, 'male' as gender
    FROM   marathon_male
    UNION ALL
    SELECT *, 'female' as gender
    FROM   marathon_female
),
get_diff as (
    SELECT   gender, AVG(ABS(gun_time - net_time)) as avg_abs_diff
    FROM     combined_corpus
    GROUP BY 1
)
SELECT ABS(m.avg_abs_diff - f.avg_abs_diff) as abs_difference
FROM   get_diff m JOIN get_diff f ON m.gender = 'male' and f.gender = 'female'



-- alternate solution: (very easy)

SELECT
    (SELECT AVG(ABS(gun_time - net_time)) FROM marathon_female) -
    (SELECT AVG(ABS(gun_time - net_time)) FROM marathon_male)