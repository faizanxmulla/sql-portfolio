### Problem Statement

Write a query to get `new value` from the value and the formula provided for each of the table. 

**Explanation**: For the first row, the formula is `1+4`, which indicates that we need to sum the values from the 1st and 4th rows. This results in `10 + 20`, giving a new value of `30`.

### Schema Setup

```sql
CREATE TABLE input (
  id INT,
  formula VARCHAR(10),
  value INT
);

INSERT INTO input VALUES 
(1, '1+4', 10),
(2, '2+1', 5),
(3, '3-2', 40),
(4, '4-1', 20);
```


### Expected Output

id | formula | value | new_value |
--|--|--|--|
1 | 1+4 | 10 | 30 |
2 | 2+1 | 5 | 15 | 
3 | 3-2 | 40 | 35 |
4 | 4-1 | 20 | 10 |



### Solution Query

```sql
WITH CTE as (
    SELECT *,
           SUBSTRING(formula, 1, 1)::int as first_digit,
           SUBSTRING(formula, 3, 1)::int as second_digit,
           SUBSTRING(formula, 2, 1) as operator
    FROM   input
)
SELECT   c.id, 
         c.formula, 
         c.value,
         CASE WHEN operator='+' THEN i1.value+i2.value ELSE i1.value-i2.value END as new_value
FROM     CTE c JOIN input i1 ON c.first_digit=i1.id
               JOIN input i2 ON c.second_digit=i2.id
ORDER BY 1


-- NOTE: 

-- syntax --> SUBSTRING(string, start_position, length)

-- also for the digits, instead of SUBSTRING, we could have just used LEFT and RIGHT.
```