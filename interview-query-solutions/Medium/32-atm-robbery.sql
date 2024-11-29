SELECT   a.user_id
FROM     bank_transactions a JOIN bank_transactions b ON a.user_id <> b.user_id
WHERE    EXTRACT(EPOCH FROM AGE(b.created_at, a.created_at)) = 10
         or EXTRACT(EPOCH FROM AGE(a.created_at, b.created_at)) = 10
GROUP BY 1
ORDER BY 1


-- OR more optimized version (by combining the both conditions)

SELECT   a.user_id
FROM     bank_transactions a JOIN bank_transactions b ON a.user_id <> b.user_id
WHERE    ABS(EXTRACT(EPOCH FROM (b.created_at - a.created_at))) = 10
GROUP BY 1
ORDER BY 1



-- my first attempt

SELECT   a.user_id, b.user_id
FROM     bank_transactions a JOIN bank_transactions b ON a.user_id <> b.user_id
WHERE    EXTRACT(EPOCH FROM AGE(b.created_at, a.created_at)) = 10



-- NOTE: was not considering the second case