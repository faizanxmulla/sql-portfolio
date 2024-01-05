SELECT DATE_FORMAT(trans_date, '%Y-%m') as month, 
       country, 
       COUNT(id) as trans_count,
       COUNT(IF(state='approved', 1, NULL))as approved_count,
       SUM(amount) as trans_total_amount, 
       SUM(IF(state='approved', amount, 0)) as approved_total_amount

FROM Transactions 
GROUP BY 1, 2


# can extract month usnig the follwing methods : (2nd and 4th --> good)

# 1. LEFT(trans_date, 7)
# 2. DATE_FORMAT(trans_date, '%Y-%m')
# 3. CONCAT(Year(trans_date),'-',LPAD(Month(trans_date),2,'0'))
# 4. SUBSTRING(trans_date,1,7)

# also instead of IF, we can use {CASE, WHEN, THEN, ELSE, END}. 

# also this can be used : SUM(state="approved") as approved_count