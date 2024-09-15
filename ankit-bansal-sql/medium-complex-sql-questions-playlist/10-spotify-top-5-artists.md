### Problem Statement

Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank table. 

Display the top 5 artist names in ascending order, along with their song appearance ranking.

**Link**: https://datalemur.com/questions/top-fans-rank 


### Solution Query

```sql
WITH CTE AS (
    SELECT   artist_name, 
             DENSE_RANK() over(ORDER BY COUNT(song_id) desc) as artist_rank 
    FROM     artists a JOIN songs s USING(artist_id)
                       JOIN global_song_rank g_rank USING(song_id)
    WHERE    g_rank.rank <= 10
    GROUP BY 1
)
SELECT artist_name, artist_rank
FROM   CTE
WHERE  artist_rank <= 5
```