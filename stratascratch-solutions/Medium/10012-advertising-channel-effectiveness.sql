SELECT   advertising_channel, SUM(money_spent) / SUM(customers_acquired) as avg_effectiveness
FROM     uber_advertising 
WHERE    year IN (2017, 2018)
GROUP BY advertising_channel