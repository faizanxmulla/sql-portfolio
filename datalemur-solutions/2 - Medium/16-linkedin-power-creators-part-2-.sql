WITH power_creators as (
  SELECT pp.profile_id,
         pp.name as creator_name,
         pp.followers as creator_followers,
         cp.name as company_name,
         cp.followers as company_followers,
         CASE WHEN pp.followers > cp.followers THEN 1 ELSE 0 END as power_creator_flag
  FROM   employee_company as ec JOIN personal_profiles as pp ON ec.personal_profile_id = pp.profile_id                    
                                JOIN company_pages as cp ON ec.company_id = cp.company_id
)
SELECT   profile_id, creator_name
FROM     power_creators
GROUP BY 1, 2
HAVING   MIN(power_creator_flag) = 1
ORDER BY 1 



-- Solution 2: 

-- using MAX() aggregate function w/ window function // 
-- got this solving Ankit Bansal's Medium Complex Playlist - problem #06

WITH CTE as (
    SELECT pp.profile_id, 
           pp.name as creator_name, 
           pp.followers as personal_followers, 
           MAX(cp.followers) OVER(PARTITION BY pp.profile_id, pp.name) as max_company_followers
    FROM   personal_profiles pp JOIN employee_company ec ON pp.profile_id=ec.personal_profile_id 
                                JOIN company_pages cp USING(company_id)
)
SELECT   profile_id, creator_name
FROM     CTE
WHERE    personal_followers > max_company_followers
GROUP BY 1, 2