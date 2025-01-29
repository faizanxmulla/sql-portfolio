WITH ranked_artists as (
    SELECT   artist, 
             COUNT(distinct trackname) as no_top10,
             RANK() OVER(ORDER BY COUNT(distinct trackname) desc) as rn
    FROM     spotify_worldwide_daily_song_ranking
    WHERE    position <= 10
    GROUP BY artist
)
SELECT artist, no_top10
FROM   ranked_artists
WHERE  rn=1