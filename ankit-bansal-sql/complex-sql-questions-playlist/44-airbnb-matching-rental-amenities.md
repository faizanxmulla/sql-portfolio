### Problem Statement

The Airbnb Booking Recommendations team is trying to understand the "substitutability" of two rentals and whether one rental is a good substitute for another.

Write a query to find the unique combination of two Airbnb rentals with the exact same amenities offered.

**Assumptions:**

- If property 1 has a kitchen and pool, and property 2 has a kitchen and pool too, they are good substitutes and represent a unique matching rental.

- If property 3 has a kitchen, pool, and fireplace, and property 4 only has a pool and fireplace, then they are not a good substitute.

### Schema Setup

```sql
CREATE TABLE rental_amenities (
  rental_id int,
  amenity varchar(50)
);

INSERT INTO rental_amenities (rental_id, amenity) VALUES
(123, 'pool'),
(123, 'kitchen'),
(234, 'hot tub'),
(234, 'fireplace'),
(345, 'kitchen'),
(345, 'pool'),
(456, 'pool');
```

### Expected Output


matching_airbnb |
--|
1 |


### Solution

```sql
WITH amenities_cte AS (
    SELECT   rental_id, 
             STRING_AGG(amenity, ', ' ORDER BY amenity) as total_amenities
    FROM     rental_amenities
    GROUP BY 1
)
SELECT COUNT(*) as matching_airbnb 
FROM   amenities_cte a JOIN amenities_cte b ON a.total_amenities = b.total_amenities
                                            AND a.rental_id < b.rental_id
```
