### Problem Statement

We have a table which has 5 columns: `user_id`, `poll_id`, `poll_option_id`, `amount` & `created_dt`.

Users invest money on these different poll options - these entries are there in the table. One of the options is the outcome of the event.

```
Example: 

Q) How many matches will the Indian cricket team win in 2022?

A. Less than 50
B. 50-60
C. 61-65
D. Greater than 65

Now, suppose India wins 63 matches in the end; so the person who chose option C is the winner.
```

**Settlement Process**: 

Money invested in option A, B and D should be proportionately distributed amongst users who invested money in option C.

For example : If total money invested in option A, B and D is Rs. 1500 and there are 3 users who invested 500 in option C (250, 200 and 50)

These users would receive (750, 600 and 150 respectively) - sum is 1500.

**Write down a query for the above settlement process.**


### Schema Setup

```sql
CREATE TABLE polls (
    user_id VARCHAR(4),
    poll_id VARCHAR(3),
    poll_option_id VARCHAR(3),
    amount INT,
    created_date DATE
);

CREATE TABLE poll_answers (
    poll_id VARCHAR(3),
    correct_option_id VARCHAR(3)
);


INSERT INTO polls (user_id, poll_id, poll_option_id, amount, created_date) VALUES
('id1', 'p1', 'A', 200, '2021-12-01'),
('id2', 'p1', 'C', 250, '2021-12-01'),
('id3', 'p1', 'A', 200, '2021-12-01'),
('id4', 'p1', 'B', 500, '2021-12-01'),
('id5', 'p1', 'C', 50, '2021-12-01'),
('id6', 'p1', 'D', 500, '2021-12-01'),
('id7', 'p1', 'C', 200, '2021-12-01'),
('id8', 'p1', 'A', 100, '2021-12-01'),
('id9', 'p2', 'A', 300, '2023-01-10'),
('id10', 'p2', 'C', 400, '2023-01-11'),
('id11', 'p2', 'B', 250, '2023-01-12'),
('id12', 'p2', 'D', 600, '2023-01-13'),
('id13', 'p2', 'C', 150, '2023-01-14'),
('id14', 'p2', 'A', 100, '2023-01-15'),
('id15', 'p2', 'C', 200, '2023-01-16');

INSERT INTO poll_answers (poll_id, correct_option_id) VALUES
('p1', 'C'),
('p2', 'A');
```


### Expected Output

| poll_id | user_id | amount_won |
|---------|---------|------------|
| p1      | id2      | 750        |
| p1      | id5      | 150        |
| p1      | id7      | 600        |
| p2      | id9      | 1200       |
| p2      | id14     | 400        |


### Solution Query

```sql  
WITH CTE as (
	SELECT *, 
		   SUM(amount) FILTER(WHERE poll_option_id=correct_option_id) OVER(PARTITION BY poll_id) as total_winners_amount, 
		   SUM(amount) FILTER(WHERE poll_option_id<>correct_option_id) OVER(PARTITION BY poll_id) as total_losers_amount
	FROM   polls p JOIN poll_answers pa USING(poll_id)
)
SELECT poll_id, user_id, amount * (total_losers_amount/total_winners_amount) as amount_won
FROM   CTE
WHERE  poll_option_id=correct_option_id


-- NOTE: solved in first attempt
```