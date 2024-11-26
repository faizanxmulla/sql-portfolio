WITH filtered_claims AS (
    SELECT   account_id
    FROM     cvs_claims
    WHERE    date_submitted BETWEEN '2021-01-01' AND '2021-12-31'
    GROUP BY account_id
    HAVING   COUNT(claim_id) > 1
)
SELECT   ca.gender, ROUND(AVG(ca.age)) AS avg_age
FROM     filtered_claims fc JOIN cvs_accounts ca ON fc.account_id = ca.account_id
GROUP BY gender




-- my first solution: (getting wrong answer)

-- SELECT   gender, ROUND(AVG(age)) as avg_age
-- FROM     cvs_claims cc JOIN cvs_accounts ca ON cc.account_id=ca.account_id
-- WHERE    date_submitted BETWEEN '2021-01-01' and '2021-12-31'
-- GROUP BY gender
-- HAVING   COUNT(cc.claim_id) > 1