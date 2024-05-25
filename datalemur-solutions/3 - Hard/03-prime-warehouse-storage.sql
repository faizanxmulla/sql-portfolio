WITH summary AS (  
    SELECT   item_type,  
             SUM(square_footage) AS total_sqft,  
             COUNT(*) AS item_count  
    FROM     inventory  
    GROUP BY 1
),
prime_occupied_area AS (  
    SELECT item_type,
           total_sqft,
           FLOOR(500000 / total_sqft) AS prime_item_batch_count,
           FLOOR(500000 / total_sqft) * item_count AS prime_item_count
    FROM  summary  
    WHERE item_type = 'prime_eligible'
)
SELECT   item_type,
         CASE 
            WHEN item_type = 'prime_eligible' THEN (FLOOR(500000 / total_sqft) * item_count)
            WHEN item_type = 'not_prime' THEN FLOOR((500000 - (
                                                    SELECT FLOOR(500000 / total_sqft) * total_sqft 
                                                    FROM   prime_occupied_area)
                                                ) /  total_sqft) * item_count
         END AS item_count
FROM     summary
ORDER BY 1 DESC;