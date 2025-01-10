SELECT   pe.location, COUNT(*) as n_logins
FROM     playbook_users pu JOIN playbook_events pe ON pu.user_id=pe.user_id 
WHERE    pe.event_name='login'
         and pu.language='spanish'
GROUP BY pe.location
ORDER BY COUNT(*) desc