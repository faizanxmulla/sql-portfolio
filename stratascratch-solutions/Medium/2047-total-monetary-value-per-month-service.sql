SELECT   EXTRACT(MONTH FROM order_date) as month,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_BOX') AS Uber_BOX,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_CLEAN') AS Uber_CLEAN,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_FOOD') AS Uber_FOOD,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_GLAM') AS Uber_GLAM,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_KILAT') AS Uber_KILAT,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_MART') AS Uber_MART,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_MASSAGE') AS Uber_MASSAGE,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_RIDE') AS Uber_RIDE,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_SEND') AS Uber_SEND,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_SHOP') AS Uber_SHOP,
         SUM(monetary_value) FILTER (WHERE service_name = 'Uber_TIX') AS Uber_TIX
FROM     uber_orders
WHERE    status_of_order = 'Completed'
GROUP BY 1



-- NOTE: feels like there should be a better of solving this problem. can use "CROSSTAB"