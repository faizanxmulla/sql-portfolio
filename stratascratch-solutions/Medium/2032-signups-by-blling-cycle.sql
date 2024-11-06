SELECT   EXTRACT(DOW FROM signup_start_date) as weekday, 
         COUNT(signup_id) FILTER(WHERE billing_cycle='annual') as annual,
         COUNT(signup_id) FILTER(WHERE billing_cycle='monthly') as monthly,
         COUNT(signup_id) FILTER(WHERE billing_cycle='quarterly') as quarterly
FROM     signups s JOIN plans p ON s.plan_id=p.id
GROUP BY 1