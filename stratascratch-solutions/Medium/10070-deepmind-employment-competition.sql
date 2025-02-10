SELECT   p.team_id, AVG(s.member_score) as team_score
FROM     google_competition_participants p JOIN google_competition_scores s 
ON       p.member_id = s.member_id
GROUP BY p.team_id
ORDER BY team_score desc