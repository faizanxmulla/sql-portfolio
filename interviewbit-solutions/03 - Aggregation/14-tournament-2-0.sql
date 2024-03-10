-- A tournament is being held where several matches takes place between a player from team 1 and a player from team 2. After every match one of the players is declared as the winner. However there are some players in Team2 who are known cheaters. Write an SQL Query to find the percentage of matches Won by Team1 against a non cheater from team 2 on every day. percentage of wins=(total games won against non cheaters)/(total games played against non cheaters). The percentage of wins should be rounded upto 4 decimals.

-- Also the name of the output coloumn should be ‘Percentage Wins’. Also the output should be order ascending order of the Dates.


SELECT   ROUND(SUM(Result) / COUNT(Result), 4) as 'Percentage Wins'
FROM     Team2 t2 JOIN Matches m ON t2.Id = m.PlayerId2
WHERE    t2.Cheater = 0 and PlayerId2 = t2.id
GROUP BY m.Date
ORDER BY m.Date



-- REMARK: there is no need to join all the tables everytime. read the question carefully.