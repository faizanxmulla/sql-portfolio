SELECT campaign_name,
       0.3 * (num_opens/num_users) + 0.7 * (num_clicks/num_users) as weighted_avg
FROM   email_campaigns



-- NOTE: solved on first attempt; rare easy problem in the Medium section