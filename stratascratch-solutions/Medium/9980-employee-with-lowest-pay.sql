WITH CTE as (
    SELECT LOWER(SPLIT_PART(employeename, ' ', 1)), totalpaybenefits
    FROM   sf_public_salaries
    WHERE  otherpay > basepay
)
SELECT lower, totalpaybenefits
FROM   CTE
WHERE  totalpaybenefits = (
        SELECT MIN(totalpaybenefits)
        FROM   CTE
    )