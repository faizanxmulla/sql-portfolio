-- subjective question


SELECT r1.id, r1.name
FROM   big_table r1 JOIN (
        SELECT CEIL(RAND() * (SELECT MAX(id) FROM big_table)) as id
    ) as r2
ON       r1.id >= r2.id
ORDER BY r1.id
LIMIT    1