WITH unique_songs_per_user as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id, song_name ORDER BY date_played) as rn
    FROM   song_plays
)
,third_song_plays as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY user_id ORDER BY date_played) as rn2
    FROM   unique_songs_per_user
    WHERE  rn=1
)
,final_output as (
    SELECT user_id, date_played, song_name
    FROM   third_song_plays
    WHERE  rn2=3
)
SELECT u.name, f.date_played, song_name
FROM   users u LEFT JOIN final_output f ON u.id=f.user_id