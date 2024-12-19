SELECT   artist, 
         AVG(year_rank) as average_rank,
         COUNT(DISTINCT year) as years_present,
         (100 - AVG(year_rank)) * COUNT(DISTINCT year) as score
FROM     billboard_top_100_year_end
WHERE    DATE_PART('year', CURRENT_DATE) - year <= 20
GROUP BY artist
ORDER BY score desc