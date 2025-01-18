SELECT   year_patron_registered,
         home_library_definition,
         MAX(total_checkouts) as total_checkouts_number
FROM     library_usage
WHERE    age_range = '65 to 74 years'
         and year_patron_registered = 2015
         and circulation_active_month = 'April'
GROUP BY year_patron_registered, home_library_definition
ORDER BY total_checkouts_number desc



-- NOTE: same as last; just change the filtering conditions and replace SUM by MAX.