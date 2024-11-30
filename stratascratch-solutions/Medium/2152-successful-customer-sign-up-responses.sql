WITH ranked_customers_count as (
    SELECT   employee_id, 
             COUNT(REGEXP_MATCH(customer_response, '[0-9]{10}')) as cust_numbers,
             RANK() OVER(ORDER BY COUNT(REGEXP_MATCH(customer_response, '[0-9]{10}')) desc) as rn
    FROM     customer_responses
    GROUP BY employee_id
)
SELECT employee_id, cust_numbers
FROM   ranked_customers_count
WHERE  rn=1



-- NOTE: had to look up the syntax for REGEXP_MATCH() and also how to get 10-digit phone number.