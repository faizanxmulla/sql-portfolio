### Problem Statement

Among uber_one users, who are the top three riders in terms of successful ride count per market?

Assume that there's no duplication and missingness in the records. Return the market_id, user_id, ride_count, and rank.

### Schema Setup

```sql
CREATE TABLE RideStatus (
    order_date DATE,
    user_id VARCHAR(1),
    ride_id INTEGER,
    status_of_order VARCHAR(10),
    price DECIMAL(3,1),
    service_name VARCHAR(4)
);

INSERT INTO RideStatus (order_date, user_id, ride_id, status_of_order, price, service_name) VALUES
('2020-01-02', 'A', 1, 'Success', 2.5, 'Pool'),
('2020-01-02', 'B', 2, 'Canceled', 4.2, 'Pool'),
('2020-01-03', 'C', 3, 'Success', 9.8, 'XL'),
('2020-01-04', 'D', 4, 'Success', 5.0, 'Pool');


CREATE TABLE UserProfile (
    joined_date DATE,
    user_id VARCHAR(1),
    market_id INTEGER,
    uber_one INTEGER
);

INSERT INTO UserProfile (joined_date, user_id, market_id, uber_one) VALUES
('2018-01-01', 'A', 1, 1),
('2017-01-02', 'B', 2, 0),
('2015-01-03', 'C', 3, 1),
('2014-01-04', 'D', 4, 1);
```

### Solution Query

```sql
WITH ride_count_per_market AS (
	SELECT   user_id, market_id, COUNT(*) as ride_count
	FROM     userprofile up JOIN ridestatus rs USING(user_id)
	WHERE    uber_one='1' and status_of_order='Success'
	GROUP BY 1, 2 
), 
ranked_rides AS (
	SELECT *, RANK() OVER(PARTITION BY market_id ORDER BY ride_count DESC) AS rank
	FROM   ride_count_per_market
)
SELECT *
FROM   ranked_rides
WHERE  rank < 4 
```
