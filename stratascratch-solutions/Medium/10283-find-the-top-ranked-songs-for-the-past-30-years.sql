SELECT distinct song_name
FROM   billboard_top_100_year_end
WHERE  date_part('year', CURRENT_DATE) - year <= 20
       and year_rank=1