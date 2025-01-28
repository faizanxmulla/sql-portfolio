SELECT   trackname, COUNT(*) as times_top1
FROM     spotify_worldwide_daily_song_ranking
WHERE    position=1
GROUP BY trackname
ORDER BY times_top1 desc