SELECT pu.user_id, pu.language, pe.location
FROM   playbook_experiments pe JOIN playbook_users pu ON pe.user_id=pu.user_id
WHERE  location='Italy' 
       and language <> 'italian'
       and pe.device='nexus 5'
       and pe.experiment_group='control_group'



-- NOTE: solved on first attempt