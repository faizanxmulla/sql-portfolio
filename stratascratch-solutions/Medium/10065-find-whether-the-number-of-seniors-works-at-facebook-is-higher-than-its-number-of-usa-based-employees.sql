SELECT CASE
           WHEN COUNT(distinct id) FILTER(WHERE location='USA') > COUNT(distinct id) FILTER(WHERE is_senior='True')
           THEN 'More USA-based' ELSE 'More seniors'
       END as winner
FROM   facebook_employees