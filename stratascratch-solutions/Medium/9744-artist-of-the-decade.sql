SELECT   artist, COUNT(*) as count_20yrs
FROM     billboard_top_100_year_end
WHERE    DATE_PART('year', CURRENT_DATE) - year <= 20
GROUP BY artist
ORDER BY count_20yrs desc