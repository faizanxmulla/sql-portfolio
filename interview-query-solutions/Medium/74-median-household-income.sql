WITH ranked_responses as (
    SELECT city, 
           household_income,
           ROW_NUMBER() OVER(PARTITION BY city ORDER BY household_income) as rn,
           COUNT(*) OVER(PARTITION BY city) as total_count
    FROM   survey_responses
)
SELECT   city, AVG(household_income) as median_income
FROM     ranked_responses
WHERE    rn in (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY city