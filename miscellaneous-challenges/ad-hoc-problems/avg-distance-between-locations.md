### Problem Statement | [Link](https://stackoverflow.com/questions/55246899/how-to-find-the-average-distance-between-the-locations)

Find the average distance between the locations like, for example if we take A to B :
- route 1: 21 miles, 

- route 2: 28 miles, 
- route 3: 19 miles 

then expected result: A to B --> (21 + 28 + 19) / 3 = 22.66 miles


### Schema setup

```sql
CREATE TABLE routes (
    source VARCHAR(1),
    destination VARCHAR(1),
    distance DECIMAL(4, 1)
);

INSERT INTO routes (source, destination, distance) VALUES
('A', 'B', 21),
('B', 'A', 28),
('A', 'B', 19),
('C', 'D', 15),
('C', 'D', 17),
('D', 'C', 16.5),
('D', 'C', 18);
```

### Solution Query

```sql
-- Solution 1: using LEAST and GREATEST window functions

SELECT   LEAST(source, destination) AS source, 
         GREATEST(source, destination) AS destination, 
         ROUND(AVG(distance), 2) distance 
FROM     routes
GROUP BY 1, 2
ORDER BY 1


-- Solution 2: 

WITH CTE AS (
	SELECT   source, 
		     destination,
		     SUM(distance) as total_distance,
		     COUNT(*) as number_of_routes,
		     ROW_NUMBER() OVER(ORDER BY source) as rn   
	FROM     routes
	GROUP BY 1, 2
)
SELECT a.source, 
	   a.destination,
	   ROUND((a.total_distance + b.total_distance) / (a.number_of_routes + b.number_of_routes), 2) as avg_distance 
FROM   CTE a JOIN CTE b ON a.source=b.destination AND a.rn < b.rn
```


### Output

source | destination | distance
--|--|--|
A | B | 22.67 |
C | D | 16.63
