-- Write an SQL query to find the prices of all products on 2019-08-16. 

-- Assume the price of all products before any change is 10.



select   product_id, 
         COALESCE(MAX(CASE WHEN change_date <= '2019-08-16' THEN new_price ELSE NULL END), 10) AS price
from     products
group by 1
order by 2 desc


-- another approach: 

max(CASE WHEN EXTRACT(day from change_date) <= 16 THEN new_price ELSE '10' END) as price


-- remarks: didnt use "max"; rest everything was done by self.

