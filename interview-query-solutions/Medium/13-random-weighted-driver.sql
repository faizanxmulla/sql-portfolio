WITH cumulative_weights AS (
    SELECT id,
           SUM(weighting) OVER(ORDER BY id) AS cumulative_weight,
           SUM(weighting) OVER() AS total_weight
    FROM   drivers
)
SELECT   id
FROM     cumulative_weights
WHERE    cumulative_weight >= (
            SELECT rand() * total_weight 
            FROM   cumulative_weights 
            LIMIT  1
        )
ORDER BY cumulative_weight
LIMIT    1



-- NOTE: 

-- interesting and unique question. initially didnt have any idea how to even begin the question.
-- use rand() in MySQL and random() in PostgresSQL.

-- for detailed explanation, here is the ChatGPT chat link: 
-- https://chatgpt.com/share/75b6430e-0120-49ec-aba2-be006f4d8d32