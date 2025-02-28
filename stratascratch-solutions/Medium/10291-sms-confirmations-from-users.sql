SELECT 100.0 * COUNT(c.phone_number) / COUNT(s.phone_number) as perc
FROM   fb_sms_sends s LEFT JOIN fb_confirmers c ON s.ds=c.date and s.phone_number=c.phone_number
WHERE  s.ds='2020-08-04' and s.type='message'