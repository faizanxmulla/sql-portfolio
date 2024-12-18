SELECT   artist, COUNT(distinct song_name) as top10_songs_count
FROM     billboard_top_100_year_end
WHERE    year_rank <= 10
GROUP BY artist 
HAVING   COUNT(song_name) <> 0
ORDER BY top10_songs_count desc