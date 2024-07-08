### Problem Statement

The relationship between the `lift` and `lift_passengers` tables is such that multiple passengers can attempt to enter the same lift, but the total weight of the passengers in a lift cannot exceed the lift’s capacity.

Our task is to write an SQL query that produces a comma-separated list of passengers who can be accommodated in each lift without exceeding the lift's capacity. The passengers in the list should be ordered by their weight in increasing order.

*Assumption:* Weights of the passengers are unique within each lift.

### Schema setup

```sql
CREATE TABLE lift (
    id INT,
    capacity_kg INT
);

CREATE TABLE lift_passengers (
    passenger_name VARCHAR(100),
    weight_kg INT,
    lift_id INT
);

INSERT INTO lift (id, capacity_kg) VALUES
(1, 300),
(2, 350);

INSERT INTO lift_passengers (passenger_name, weight_kg, lift_id) VALUES
('Rahul', 85, 1),
('Adarsh', 73, 1),
('Riti', 95, 1),
('Dheeraj', 80, 1),
('Vimal', 83, 2),
('Neha', 77, 2),
('Priti', 73, 2),
('Himanshi', 85, 2);
```

### Solution Query

```sql
WITH passenger_weights AS (
	SELECT *, 
		   SUM(weight_kg) OVER(PARTITION BY id ORDER BY weight_kg) AS cumulative_weight
	FROM   lift l JOIN lift_passengers lp ON l.id=lp.lift_id
)
SELECT   lift_id, STRING_AGG(passenger_name, ', ') as passengers_list
FROM     passenger_weights
WHERE    cumulative_weight < capacity_kg
GROUP BY 1
```

### Output:

lift_id | passengers_list |
--|--|
1 | Adarsh, Dheeraj, Rahul | 
2 | Priti, Neha, Vimal, Himanshi | 