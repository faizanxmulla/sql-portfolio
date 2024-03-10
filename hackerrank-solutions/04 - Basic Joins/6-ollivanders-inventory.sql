-- Harry Potter and his friends are at Ollivander's with Ron, finally replacing Charlie's old broken wand.

-- Hermione decides the best way to choose is by determining the minimum number of gold galleons needed to buy each non-evil wand of high power and age. 

-- Write a query to print the id, age, coins_needed, and power of the wands that Ron's interested in, sorted in order of descending power. If more than one wand has same power, sort the result in order of descending age.


-- Solution 1 : more closer to my approach.

SELECT w.id,
       wp.age,
       w.coins_needed,
       w.power
FROM   wands AS w JOIN wands_property AS wp USING(code)
WHERE  wp.is_evil = 0
       AND w.coins_needed = (SELECT Min(coins_needed)
                             FROM   wands AS w1 JOIN wands_property AS wp1 USING(code)
                             WHERE  w1.power = w.power
                                    AND wp1.age = wp.age)
ORDER  BY w.power DESC,
          wp.age DESC 



-- Solution 2: using Window functions.

SELECT   x.id,
         x.age,
         x.coins_needed,
         x.power
FROM    (SELECT w.id,
                age,
                coins_needed,
                power,
                Row_number()OVER(PARTITION BY age, power ORDER BY 3) AS rn
         FROM   wands w JOIN wands_property wp ON w1.code = wp.code
         WHERE  is_evil = 0) x
WHERE    x.rn = 1
ORDER BY 4 DESC,
         2 DESC; 


-- remarks: was very close to the correct answer in solution 1; couldn't figure out this part : w1.power = w.power AND wp1.age = wp.age