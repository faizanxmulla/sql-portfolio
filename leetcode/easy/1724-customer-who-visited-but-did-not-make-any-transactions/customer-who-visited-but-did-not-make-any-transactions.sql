SELECT v.customer_id, COUNT(v.visit_id) AS count_no_trans
FROM Visits v LEFT JOIN Transactions t ON v.visit_id = t.visit_id
WHERE t.transaction_id IS NULL
GROUP BY 1


# alternate WHERE condition --> WHERE t.amount IS NULL 

# alternate solutions : 

# 1. Subquery : "NOT EXISTS"

# SELECT customer_id, COUNT(visit_id) as count_no_trans 
# FROM Visits v
# WHERE NOT EXISTS (
# 	SELECT visit_id FROM Transactions t 
# 	WHERE t.visit_id = v.visit_id
# 	)
# GROUP BY customer_id


# 2. Subquery : "NOT IN"

# SELECT customer_id, COUNT(visit_id) as count_no_trans 
# FROM Visits
# WHERE visit_id NOT IN (
# 	SELECT visit_id FROM Transactions
# 	)
# GROUP BY customer_id