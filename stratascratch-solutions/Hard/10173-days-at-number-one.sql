WITH us_top_tracks AS (
    SELECT trackname, 
           artist, 
           date, 
           LEAD(date) OVER (ORDER BY date) AS until,
           LEAD(date) OVER (ORDER BY date) - date AS diff
    FROM   spotify_daily_rankings_2017_us
    WHERE  position = 1
),
worldwide_top_us_tracks AS (
    SELECT trackname, 
           artist, 
           date, 
           LEAD(date) OVER (ORDER BY date) AS until,
           LEAD(date) OVER (ORDER BY date) - date AS diff,
           region
    FROM   spotify_worldwide_daily_song_ranking
    WHERE  position = 1 AND region = 'us'
),
us_individual_days AS (
    SELECT trackname, 
           artist, 
           date + generate_series(0, diff - 1) AS individual_dates
    FROM   us_top_tracks
    WHERE  diff IS NOT NULL
),
worldwide_individual_days AS (
    SELECT trackname, 
           artist, 
           date + generate_series(0, diff - 1) AS individual_dates
    FROM   worldwide_top_us_tracks
    WHERE  diff IS NOT NULL
)
SELECT   uid.trackname,
         uid.artist, 
         COUNT(uid.individual_dates) AS days_as_position1_both_us_and_world
FROM     us_individual_days uid JOIN worldwide_individual_days wid USING(trackname, artist, individual_dates)
GROUP BY 1, 2
ORDER BY 1


-- corresponding result set: 

-- trackname	artist	days_as_position1_both_us_and_world
-- Bad and Boujee (feat. Lil Uzi Vert)	Migos	13
-- HUMBLE.	Kendrick Lamar	48



-- my attempt: (getting the trackname and artist name correct, but not the number of days)


WITH us_position_1_tracks AS (
    SELECT   date, 
             trackname,
             artist
    FROM     spotify_daily_rankings_2017_us 
    WHERE    position=1
),
wr_position_1_tracks AS (
    SELECT   date, 
             trackname,
             artist
    FROM     spotify_worldwide_daily_song_ranking
    WHERE    position=1 AND region='us'
)
SELECT   us.trackname, us.artist, COUNT(*) AS number_of_days
FROM     us_position_1_tracks us JOIN wr_position_1_tracks wr USING(date, trackname, artist)
GROUP BY 1, 2
ORDER BY 1, 2


-- corresponding result set: 

-- trackname	artist	number_of_days
-- Bad and Boujee (feat. Lil Uzi Vert)	Migos	1
-- HUMBLE.	Kendrick Lamar	3