SELECT   pp.profile_id
FROM     personal_profiles AS pp INNER JOIN company_pages AS cp ON pp.employer_id = cp.company_id
WHERE    pp.followers > cp.followers
ORDER BY 1