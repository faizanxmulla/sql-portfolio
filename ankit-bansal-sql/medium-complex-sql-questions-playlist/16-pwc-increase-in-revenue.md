### Problem Statement

Find companies whose revenue increases consistently every year.

**NOTE**: If a company's revenue increases for a few years but then decreases in any subsequent year, that company should be excluded from the results.


### Schema Setup

```sql
CREATE TABLE company_revenue (
    company VARCHAR(100),
    year INT,
    revenue INT
);

INSERT INTO company_revenue (company, year, revenue) VALUES
('ABC1', 2000, 100),
('ABC1', 2001, 110),
('ABC1', 2002, 120),
('ABC2', 2000, 100),
('ABC2', 2001, 90),
('ABC2', 2002, 120),
('ABC3', 2000, 500),
('ABC3', 2001, 400),
('ABC3', 2002, 600),
('ABC3', 2003, 800);
```


### Expected Output

company_w_ever_increasing_revenue |
--|
ABC1 |


### Solution Query

```sql
-- Solution 1: solved on own; w/o any hints

WITH cte as (
	SELECT *, 
           LEAD(revenue, 1, revenue) OVER(PARTITION BY company ORDER BY year) - revenue as revenue_change, 
           COUNT(*) OVER(PARTITION BY company) as record_entries
	FROM   company_revenue
)
,cte_2 as (
	SELECT *, SUM(CASE WHEN revenue_change >= 0 THEN 1 ELSE 0 END) OVER(PARTITION BY company) as revenue_increase_flag
	FROM   cte
)
SELECT   company as company_w_ever_increasing_revenue
FROM     cte_2
WHERE    record_entries=revenue_increase_flag
GROUP BY 1



-- Solution 2: 

WITH CTE as (
	SELECT *, LEAD(revenue, 1, revenue) OVER(PARTITION BY company ORDER BY year) - revenue as revenue_change
	FROM   company_revenue
)
SELECT   company as company_w_ever_increasing_revenue
FROM     CTE
WHERE    company NOT IN (
	SELECT company
	FROM   CTE
	WHERE  revenue_change < 0
)
GROUP BY 1
```