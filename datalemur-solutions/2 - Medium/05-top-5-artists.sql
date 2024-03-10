-- Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. 

-- Display the top 5 artist names in ascending order, along with their song appearance ranking.

-- If two or more artists have the same number of song appearances, they should be assigned the same ranking, and the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5).



WITH CTE AS (
    SELECT   artist_name, 
             dense_rank() over(order by count(song_id) desc) as artist_rank 
    FROM     artists a JOIN songs s USING(artist_id)
                   JOIN global_song_rank g_rank USING(song_id)
    WHERE    g_rank.rank <= 10
    GROUP BY 1
)
SELECT artist_name, artist_rank
FROM   CTE
WHERE  artist_rank <= 5


-- remarks: didnt do the "artist_rank <= 5" part.