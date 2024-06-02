-- SELECT *, RANK() OVER(ORDER BY salary DESC) AS rn
-- FROM   employee

SELECT MAX(salary) AS hightest_salary
FROM   employee


-- remarks: the problem being in the HARD section, i thought that it would be that easy (i.e. to use MAX), so was lured into thinking of using RANK().