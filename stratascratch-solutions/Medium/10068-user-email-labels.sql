SELECT   to_user,
         COUNT(*) FILTER(WHERE label='Promotion') as promotion_count,
         COUNT(*) FILTER(WHERE label='Social') as social_count,
         COUNT(*) FILTER(WHERE label='Shopping') as shopping_count
FROM     google_gmail_emails e JOIN google_gmail_labels l ON e.id=l.email_id
GROUP BY to_user