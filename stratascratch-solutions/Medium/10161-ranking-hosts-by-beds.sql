SELECT   host_id, 
         SUM(n_beds) as number_of_beds,
         DENSE_RANK() OVER(ORDER BY SUM(n_beds) desc) as rank
FROM     airbnb_apartments
GROUP BY host_id
ORDER BY number_of_beds desc