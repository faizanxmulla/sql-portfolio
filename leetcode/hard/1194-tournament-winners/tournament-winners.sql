WITH match_winner AS (
    SELECT   group_id, 
             player_id,
             SUM(CASE 
                    WHEN m.first_player = p.player_id THEN m.first_score 
                    WHEN m.second_player = p.player_id THEN m.second_score 
                    ELSE 0 
                 END) AS total_score
    FROM     players p LEFT JOIN matches m on p.player_id IN (m.first_player, m.second_player)
    GROUP BY 1, 2
),
ranked_scores_cte AS (
    SELECT group_id, 
           player_id,
           RANK() OVER(PARTITION BY group_id ORDER BY total_score DESC, player_id) as rn
    FROM   match_winner
)
SELECT group_id, 
       player_id
FROM   ranked_scores_cte
WHERE  rn=1