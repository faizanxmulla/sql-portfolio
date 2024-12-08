SELECT   year_rank as rank, group_name, song_name
FROM     billboard_top_100_year_end
WHERE    year=1956
ORDER BY year_rank 
LIMIT    10



-- NOTE: very easy; should not even be in Medium section