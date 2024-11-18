SELECT d1.number as number1,
       d2.number as number2,
       CASE WHEN d1.number > d2.number THEN d1.number ELSE d2.number END as max_number 
FROM   deloitte_numbers d1 CROSS JOIN deloitte_numbers d2



-- NOTE: solved in first attempt