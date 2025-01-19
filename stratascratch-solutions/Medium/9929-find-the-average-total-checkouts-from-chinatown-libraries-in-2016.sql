SELECT AVG(total_checkouts) as avg_total_checkouts
FROM   library_usage
WHERE  home_library_definition = 'Chinatown'
       and circulation_active_year = 2016