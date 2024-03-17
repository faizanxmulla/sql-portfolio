SELECT  id, 
        COALESCE(CASE WHEN mod(id, 2) = 0 THEN LAG(student) OVER(ORDER BY id)
                      WHEN mod(id, 2) = 1 THEN LEAD(student) OVER(ORDER BY id) END, student) as student
FROM    Seat


-- other approaches : accepted in MySQL, but not in PostgreSQL.

-- SELECT   ROW_NUMBER() OVER(ORDER BY IF(MOD(id, 2) = 0, id-1, id+1)) id, student
-- FROM     seat



-- remarks: 
-- - correctly thought of using LAG and LEAD , but couldnt figure out to use CASE statements like this.
-- - exact same question in the "Hard" section of coding-ninjas.