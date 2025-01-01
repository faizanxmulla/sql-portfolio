WITH CTE as (
    SELECT number, 
           ROW_NUMBER() OVER(ORDER BY number) as rn,
           ROW_NUMBER() OVER(ORDER BY number desc) as rn_desc
    FROM   transportation_numbers
)
SELECT MIN(number), MAX(number), SUM(number) FILTER(WHERE rn<>1 and rn_desc<>1)
FROM   CTE 



-- my initial attempt; good idea but not proper execution

WITH CTE as (
    SELECT MIN(number) as min, MAX(number) as max
    FROM   transportation_numbers
)
SELECT min, max, SUM(number)
FROM   CTE
WHERE  number NOT IN (min, max)




-- NOTE: solved w/o any help; this solution is more efficient than the one in the 'Solution' section.