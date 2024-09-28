SELECT   EXTRACT(WEEK FROM date) as week_number, 
         COALESCE(AVG(CASE WHEN day_name='Friday' THEN amount_spent END), 0) as mean_amount
FROM     user_purchases
WHERE    EXTRACT(QUARTER FROM date) = 1 
         and EXTRACT(ISOYEAR from date) = 2023
GROUP BY 1


-- NOTE: ISO year may differ from the calendar year because the first week of the ISO year is defined as the week containing the first Thursday of the calendar year.