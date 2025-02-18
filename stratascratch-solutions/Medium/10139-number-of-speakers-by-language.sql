SELECT   pe.location, pu.language, COUNT(distinct pu.user_id) as n_speakers
FROM     playbook_events pe JOIN playbook_users pu ON pe.user_id=pu.user_id
GROUP BY pe.location, pu.language
ORDER BY pe.location



-- NOTE: wasn't using "distinct" earlier