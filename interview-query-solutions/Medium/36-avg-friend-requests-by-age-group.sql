SELECT   age_group,
         ROUND(COUNT(ra.requester_id) / COUNT(DISTINCT ag.user_id)::decimal, 2) as average_acceptance
FROM     age_groups ag LEFT JOIN requests_accepted ra ON ag.user_id=ra.requester_id
GROUP BY age_group
ORDER BY average_acceptance desc



-- NOTE: didn't cast to decimal and didn't use LEFT JOIN in the initial attempt