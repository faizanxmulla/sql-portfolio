SELECT   year_patron_registered,
         home_library_definition,
         SUM(total_checkouts) as total_checkouts_number
FROM     library_usage
WHERE    patron_type_definition='ADULT' 
         and year_patron_registered=2010
GROUP BY year_patron_registered, home_library_definition
ORDER BY total_checkouts_number desc
LIMIT    1