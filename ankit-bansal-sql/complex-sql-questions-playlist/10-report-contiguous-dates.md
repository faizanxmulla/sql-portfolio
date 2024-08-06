### Problem Statement

Given an input table with daily records of states, your task is to transform the data so that you group consecutive dates with the same state into a single record. 

The output should include the start date, end date, and the state for each grouped period.

### Schema setup

```sql
CREATE TABLE daily_states (
    date_value DATE,
    state VARCHAR(10)
);

INSERT INTO daily_states (date_value, state) VALUES
('2019-01-01', 'success'),
('2019-01-02', 'success'),
('2019-01-03', 'success'),
('2019-01-04', 'fail'),
('2019-01-05', 'fail'),
('2019-01-06', 'success');
```

### Expected Output

| start_date | end_date   | state   |
|------------|------------|---------|
| 2019-01-01 | 2019-01-03 | success |
| 2019-01-04 | 2019-01-05 | fail    |
| 2019-01-06 | 2019-01-06 | success |

### Solution Query

```sql
-- Solution 1: using LAG and the SUM(CASE WHEN ...)

WITH state_changes AS (
    SELECT date_value, state, LAG(state) OVER (ORDER BY date_value) AS prev_state
    FROM   daily_states
),
grouped_states AS (
	SELECT date_value,
		   state,   
		   SUM(CASE WHEN state = prev_state THEN 0 ELSE 1 END) OVER (ORDER BY date_value) AS grp
	FROM  state_changes
)
SELECT   MIN(date_value) AS start_date,
    	 MAX(date_value) AS end_date,  
         state
FROM     grouped_states
GROUP BY grp, 3
ORDER BY 1



-- Solution 2: ROW_NUMBER() trick for continuous dates

WITH state_groups AS (
    SELECT date_value,
           state,
           ROW_NUMBER() OVER (ORDER BY date_value) - 
           ROW_NUMBER() OVER (PARTITION BY state ORDER BY date_value) AS grp
    FROM   daily_states
)
SELECT   MIN(date_value) AS start_date, MAX(date_value) AS end_date, state
FROM     state_groups
GROUP BY grp, 3
ORDER BY 1
```
