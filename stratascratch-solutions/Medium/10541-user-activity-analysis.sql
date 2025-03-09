SELECT   a.user_id, p.signup_date, COUNT(*) as activity_count
FROM     user_profiles p RIGHT JOIN user_activities a ON p.user_id=a.user_id
WHERE    activity_date - signup_date <= 30
GROUP BY a.user_id, p.signup_date



-- NOTE: was earlier trying to do: activity_date - signup_date <= INTERVAL '30 days'