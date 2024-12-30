WITH ranked_earnings as (
    SELECT business_type, 
           adwords_earnings, 
           RANK() OVER(PARTITION BY business_type ORDER BY adwords_earnings) as rn
    FROM   google_adwords_earnings
)
SELECT business_type, adwords_earnings as minimal_earnings
FROM   ranked_earnings
WHERE  rn=1