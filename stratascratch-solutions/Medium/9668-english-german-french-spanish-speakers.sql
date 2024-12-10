SELECT   company_id
FROM     playbook_users
WHERE    language IN ('english', 'german', 'french', 'spanish')
GROUP BY company_id
HAVING   COUNT(DISTINCT user_id) > 2



-- NOTE: wasn't using DISTINCT initially.