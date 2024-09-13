### Problem Statement

You are given a database about battles in the popular TV show "Game of Thrones". The database contains two tables: 'battle' and 'king'. Determine how many battles have each house won in a particular region. Make sure the output is in alphabetical order w.r.t region and then the house.

For each region, find house which has won maximum number of battles. Display the region, house and the number of wins.


### Schema Setup

```sql
CREATE TABLE king (
    k_no INT PRIMARY KEY,
    king VARCHAR(50),
    house VARCHAR(50)
);

CREATE TABLE battle (
    battle_number INT PRIMARY KEY,
    name VARCHAR(100),
    attacker_king INT,
    defender_king INT,
    attacker_outcome INT,
    region VARCHAR(50),
    FOREIGN KEY (attacker_king) REFERENCES king(k_no),
    FOREIGN KEY (defender_king) REFERENCES king(k_no)
);


INSERT INTO king (k_no, king, house) VALUES
(1, 'Robb Stark', 'House Stark'),
(2, 'Joffrey Baratheon', 'House Lannister'),
(3, 'Stannis Baratheon', 'House Baratheon'),
(4, 'Balon Greyjoy', 'House Greyjoy'),
(5, 'Mace Tyrell', 'House Tyrell'),
(6, 'Doran Martell', 'House Martell');

INSERT INTO battle (battle_number, name, attacker_king, defender_king, attacker_outcome, region) VALUES
(1, 'Battle of Oxcross', 1, 2, 1, 'The North'),
(2, 'Battle of Blackwater', 3, 4, 0, 'The North'),
(3, 'Battle of the Fords', 1, 5, 1, 'The Reach'),
(4, 'Battle of the Green Fork', 2, 6, 0, 'The Reach'),
(5, 'Battle of the Ruby Ford', 1, 3, 1, 'The Riverlands'),
(6, 'Battle of the Golden Tooth', 2, 1, 0, 'The North'),
(7, 'Battle of Riverrun', 3, 4, 1, 'The Riverlands'),
(8, 'Battle of Riverrun', 1, 3, 0, 'The Riverlands');
```



### Expected Output

region |	house |	no_of_wins |
--|--|--|
The North |	House Stark |	2 |
The Reach |	House Martell |	1 |
The Reach |	House Stark |	1 |
The Riverlands |	House Baratheon |	2 |

### Solution Query


```sql
WITH wins_cte as (
	SELECT attacker_king as king, region 
	FROM   battle
	WHERE  attacker_outcome=1
	UNION ALL
	SELECT defender_king, region
	FROM   battle
	WHERE  attacker_outcome=0
)
SELECT *
FROM (
	SELECT   region, 
		     house, 
		     COUNT(*) as no_of_wins,
		     RANK() OVER(PARTITION BY region ORDER BY COUNT(*) DESC) as rn  
	FROM     wins_cte w JOIN king k ON w.king=k.k_no
	GROUP BY 1, 2
	) X
WHERE  rn=1
```