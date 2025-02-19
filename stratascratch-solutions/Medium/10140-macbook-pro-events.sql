SELECT   company_id, language, COUNT(*) as n_macbook_pro_events
FROM     playbook_events e JOIN playbook_users u ON e.user_id=u.user_id
WHERE    location='Argentina'
         and device='macbook pro'
GROUP BY company_id, language