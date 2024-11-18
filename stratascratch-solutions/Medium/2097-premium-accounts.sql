SELECT   a.entry_date,
         COUNT(a.account_id) as premium_paid_accounts,
         COUNT(b.account_id) as premum_accounts_a_week_from_today
FROM     premium_accounts_by_day a LEFT JOIN premium_accounts_by_day b
ON       a.account_id=b.account_id
         and b.entry_date - a.entry_date = 7
         and b.final_price > 0
WHERE    a.final_price > 0
GROUP BY 1
ORDER BY 1
LIMIT    7



-- NOTE: couldn't solve entirely on my own; couldn't understand the question itself for the "7 days later" part.