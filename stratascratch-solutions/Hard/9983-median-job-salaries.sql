SELECT   jobtitle,
         PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY totalpay) as median_salary
FROM     sf_public_salaries
GROUP BY 1
ORDER BY 2 DESC  