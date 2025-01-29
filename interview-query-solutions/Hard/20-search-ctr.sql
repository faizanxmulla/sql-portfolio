WITH CTE as (
    SELECT   rating, 
             SUM(CASE WHEN has_clicked=TRUE THEN 1 ELSE 0 END) as total_clicks,
             COUNT(has_clicked) as total_results
    FROM     search_results sr JOIN search_events se ON sr.query=se.query
    GROUP BY rating
)
SELECT   rating, ROUND(100.0 * total_clicks/total_results, 2) as percent_ctr
FROM     CTE
ORDER BY rating



-- open ended question

-- basically has to perform Hypothesis testing to test whether an increase in rating correlates to increase in CTR.

-- here is the result: 
-- rating	percent_ctr
-- 1	55.56
-- 2	50.29
-- 3	45.71
-- 4	43.75
-- 5	51.3

-- conclusion:

-- The data partially supports the hypothesis that CTR depends on rating, as CTR is generally higher for the extreme ratings (1 and 5). However, the relationship is not strictly linear, likely due to a combination of user behavior, position bias, and data quality issues.

-- Further investigation might include:

-- - Analyzing CTR by both rating and position.
-- - Checking the accuracy of ratings assigned to results.
-- - Evaluating if there are external factors influencing user clicks