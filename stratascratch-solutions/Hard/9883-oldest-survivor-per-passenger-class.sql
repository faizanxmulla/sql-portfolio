WITH ranked_passengers AS (
    SELECT pclass,
           name,
           age,
           RANK() OVER(PARTITION BY pclass ORDER BY age DESC) AS rn
    FROM   titanic
    WHERE  survived = 1 and age is not null
)
SELECT   name, age, pclass 
FROM     ranked_passengers
WHERE    rn =1 
ORDER BY 3