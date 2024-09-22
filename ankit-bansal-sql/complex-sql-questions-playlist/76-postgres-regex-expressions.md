### Problem Statement

A column contains a list of phone numbers as keyed in by users. 

You are supposed to find only those phone numbers which don't have any repeating numbers, i.e., all numbers of the phone number must be unique.


### Schema Setup

```sql
CREATE TABLE phone_numbers (
  num VARCHAR(20)
);

INSERT INTO phone_numbers VALUES
('1234567780'),
('2234578996'),
('+1-12244567780'),
('+32-2233567889'),
('+2-23456987312'),
('+91-9087654123'),
('+23-9085761324'),
('+11-8091013345');
```


### Expected Output

phone_number |
--|
9085761324 |
9087654123 |


### Solution Query

```sql  
WITH cleaned_numbers as (
	SELECT CASE WHEN POSITION('-' IN num) > 0 THEN SPLIT_PART(num, '-', 2) ELSE num END as number_wo_code
	FROM   phone_numbers
),
get_digits_cte as (
	SELECT number_wo_code, REGEXP_SPLIT_TO_TABLE(number_wo_code, '') as digits
	FROM   cleaned_numbers
)
SELECT   number_wo_code as phone_number
FROM     get_digits_cte
GROUP BY 1
HAVING   COUNT(*)=COUNT(DISTINCT digits)



-- Solution 2: a bit complicated // but came up with it on my own

WITH cleaned_numbers AS (
  SELECT CASE WHEN num LIKE '+%-%' THEN SUBSTRING(num FROM POSITION('-' IN num) + 1) ELSE num END AS clean_num
  FROM   phone_numbers
)
SELECT clean_num AS phone_number
FROM   cleaned_numbers
WHERE  LENGTH(clean_num) = (
	SELECT COUNT(DISTINCT substr(clean_num, i, 1))
	FROM generate_series(1, LENGTH(clean_num)) AS i
);
```