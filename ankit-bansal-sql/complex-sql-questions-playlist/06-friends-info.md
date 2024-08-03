### Problem Statement

Write a query to find PersonID, Name, number of friends, sum of marks of person who have friends with total score greater than 100.

### Schema setup

```sql
CREATE TABLE person (
    PersonID INT PRIMARY KEY,
    Name VARCHAR(50),
    Email VARCHAR(50),
    Score INT
);

CREATE TABLE friend (
    PersonID INT,
    FriendID INT,
    FOREIGN KEY (PersonID) REFERENCES person(PersonID),
    FOREIGN KEY (FriendID) REFERENCES person(PersonID)
);

INSERT INTO person (PersonID, Name, Email, Score) VALUES
(1, 'Alice', 'alice2018@hotmail.com', 98),
(2, 'Bob', 'bob2018@hotmail.com', 11),
(3, 'Dave', 'dave2018@hotmail.com', 0),
(4, 'Tara', 'tara2018@hotmail.com', 45),
(5, 'John', 'john2018@hotmail.com', 63);

INSERT INTO friend (PersonID, FriendID) VALUES
(1, 2),
(1, 3),
(2, 1),
(3, 4),
(3, 5),
(4, 2),
(4, 3),
(4, 5);
```

### Expected Output

personid |	name |	friends_count |	total_score |
--|--|--|--|
2 |	Bob |	2 |	115 |
4 |	Tara |	3 |	101 |

### Solution Query

```sql
WITH friends_cte AS (
	SELECT   f.personid, COUNT(f.friendid) AS friends_count, SUM(p.score) AS total_score
	FROM     friends f JOIN persons p ON f.friendid = p.personid
	GROUP BY 1
	HAVING   SUM(p.score) > 100
	ORDER BY 1
)
SELECT personid, p.name, friends_count, total_score
FROM   friends_cte fc JOIN persons p USING(personid)
```

