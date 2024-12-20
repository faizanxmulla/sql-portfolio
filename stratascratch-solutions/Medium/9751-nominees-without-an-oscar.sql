SELECT   nominee, COUNT(*) as noms
FROM     oscar_nominees
WHERE    nominee NOT IN (
        SELECT nominee 
        FROM   oscar_nominees 
        WHERE  winner='True'
    )
GROUP BY nominee
ORDER BY noms desc