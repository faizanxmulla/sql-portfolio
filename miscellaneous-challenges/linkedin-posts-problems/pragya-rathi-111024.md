### Problem Statement

A telecommunications company wants to invest in new countries. The company intends to invest in the countries where the average call duration of the calls in this country is strictly greater than the global average call duration.

Write an SQL query to find the countries where this company can invest.

Return the result table in any order.


**Problem Source**: [Pragya Rathi - Linkedin Post 11.10.2024](https://www.linkedin.com/posts/pragya-rathi-8025b526a_sql-interview-questions-activity-7250514707936108548-Fqb_?utm_source=share&utm_medium=member_desktop)

### Schema Setup

```sql
CREATE TABLE person (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    phone_number VARCHAR(50)
);

CREATE TABLE country (
    name VARCHAR(50),
    country_code VARCHAR(3) PRIMARY KEY
);

CREATE TABLE calls (
    caller_id INT,
    callee_id INT,
    duration INT
);

INSERT INTO person (id, name, phone_number) VALUES
(3, 'Jonathan', '051-1234567'),
(12, 'Elvis', '051-7654321'),
(1, 'Moncef', '212-1234567'),
(2, 'Maroua', '212-6523651'),
(7, 'Meir', '972-1234567'),
(9, 'Rachel', '972-0011100');

INSERT INTO country (name, country_code) VALUES
('Peru', '051'),
('Israel', '972'),
('Morocco', '212'),
('Germany', '049'),
('Ethiopia', '251');

INSERT INTO calls (caller_id, callee_id, duration) VALUES
(1, 9, 33),
(2, 9, 4),
(1, 2, 59),
(3, 12, 102),
(3, 12, 330),
(12, 3, 5),
(7, 9, 13);
```

### Expected Output

| name     |
|----------|
| Peru     |


### Solution Query

```sql  
WITH get_country_pin as (
    SELECT id, LEFT(phone_number, 3) as country_code
    FROM   person
),
get_country_avg as (
    SELECT   co.name as country, 
             AVG(ca.duration) as country_avg
    FROM     country co JOIN get_country_pin gcp ON co.country_code=gcp.country_code
                        JOIN calls ca ON gcp.id=ca.callee_id
    GROUP BY 1
)
SELECT   country
FROM     get_country_avg
WHERE    country_avg > (
            SELECT AVG(duration) as global_avg
            FROM   calls
		  )
```