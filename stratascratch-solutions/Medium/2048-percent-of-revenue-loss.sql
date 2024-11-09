WITH CTE as (
    SELECT   service_name, 
             SUM(number_of_orders) as total_orders,
             SUM(number_of_orders) FILTER(WHERE status_of_order != 'Completed') as lost_orders,
             SUM(monetary_value) as profit,
             SUM(monetary_value) FILTER(WHERE status_of_order != 'Completed') as lost_profit
    FROM     uber_orders
    GROUP BY 1
)
SELECT service_name, 
       100 * (lost_orders / total_orders) as orders_loss_percent,
       100 * (lost_profit / profit) as profit_loss_percent
FROM   CTE



-- NOTE: solved in first attempt