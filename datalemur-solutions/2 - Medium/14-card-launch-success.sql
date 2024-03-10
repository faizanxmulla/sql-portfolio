-- Write a query that outputs the name of the credit card, and how many cards were issued in its launch month. 

-- The launch month is the earliest record in the monthly_cards_issued table for a given card. 
-- Order the results starting from the biggest issued amount.



with launch_month as (
    SELECT *, RANK() OVER(PARTITION BY card_name ORDER BY issue_year, issue_month) 
    FROM   monthly_cards_issued
)
SELECT   card_name, issued_amount
FROM     launch_month
WHERE    rank=1
ORDER BY 2 desc


-- remarks: solved in first attempt; again suprisingly easy problem in "Medium" section.