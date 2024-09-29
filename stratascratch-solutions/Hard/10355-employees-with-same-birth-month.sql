SELECT   profession AS department,
         SUM(CASE WHEN birth_month = 1 THEN 1 ELSE 0 END) AS Month_1,
         SUM(CASE WHEN birth_month = 2 THEN 1 ELSE 0 END) AS Month_2,
         SUM(CASE WHEN birth_month = 3 THEN 1 ELSE 0 END) AS Month_3,
         SUM(CASE WHEN birth_month = 4 THEN 1 ELSE 0 END) AS Month_4,
         SUM(CASE WHEN birth_month = 5 THEN 1 ELSE 0 END) AS Month_5,
         SUM(CASE WHEN birth_month = 6 THEN 1 ELSE 0 END) AS Month_6,
         SUM(CASE WHEN birth_month = 7 THEN 1 ELSE 0 END) AS Month_7,
         SUM(CASE WHEN birth_month = 8 THEN 1 ELSE 0 END) AS Month_8,
         SUM(CASE WHEN birth_month = 9 THEN 1 ELSE 0 END) AS Month_9,
         SUM(CASE WHEN birth_month = 10 THEN 1 ELSE 0 END) AS Month_10,
         SUM(CASE WHEN birth_month = 11 THEN 1 ELSE 0 END) AS Month_11,
         SUM(CASE WHEN birth_month = 12 THEN 1 ELSE 0 END) AS Month_12
FROM     employee_list
GROUP BY 1
ORDER BY 1


