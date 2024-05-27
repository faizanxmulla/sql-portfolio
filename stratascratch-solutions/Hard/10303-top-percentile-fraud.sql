WITH percentile_cte AS (
    SELECT state, PERCENTILE_CONT(0.05) WITHIN GROUP(ORDER BY fraud_score DESC) as percentile
    FROM   fraud_score
    GROUP BY 1
)
SELECT policy_num, f.state, claim_cost, fraud_score
FROM   fraud_score f JOIN percentile_cte p USING(state)
WHERE  fraud_score >= percentile