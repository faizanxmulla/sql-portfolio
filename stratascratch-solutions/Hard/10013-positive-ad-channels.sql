SELECT   advertising_channel, 
         MAX(money_spent) AS max_yearly_spending
FROM     uber_advertising
WHERE    customers_acquired > 1500
GROUP BY 1
ORDER BY 2
LIMIT    1