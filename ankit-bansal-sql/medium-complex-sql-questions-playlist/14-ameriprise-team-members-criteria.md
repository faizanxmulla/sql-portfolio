### Problem Statement

Write a query to return either `Y` or `N`.

**Condition**: If both criteria 1 and criteria 2 are `Y` and at least 2 members have a value of `Y`, the output should be `Y`; otherwise, it should be `N`.

### Schema Setup

```sql
CREATE TABLE data (
    team_id VARCHAR(2),
    member_id VARCHAR(10),
    criteria_1 VARCHAR(1),
    criteria_2 VARCHAR(1)
);

INSERT INTO data VALUES 
('T1', 'T1_mbr1', 'Y', 'Y'),
('T1', 'T1_mbr2', 'Y', 'Y'),
('T1', 'T1_mbr3', 'Y', 'Y'),
('T1', 'T1_mbr4', 'Y', 'Y'),
('T1', 'T1_mbr5', 'Y', 'N'),
('T2', 'T2_mbr1', 'Y', 'Y'),
('T2', 'T2_mbr2', 'Y', 'N'),
('T2', 'T2_mbr3', 'N', 'Y'),
('T2', 'T2_mbr4', 'N', 'N'),
('T2', 'T2_mbr5', 'N', 'N'),
('T3', 'T3_mbr1', 'Y', 'Y'),
('T3', 'T3_mbr2', 'Y', 'Y'),
('T3', 'T3_mbr3', 'N', 'Y'),
('T3', 'T3_mbr4', 'N', 'Y'),
('T3', 'T3_mbr5', 'Y', 'N');
```


### Expected Output

| team_id | member_id | criteria_1 | criteria_2 | output |
|---------|-----------|------------|------------|--------|
| T1      | T1_mbr1   | Y          | Y          | Y      |
| T1      | T1_mbr2   | Y          | Y          | Y      |
| T1      | T1_mbr3   | Y          | Y          | Y      |
| T1      | T1_mbr4   | Y          | Y          | Y      |
| T1      | T1_mbr5   | Y          | N          | N      |
| T2      | T2_mbr1   | Y          | Y          | N      |
| T2      | T2_mbr2   | Y          | N          | N      |
| T2      | T2_mbr3   | N          | Y          | N      |
| T2      | T2_mbr4   | N          | N          | N      |
| T2      | T2_mbr5   | N          | N          | N      |
| T3      | T3_mbr1   | Y          | Y          | Y      |
| T3      | T3_mbr2   | Y          | Y          | Y      |
| T3      | T3_mbr3   | N          | Y          | N      |
| T3      | T3_mbr4   | N          | Y          | N      |
| T3      | T3_mbr5   | Y          | N          | N      |




### Solution Query

```sql
WITH criteria_check as (
    SELECT *, CASE WHEN criteria_1='Y' and criteria_2='Y' THEN 1 ELSE 0 END as criteria_flag
    FROM   data
),
criteria_summary AS (
    SELECT *, SUM(criteria_flag) OVER(PARTITION BY team_id) as flag_sum
    FROM   criteria_check
)
SELECT team_id, 
       member_id, 
       criteria_1, 
       criteria_2,
       CASE WHEN criteria_flag=1 and flag_sum>=2 THEN 'Y' ELSE 'N' END as output
FROM   criteria_summary


-- NOTE: solve in first attempt
```