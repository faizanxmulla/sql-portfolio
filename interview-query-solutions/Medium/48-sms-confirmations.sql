WITH latest_confirmations as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY country, carrier, phone_number ORDER BY ds desc) as rn
    FROM   sms_sends
    WHERE  type='confirmation'
)
SELECT   carrier, country, COUNT(*) as unique_numbers
FROM     latest_confirmations lc JOIN confirmers c 
ON       lc.phone_number=c.phone_number
         and lc.ds='2020-02-28'
         and lc.rn=1
GROUP BY carrier, country



-- NOTE: solved on own and in first attempt