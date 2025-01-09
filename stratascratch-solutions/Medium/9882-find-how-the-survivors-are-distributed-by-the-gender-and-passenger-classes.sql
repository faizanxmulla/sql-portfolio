SELECT   sex,
         SUM(CASE WHEN pclass = 1 THEN 1 ELSE 0 END) as first_class,
         SUM(CASE WHEN pclass = 2 THEN 1 ELSE 0 END) as second_class,
         SUM(CASE WHEN pclass = 3 THEN 1 ELSE 0 END) as third_class
FROM     titanic
WHERE    survived = 1
GROUP BY sex