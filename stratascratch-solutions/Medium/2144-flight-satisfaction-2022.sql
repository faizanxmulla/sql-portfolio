SELECT   class, ROUND(AVG(satisfaction)) as pc_score
FROM     survey_results sr JOIN loyalty_customers lc ON sr.cust_id=lc.cust_id
WHERE    age BETWEEN 30 and 40
GROUP BY class



-- NOTE: very easy; solved on first attempt