SELECT   circulation_active_month,
         SUM(total_checkouts) as monthly_checkouts
FROM     library_usage
WHERE    home_library_definition = 'Main Library'
         and circulation_active_year = 2013
GROUP BY circulation_active_month
ORDER BY monthly_checkouts desc