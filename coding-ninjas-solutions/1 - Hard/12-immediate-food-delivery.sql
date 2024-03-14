-- If the preferred delivery date of the customer is the same as the order date then the order is called immediate otherwise it's called scheduled.

-- The first order of a customer is the order with the earliest order date that customer made. It is guaranteed that a customer has exactly one first order.

-- Write an SQL query to find the percentage of immediate orders in the first orders of all customers, rounded to 2 decimal places.


WITH ranked_orders
     AS (SELECT *,
                Rank()
                  OVER(
                    partition BY customer_id
                    ORDER BY order_date) AS rank
         FROM   delivery)
SELECT Round(100.0 * Sum(CASE
                           WHEN order_date = customer_pref_delivery_date THEN 1
                           ELSE 0
                         END) / Count(DISTINCT customer_id), 2) AS
       immediate_percentage
FROM   ranked_orders
WHERE  rank = 1 



-- remarks: couldn't figure out "SUM() then 1 else 0" part.