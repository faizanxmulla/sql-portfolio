-- Given a table GAMERS, pivot the table in such a manner that the Player is sorted in alphabetical order and displayed under its corresponding Role. 

-- Print NULL if no more players are associated with the corresponding role. The roles are Healer, Attacker, Defender, Tactician.



-- Solution 1: 


SELECT Min(CASE
             WHEN role = 'Healer' THEN player
             ELSE NULL
           END) AS "MIN(Healer)",
       Min(CASE
             WHEN role = 'Attacker' THEN player
             ELSE NULL
           END) AS "MIN(Attacker)",
       Min(CASE
             WHEN role = 'Defender' THEN player
             ELSE NULL
           END) AS "MIN(Defender)",
       Min(CASE
             WHEN role = 'Tactician' THEN player
             ELSE NULL
           END) AS "MIN(Tactician)"
FROM   (SELECT g1.player,
               g1.role,
               Count(*) AS temp_id
        FROM   GAMERS g1
               JOIN GAMERS g2
                 ON g2.player <= g1.player
                    AND g1.role = g2.role
        GROUP  BY 1, 2
        ORDER  BY 1, 2) dnd
GROUP  BY temp_id 



-- Solution 2: learnt somthing new. 


SET @h=0, @a=0, @d=0, @t=0;
SELECT MIN(Healer),MIN(Attacker),MIN(Defender),MIN(Tactician)
FROM
(SELECT IF(Role='Healer',Player,NULL) AS Healer,
        IF(Role='Attacker',Player,NULL) AS Attacker,
        IF(Role='Defender',Player,NULL) AS Defender,
        IF(Role='Tactician',Player,NULL) AS Tactician,
 CASE Role
    WHEN 'Healer' THEN @h:=@h+1
    WHEN 'Attacker' THEN @a:=@a+1
    WHEN 'Defender' THEN @d:=@d+1
    WHEN 'Tactician' THEN @t:=@t+1
 END
AS idn FROM GAMERS ORDER BY Player )
AS temp GROUP BY temp.idn;



-- remarks : wasn't even able to proceed after the case statments on my own; so practice PIVOT questions more. 

