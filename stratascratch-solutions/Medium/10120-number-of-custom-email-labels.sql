SELECT   to_user as user_id,
         label,
         COUNT(*) as n_occurences
FROM     google_gmail_emails e JOIN google_gmail_labels l ON e.id=l.email_id
WHERE    label ILIKE 'custom%'
GROUP BY to_user, label



-- NOTE: didn't put the WHERE condition initially.