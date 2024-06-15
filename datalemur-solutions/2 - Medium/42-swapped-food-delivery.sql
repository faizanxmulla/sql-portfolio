WITH max_order_id_cte AS (
    SELECT MAX(order_id) AS max_order_id
    FROM   orders
),
excluded_max_order_id_cte AS (
    SELECT *
    FROM   orders
    WHERE  order_id != (SELECT max_order_id 
                        FROM max_order_id_cte
                    )
),
swapped_orders_cte AS (
    SELECT CASE 
            WHEN order_id % 2 = 0 THEN order_id - 1
            ELSE order_id + 1
            END AS corrected_order_id,
            item
    FROM   excluded_max_order_id_cte
),
final_orders AS (
    SELECT corrected_order_id, item
    FROM   swapped_orders_cte
    UNION ALL
    SELECT order_id, item
    FROM   orders
    WHERE  order_id = (SELECT max_order_id FROM max_order_id_cte) AND 
            order_id % 2 != 0
)
SELECT   corrected_order_id, item
FROM     final_orders
ORDER BY 1



-- my approach : 
-- was able to swap records, but couldnt come up with a way to join the max odd record to the final result set. 


WITH max_excluded_orders_cte AS (
  SELECT *
  FROM   orders 
  WHERE  order_id != (SELECT MAX(order_id)
                      FROM   orders )
)
SELECT   CASE WHEN order_id %2=0 THEN order_id-1
              ELSE order_id +1 
         END AS corrected_order_id,
         item
FROM     max_excluded_orders_cte
ORDER BY 1
