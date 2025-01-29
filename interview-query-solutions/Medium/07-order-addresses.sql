SELECT ROUND(1.0 * COUNT(t.id) FILTER(WHERE shipping_address=address) / COUNT(t.id), 2) as home_address_percent
FROM   users u JOIN transactions t ON u.id=t.user_id::int


-- NOTE: solved in first attempt.