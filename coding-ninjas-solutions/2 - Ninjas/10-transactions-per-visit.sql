-- A bank wants to draw a chart of the number of transactions bank visitors did in one visit to the bank and the corresponding number of visitors who have done this number of transaction in one visit.

-- Write an SQL query to find how many users visited the bank and didn't do any transactions, how many visited the bank and did one transaction and so on.



WITH cte AS (
    SELECT
        v.user_id,
        v.visit_date,
        COUNT(t.amount) AS transactions_count
    FROM
        Visits v
        LEFT JOIN Transactions t ON v.user_id = t.user_id AND v.visit_date = t.transaction_date
    GROUP BY
        v.user_id,
        v.visit_date
),
max_transactions_count AS (
    SELECT MAX(transactions_count) AS max_count
    FROM cte
)
SELECT
    seq.transactions_count,
    COALESCE(count_visits.visits_count, 0) AS visits_count
FROM
    (SELECT
         x.n AS transactions_count
     FROM
         (SELECT 0 AS n UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3) x
         CROSS JOIN max_transactions_count
     WHERE
         x.n <= max_count) seq
    LEFT JOIN (
        SELECT
            transactions_count,
            COUNT(*) AS visits_count
        FROM
            cte
        GROUP BY
            transactions_count
    ) count_visits ON seq.transactions_count = count_visits.transactions_count
ORDER BY
    seq.transactions_count;



-- remarks: couldn't solve on own.