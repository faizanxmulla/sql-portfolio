SELECT   COUNT(DISTINCT l1.liker_id) as count, l2.liker_id as user
FROM     likes l1 JOIN likes l2 ON l1.user_id=l2.liker_id
GROUP BY 2
ORDER BY 2


-- NOTE: was not using DISTINCT earlier.