SELECT employeename
FROM   sf_public_salaries
WHERE  overtimepay = (
    SELECT MAX(overtimepay)
    FROM   sf_public_salaries
)