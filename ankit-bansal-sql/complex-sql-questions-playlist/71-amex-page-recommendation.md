### Problem Statement
Determine the user IDs and the corresponding page IDs of the pages liked by their friends but not liked by the user themselves.

### Schema Setup

```sql
CREATE TABLE friends (
    user_id INT,
    friend_id INT
);

CREATE TABLE likes (
    user_id INT,
    page_id CHAR(1)
);

INSERT INTO friends (user_id, friend_id) VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 1),
(3, 1),
(3, 4),
(4, 1),
(4, 3);

INSERT INTO likes (user_id, page_id) VALUES
(1, 'A'),
(1, 'B'),
(1, 'C'),
(2, 'A'),
(3, 'B'),
(3, 'C'),
(4, 'B');
```

### Expected Output

user_id |	page_id |
--|--|
2 |	B |
2 |	C |
3 |	A |
4 |	A |
4 |	C |


### Solution Query

```sql
-- Solution 1: 

SELECT DISTINCT f.user_id, l.page_id
FROM   friends f JOIN likes l ON f.friend_id = l.user_id
                 LEFT JOIN likes ul ON f.user_id = ul.user_id AND l.page_id = ul.page_id
WHERE  ul.page_id IS NULL



-- Solution 2: same as solution 1, but a little simpler to understand.

WITH user_pages AS (
    SELECT DISTINCT f.user_id, l.page_id
    FROM   friends f JOIN likes l ON f.user_id = l.user_id
),
friends_pages AS (
    SELECT DISTINCT f.user_id, f.friend_id, l.page_id
    FROM   friends f JOIN likes l ON f.friend_id = l.user_id
)
SELECT DISTINCT fp.user_id, fp.page_id
FROM   friends_pages fp LEFT JOIN user_pages up USING(user_id, page_id)
WHERE  up.page_id IS NULL;



-- Solution 3: using NOT IN

SELECT   DISTINCT f.user_id, l.page_id
FROM     friends f JOIN likes l ON f.friend_id = l.user_id
WHERE    (f.user_id, l.page_id) NOT IN (
    SELECT DISTINCT f.user_id, l.page_id
    FROM   friends f JOIN likes l ON f.user_id = l.user_id
)
ORDER BY 1, 2

```
