-- Given a table NUMBERS, determine for each row, if the sum of the numbers are ‘Positive’, ‘Negative’, or ‘Zero’.
-- Note: Output should be printed with column name A.

SELECT CASE WHEN A+B+C > 0 THEN 'Positive' WHEN A+B+C < 0 THEN 'Negative' ELSE 'Zero' END AS A
FROM NUMBERS


-- REMARKS: 
-- didnt see input table properly.