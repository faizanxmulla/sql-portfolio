-- Assume today's date is '2021-1-1'.

-- Write an SQL query that will, for each user_id, find out the largest window of days between each visit and the one right after it (or today if you are considering the last visit).

-- Return the result table ordered by user_id.



WITH CTE as (
    SELECT *, 
           LEAD(visit_date) OVER(PARTITION BY user_id ORDER BY visit_date)  as next
    FROM   UserVisits
)

SELECT   user_id, 
         MAX(COALESCE(next, '2021-1-1') - visit_date) as biggest_window
FROM     CTE
GROUP BY 1
ORDER BY 1



-- my approach: 

SELECT   user_id, 
         CASE WHEN COUNT(visit_date)=1 THEN '2021-1-1'::DATE - visit_date::DATE ELSE max(visit_date) - min(visit_date) END as biggest_window
FROM     UserVisits
GROUP BY 1
ORDER BY 1


-- remarks: max(visit_date) - min(visit_date) --> this takes care of everything except the '2021-1-1' condition. 