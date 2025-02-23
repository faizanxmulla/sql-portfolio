SELECT   id_guest, 
         SUM(n_messages) as sum_n_messages,
         DENSE_RANK() OVER(ORDER BY SUM(n_messages) desc) as ranking
FROM     airbnb_contacts
GROUP BY id_guest
ORDER BY sum_n_messages desc