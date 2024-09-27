### Problem Statement

A travel and tour company has 2 tables that relate to customers: `families` & `countries`. Each tour offers a discount if a minimum number of people book at the same time.

Write a query to print the maximum number of discounted tours any 1 family in the `families` table can choose from.


### Schema Setup

```sql
CREATE TABLE families (
    id VARCHAR(50),
    name VARCHAR(50),
    family_size INT
);

CREATE TABLE countries (
    id VARCHAR(50),
    name VARCHAR(50),
    min_size INT,
    max_size INT
);


INSERT INTO families (id, name, family_size) VALUES 
('c00dac11bde74750b4d207b9c182a85f', 'Alex Thomas', 9),
('eb6f2d3426694667ae3e79d6274114a4', 'Chris Gray', 2),
('3f7b5b8e835d4e1c8b3e12e964a741f3', 'Emily Johnson', 4),
('9a345b079d9f4d3cafb2d4c11d20f8ce', 'Michael Brown', 6),
('e0a5f57516024de2a231d09de2cbe9d1', 'Jessica Wilson', 3);

INSERT INTO countries (id, name, min_size, max_size) VALUES 
('023fd23615bd4ff4b2ae0a13ed7efec9', 'Bolivia', 2, 4),
('be247f73de0f4b2d810367cb26941fb9', 'Cook Islands', 4, 8),
('3e85ab80a6f84ef3b9068b21dbcc54b3', 'Brazil', 4, 7),
('e571e164152c4f7c8413e2734f67b146', 'Australia', 5, 9),
('f35a7bb7d44342f7a8a42a53115294a8', 'Canada', 3, 5),
('a1b5a4b5fc5f46f891d9040566a78f27', 'Japan', 10, 12);
```


### Expected Output

`CASE 1:` in case of only MIN_SIZE variable

discounted_tours_count |
--|
3 |

`CASE 2:` in case of both MIN_SIZE and MAX_SIZE variables.

discounted_tours_count |
--|
4 |


### Solution

```sql
-- CASE 1: in case of only MIN_SIZE variable.

SELECT COUNT(*) AS discounted_tours_count
FROM   countries
WHERE  min_size < (
	SELECT MAX(family_size) 
	FROM   families
)


-- CASE 2: in case of both MIN_SIZE and MAX_SIZE variables.

WITH CTE as (
	SELECT   f.name as person_name, 
             family_size, 
             c.name as country_name, 
             min_size, 
             max_size, 
             COUNT(*) OVER(PARTITION BY f.name) as count
	FROM     countries c JOIN families f ON f.family_size BETWEEN c.min_size and c.max_size
	ORDER BY 1
)
SELECT MAX(count) as discounted_tours_count
FROM   CTE
```