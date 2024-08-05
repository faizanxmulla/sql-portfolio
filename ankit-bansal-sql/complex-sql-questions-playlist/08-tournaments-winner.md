### Problem Statement | [Leetcode Link](https://leetcode.com/problems/tournament-winners/description/)

The winner in each group is the player who scored the maximum total points within the group. In the case of a tie, the lowest player_id wins.

**Write an SQL query to find the winner in each group.**

### Solution Query

```sql
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
SELECT group_id, player_id
FROM   ranked_scores_cte
WHERE  rn=1
```