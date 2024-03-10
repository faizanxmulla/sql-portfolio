-- A chess tournament is being held which consists of several matches between a player and a computer. After every match one player is declared as the winner.

-- You are given two tables, One table consists of the players that will be playing the tournament while the other table consists of the matches that will be played in the tournament and its Result. The Result would be 1 if the player won the match, 0 otherwise. You have to output the names of the players who have won atleast one match and lost atmost one match.



-- Solution 1 : 

SELECT   p.Name as Name
FROM     Matches m JOIN Players p ON m.Id=p.Id
GROUP BY p.Id
HAVING   SUM(m.Result) >= 1 and COUNT(*) - SUM(m.Result) <= 1;


-- Solution 2: 

SELECT NAME
FROM   players
WHERE  id IN(SELECT   id
             FROM     matches
             GROUP BY id
             HAVING   Sum(result) > 0
                      AND Count(*) - Sum(result) <= 1); 