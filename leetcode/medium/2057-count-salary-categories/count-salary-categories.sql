WITH CTE AS (
    SELECT   CASE
                 WHEN income < 20000 THEN 'Low Salary' 
                 WHEN income > 50000 THEN 'High Salary'
                 ELSE 'Average Salary'
             END AS income_buckets,
             COUNT(account_id) as accounts_count
    FROM     Accounts
    GROUP BY 1
),
categories AS (
    SELECT * 
    FROM (
        VALUES
            ('Low Salary'),
            ('Average Salary'),
            ('High Salary')
    ) AS cat (category)
)
SELECT   category,
         COALESCE(accounts_count, 0) AS accounts_count
FROM     categories c LEFT JOIN CTE ct ON c.category = ct.income_buckets
ORDER BY 1



-- NOTE: didn't realize the need for categories CTE.

-- also initially didnt use LEFT JOIN. 

-- additional solution using UNION or UNION ALL.
-- also can use UNNEST. 


-- SELECT UNNEST(array['Low Salary', 'Average Salary', 'High Salary']) AS "category",
--        UNNEST(array[
--             SUM (CASE WHEN income < 20000 THEN 1 ELSE 0 END),
--             SUM (CASE WHEN income BETWEEN 20000 AND 50000 THEN 1 ELSE 0 END), 
--             SUM (CASE WHEN income > 50000 THEN 1 ELSE 0 END)
--         ]) AS "accounts_count"
-- FROM   Accounts