### Problem Statement

You have a table `subscription_history` that records the Amazon Prime subscription history of customers. The table has the following columns:

- `customer_id`: The unique identifier for a customer.

- `marketplace`: The marketplace in which the customer is subscribed (e.g., India).
- `event_date`: The date on which a subscription-related event occurred.
- `event`: The type of event (S -> Subscribe, R -> Renewal, C -> Cancellation).
- `subscription_period`: The period (in months) for which the subscription is valid.

Assume that each customer can be in only one marketplace.

**Write a query to find the number of active Prime members at the end of 2020 in each marketplace.**


### Schema Setup

```sql
CREATE TABLE subscription_history (
    customer_id INT,
    marketplace VARCHAR(50),
    event_date DATE,
    event CHAR(1),
    subscription_period INT
);

INSERT INTO subscription_history (customer_id, marketplace, event_date, event, subscription_period) VALUES
(1, 'India', '2020-01-05', 'S', 6),
(1, 'India', '2020-12-05', 'R', NULL),
(1, 'India', '2021-02-05', 'C', NULL),
(2, 'USA', '2020-05-01', 'S', 12),
(2, 'USA', '2021-02-01', 'C', NULL),
(3, 'USA', '2019-12-01', 'S', 12),
(3, 'USA', '2020-12-01', 'R', 12),
(3, 'USA', '2020-10-10', 'S', 6),
(4, 'USA', '2020-09-10', 'R', NULL),
(4, 'USA', '2020-12-25', 'C', NULL),
(5, 'UK', '2020-06-20', 'S', 12),
(5, 'UK', '2021-06-20', 'C', NULL),
(6, 'UK', '2020-07-05', 'S', 6),
(7, 'Canada', '2020-08-15', 'S', 6),
(7, 'Canada', '2020-11-10', 'S', 1),
(8, 'Canada', '2020-12-10', 'C', NULL),
(9, 'Canada', '2020-11-10', 'S', 1);
```

### Expected Output

marketplace |	active_prime_members |
--|--|
Canada |	1 |
India |	1 |
UK |	1 |
USA |	1 |

### Solution Query

```sql
WITH CTE as (
    SELECT   *, ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY event_date desc) as rn
    FROM     subscription_history
    WHERE    EXTRACT(YEAR FROM event_date) = '2020'
)
SELECT   marketplace, COUNT(customer_id) AS active_prime_members--  
FROM     CTE
WHERE    rn=1 
         and event <> 'C'
         and subscription_period IS NOT NULL
         and EXTRACT(MONTH FROM event_date) + subscription_period > '12'
GROUP BY 1



-- my initial attempt: 

SELECT   marketplace, COUNT(customer_id) AS active_prime_members
FROM     subscription_history
WHERE    EXTRACT(YEAR FROM event_date) = '2020' and 
         EXTRACT(MONTH FROM event_date) + subscription_period <= '12'
         subscription_period IS NOT NULL
GROUP BY 1


-- NOTE: didn't consider the latest event in 2020 and also the cancelled event part.
```
