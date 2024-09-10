### Problem Statement

Write an SQL query to split the `customer_name` into `first_name`, `middle_name`, and `last_name`. The splitting should be based on the space characters in the `customer_name` string.


### Schema Setup

```sql
CREATE TABLE customers (
  customer_name VARCHAR(100)
);

INSERT INTO customers VALUES
('Ankit Bansal'),
('Vishal Pratap Singh'),
('Michael');
```

### Expected Output

| first_name | middle_name | last_name |
|------------|-------------|-----------|
| Ankit      | NULL        | Bansal    |
| Vishal     | Pratap      | Singh     |
| Michael    | NULL        | NULL      |


### Solution Query

```sql
SELECT  SPLIT_PART(customer_name, ' ', 1) AS first_name,
        CASE 
          WHEN SPLIT_PART(customer_name, ' ', 3) = '' THEN NULL
          ELSE SPLIT_PART(customer_name, ' ', 2)
        END AS middle_name,
        CASE 
          WHEN SPLIT_PART(customer_name, ' ', 3) = '' THEN SPLIT_PART(customer_name, ' ', 2)
          ELSE SPLIT_PART(customer_name, ' ', 3)
        END AS last_name
FROM    customers;
```

