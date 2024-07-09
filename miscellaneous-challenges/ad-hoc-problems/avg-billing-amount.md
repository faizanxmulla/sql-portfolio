### Problem Statement

Display the average billing amount for each customer between 2019 to 2021. Assume a $0 billing amount if nothing is billed for a particular year for that customer.

### Schema setup

```sql
CREATE TABLE billing (
    customer_id INT,
    customer_name VARCHAR(100),
    billing_id VARCHAR(10),
    billing_creation_date DATE,
    billing_amount DECIMAL(10, 2)
);

INSERT INTO billing (customer_id, customer_name, billing_id, billing_creation_date, billing_amount) VALUES
(1, 'A', 'id1', '2020-10-10', 100),
(1, 'A', 'id2', '2020-11-11', 150),
(1, 'A', 'id3', '2021-12-11', 100),
(1, 'B', 'id4', '2019-11-10', 150),
(2, 'B', 'id5', '2020-11-11', 200),
(2, 'B', 'id6', '2021-12-11', 250),
(3, 'C', 'id7', '2018-01-01', 100),
(3, 'C', 'id8', '2019-05-01', 250),
(3, 'C', 'id9', '2021-01-06', 300);
```

### Calculation

Avg billing amount :

- For A is (0 + 100 + 150 + 100) / 4 = 87.5

- For B is (150 + 200 + 250) / 3 = 150
- For C is (0 + 250 + 300) / 3 = 183.33


### Solution Query

```sql
WITH cte AS (
    SELECT   customer_id, 
	         customer_name,
             SUM(CASE WHEN EXTRACT(YEAR FROM billing_creation_date) = 2019 THEN billing_amount ELSE 0 END) AS bill_2019_sum,
             SUM(CASE WHEN EXTRACT(YEAR FROM billing_creation_date) = 2020 THEN billing_amount ELSE 0 END) AS bill_2020_sum,
             SUM(CASE WHEN EXTRACT(YEAR FROM billing_creation_date) = 2021 THEN billing_amount ELSE 0 END) AS bill_2021_sum,
             COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM billing_creation_date) = 2019 THEN billing_creation_date END) AS bill_2019_cnt,
             COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM billing_creation_date) = 2020 THEN billing_creation_date END) AS bill_2020_cnt,
             COUNT(DISTINCT CASE WHEN EXTRACT(YEAR FROM billing_creation_date) = 2021 THEN billing_creation_date END) AS bill_2021_cnt
    FROM     billing
    GROUP BY 1, 2
)
SELECT customer_id, 
	   customer_name,
       ROUND((bill_2019_sum + bill_2020_sum + bill_2021_sum) /
             (CASE WHEN bill_2019_cnt = 0 THEN 1 ELSE bill_2019_cnt END +
              CASE WHEN bill_2020_cnt = 0 THEN 1 ELSE bill_2020_cnt END +
              CASE WHEN bill_2021_cnt = 0 THEN 1 ELSE bill_2021_cnt END), 2) AS avg_billing_amount
FROM   cte
ORDER BY 1
```


### Output

customer_id | customer_name | avg_billing_amount |
--|--|--|
1 |	A |	87.50 |
1 |	B |	50.00 |
2 |	B |	150.00 |
3 |	C |	183.33 |