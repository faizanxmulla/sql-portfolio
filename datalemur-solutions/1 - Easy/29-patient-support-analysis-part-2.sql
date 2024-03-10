-- UnitedHealth Group has a program called Advocate4Me, which allows members to call an advocate and receive support for their health care needs – whether that's behavioural, clinical, well-being, health care financing, benefits, claims or pharmacy help.

-- Calls to the Advocate4Me call centre are categorised, but sometimes they can't fit neatly into a category. These uncategorised calls are labelled “n/a”, or are just empty (when a support agent enters nothing into the category field).

-- Write a query to find the percentage of calls that cannot be categorised. Round your answer to 1 decimal place.


-- Solution 1: 

SELECT round (100.0 * Count (case_id) filter (WHERE call_category IS NULL OR call_category = 'n/a') / count  (case_id), 1) AS uncategorised_call_pct
FROM   callers;


-- Solution 2: using CTE

WITH uncategorised_calls AS (
  SELECT COUNT(case_id) AS call_count
  FROM   callers
  WHERE  call_category IS NULL or call_category = 'n/a'
)
SELECT   ROUND(100.0 * call_count / (SELECT COUNT(*) FROM callers), 1) AS uncategorised_call_pct
FROM     uncategorised_calls
GROUP BY call_count;



-- my approach: giving output as null.

SELECT ROUND(100.0 * sum(case when call_category is null or call_category='n/a' then 1 else 0 end)/ COUNT(*), 1) as call_percentage
FROM   callers


-- remarks: 


