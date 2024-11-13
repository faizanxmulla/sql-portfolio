SELECT 100.0 * SUM(CASE WHEN contract_end < '2021-09-30' THEN 1 ELSE 0 END) /
       COUNT(*) as churn_rate
FROM   natera_subscriptions
WHERE  contract_start <= '2021-09-01' and (contract_end >= '2021-09-01' or contract_end IS NULL)



-- solution 2: easier to understand

WITH CTE as (
    SELECT user_id,
           CASE WHEN contract_start <= '2021-09-01' THEN 1 END as client,
           CASE WHEN contract_end >= '2021-09-30' or contract_end IS NULL THEN 1 END as churn
    FROM   natera_subscriptions
)
SELECT 100 * (SUM(client) - SUM(churn)) / SUM(client) as churn 
FROM   CTE
WHERE  client IS NOT NULL



-- NOTE: couldnt figure out the second condition of the question.