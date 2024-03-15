WITH total_plays
     AS (SELECT   user_id,
                  song_id,
                  song_plays
         FROM     songs_history
         UNION ALL
         SELECT   user_id,
                  song_id,
                  Count(song_id)
         FROM     songs_weekly
         WHERE    Date(listen_time) <= '2022-08-04'
         GROUP BY 1, 2)
SELECT   user_id,
         song_id,
         Sum(song_plays) AS song_plays
FROM     total_plays
GROUP BY 1, 2
ORDER BY 3 DESC; 