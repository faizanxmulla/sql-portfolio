-- Given a table GAMERS, query for a list sorted by alphabetical order of all the Players in the table, followed by the First letter of the Role each player plays in the game enclosed in braces (). 

-- Example: Ram(H)


SELECT   CONCAT(Player, '(', SUBSTRING(Role, 1, 1), ')') as N
FROM     GAMERS
ORDER BY Player