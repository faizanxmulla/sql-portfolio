SELECT   company_name, 
         COUNT(*) FILTER(WHERE year='2020') - COUNT(*) FILTER(WHERE year='2019') as net_difference
FROM     car_launches
GROUP BY company_name