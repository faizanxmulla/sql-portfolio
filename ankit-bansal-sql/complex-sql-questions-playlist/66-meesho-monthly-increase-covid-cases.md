### Problem Statement

A database contains daily COVID cases reported for 2021. 

Calculate the percentage increase in COVID cases each month versus the cumulative cases as of the prior months. 

Return the month number, total cases and the percentage increase rounded to one decimal. Order the result by month.

### Schema Setup

```sql
CREATE TABLE covid_cases (
    record_date DATE PRIMARY KEY,
    cases_count INT
);

INSERT INTO covid_cases (record_date, cases_count) VALUES
('2021-01-01',66),('2021-01-02',41),('2021-01-03',54),('2021-01-04',68),('2021-01-05',16),('2021-01-06',90),('2021-01-07',34),('2021-01-08',84),('2021-01-09',71),('2021-01-10',14),('2021-01-11',48),('2021-01-12',72),('2021-01-13',55),('2021-02-01',38),('2021-02-02',57),('2021-02-03',42),('2021-02-04',61),('2021-02-05',25),('2021-02-06',78),('2021-02-07',33),('2021-02-08',93),('2021-02-09',62),('2021-02-10',15),('2021-02-11',52),('2021-02-12',76),('2021-02-13',45),('2021-03-01',27),('2021-03-02',47),('2021-03-03',36),('2021-03-04',64),('2021-03-05',29),('2021-03-06',81),('2021-03-07',32),('2021-03-08',89),('2021-03-09',63),('2021-03-10',19),('2021-03-11',53),('2021-03-12',78),('2021-03-13',49),('2021-04-01',39),('2021-04-02',58),('2021-04-03',44),('2021-04-04',65),('2021-04-05',30),('2021-04-06',87),('2021-04-07',37),('2021-04-08',95),('2021-04-09',60),('2021-04-10',13),('2021-04-11',50),('2021-04-12',74),('2021-04-13',46),('2021-05-01',28),('2021-05-02',49),('2021-05-03',35),('2021-05-04',67),('2021-05-05',26),('2021-05-06',82),('2021-05-07',31),('2021-05-08',92),('2021-05-09',61),('2021-05-10',18),('2021-05-11',54),('2021-05-12',79),('2021-05-13',51),('2021-06-01',40),('2021-06-02',59),('2021-06-03',43),('2021-06-04',66),('2021-06-05',27),('2021-06-06',85),('2021-06-07',38),('2021-06-08',94),('2021-06-09',64),('2021-06-10',17),('2021-06-11',55),('2021-06-12',77),('2021-06-13',48),('2021-07-01',34),('2021-07-02',50),('2021-07-03',37),('2021-07-04',69),('2021-07-05',32),('2021-07-06',80),('2021-07-07',33),('2021-07-08',88),('2021-07-09',57),('2021-07-10',21),('2021-07-11',56),('2021-07-12',73),('2021-07-13',42),('2021-08-01',41),('2021-08-02',53),('2021-08-03',39),('2021-08-04',62),('2021-08-05',23),('2021-08-06',83),('2021-08-07',29),('2021-08-08',91),('2021-08-09',59),('2021-08-10',22),('2021-08-11',51),('2021-08-12',75),('2021-08-13',44),('2021-09-01',36),('2021-09-02',45),('2021-09-03',40),('2021-09-04',68),('2021-09-05',28),('2021-09-06',84),('2021-09-07',30),('2021-09-08',90),('2021-09-09',61),('2021-09-10',20),('2021-09-11',52),('2021-09-12',71),('2021-09-13',43),('2021-10-01',46),('2021-10-02',58),('2021-10-03',41),('2021-10-04',63),('2021-10-05',24),('2021-10-06',82),('2021-10-07',34),('2021-10-08',86),('2021-10-09',56),('2021-10-10',14),('2021-10-11',57),('2021-10-12',70),('2021-10-13',47),('2021-11-01',31),('2021-11-02',44),('2021-11-03',38),('2021-11-04',67),('2021-11-05',22),('2021-11-06',79),('2021-11-07',32),('2021-11-08',94),('2021-11-09',60),('2021-11-10',15),('2021-11-11',54),('2021-11-12',73),('2021-11-13',46),('2021-12-01',29),('2021-12-02',50),('2021-12-03',42),('2021-12-04',65),('2021-12-05',25),('2021-12-06',83),('2021-12-07',30),('2021-12-08',93),('2021-12-09',58),('2021-12-10',19),('2021-12-11',52),('2021-12-12',75),('2021-12-13',48);
```

### Expected Output

| month | total_cases | percentage |
|-------|-------------|------------|
| 1     | 713         | NULL       |
| 2     | 677         | 95.0       |
| 3     | 667         | 48.0       |
| 4     | 698         | 33.9       |
| 5     | 673         | 24.4       |
| 6     | 713         | 20.8       |
| 7     | 672         | 16.2       |
| 8     | 672         | 14.0       |
| 9     | 668         | 12.2       |
| 10    | 678         | 11.0       |
| 11    | 655         | 9.6        |
| 12    | 669         | 8.9        |



### Solution Query

```sql
-- Solution 1: using advanced aggregation; similar to my approch

WITH monthly_cases_cte as (
    SELECT   EXTRACT(MONTH FROM record_date) as month, 
             SUM(cases_count) as total_cases
    FROM     covid_cases
    GROUP BY 1
    ORDER BY 1
), 
cumulative_cases_cte as (
    SELECT month, total_cases, SUM(total_cases) OVER(ORDER BY month ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING) as cumulative_sum
    FROM   monthly_cases_cte
)
SELECT month, ROUND(100.0 * (total_cases / cumulative_sum), 1) as percentage
FROM   cumulative_cases_cte



-- Solution 2: using non-equi Join

WITH monthly_cases_cte AS (
    SELECT   MONTH(record_date) AS record_month, 
             SUM(cases_count) AS monthly_cases
    FROM     covid_cases
    GROUP BY 1
), 
non_equi_join_cte AS (
    SELECT current_month.record_month AS current_month, 
           prev_month.record_month AS prior_months,
           current_month.monthly_cases AS current_count, 
           prev_month.monthly_cases AS prior_count
    FROM   monthly_cases_cte as current_month LEFT JOIN monthly_cases_cte as prev_month ON prev_month.record_month < current_month.record_month
)
SELECT   current_month, 
         current_count, 
         ROUND(current_count * 100.0 / SUM(prior_count), 1) AS percent_increase
FROM     non_equi_join_cte
GROUP BY 1, 2



-- my initial approach:

WITH monthly_cases_cte as (
    SELECT   EXTRACT(MONTH FROM record_date) as month, 
             SUM(cases_count) as total_cases
    FROM     covid_cases
    GROUP BY 1
    ORDER BY 1
), 
cumulative_cases_cte as (
    SELECT month, total_cases, SUM(total_cases) OVER(ORDER BY month ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) as cumulative_sum
    FROM   monthly_cases_cte
),
prev_cumulative_cases_cte as (
    SELECT month, total_cases, LAG(cumulative_sum) OVER(ORDER BY month) as prior_cumulative_sum
    FROM   cumulative_cases_cte
)
SELECT month, ROUND(100.0 * (prior_cumulative_sum - total_cases) / prior_cumulative_sum, 1) as percentage
FROM   prev_cumulative_cases_cte




-- NOTE: 

-- my initial thought process was to get the cumulative sum of the prior "month" (notice 'singular') and not "months" (plural), which was actually expected. So, i took LAG(cumulative_sum).

-- should i understood what was actually being asked.
```

