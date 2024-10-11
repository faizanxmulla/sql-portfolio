### Problem Statement

You have two tables: `restaurants` and `reviews`.

* The `restaurants` table stores information about different restaurants.

* The `reviews` table contains details about user reviews for these restaurants.



### Schema Setup

```sql
CREATE TABLE restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100),
    cuisine VARCHAR(50),
    city VARCHAR(50),
    country VARCHAR(50),
    opening_date DATE
);

INSERT INTO restaurants (restaurant_id, name, cuisine, city, country, opening_date) VALUES
(1, 'La Petite Maison', 'French', 'New York', 'USA', '2016-11-15'),
(2, 'Sushi Royale', 'Japanese', 'Tokyo', 'Japan', '2015-12-20'),
(3, 'Taj Spice', 'Indian', 'London', 'UK', '2010-07-01'),
(4, 'Pasta Bella', 'Italian', 'Rome', 'Italy', '2019-05-22'),
(5, 'Burger Haven', 'American', 'Chicago', 'USA', '2020-09-14'),
(6, 'Tandoor Palace', 'Indian', 'Mumbai', 'India', '2018-07-30'),
(7, 'Sushi Zen', 'Japanese', 'Osaka', 'Japan', '2017-04-18'),
(8, 'El Toro Loco', 'Mexican', 'Madrid', 'Spain', '2023-03-05'),
(9, 'The Curry House', 'Indian', 'Birmingham', 'UK', '2023-06-18'),
(10, 'Le Gourmet', 'French', 'Paris', 'France', '2022-12-15'),
(11, 'Pho Real', 'Vietnamese', 'Hanoi', 'Vietnam', '2023-09-01'),
(12, 'Dim Sum Delight', 'Chinese', 'Beijing', 'China', '2021-10-10'),
(13, 'The Great Kebab', 'Turkish', 'Istanbul', 'Turkey', '2020-11-25'),
(14, 'Bistro de Lyon', 'French', 'Lyon', 'France', '2022-11-11');
```

```sql
CREATE TABLE reviews (
    review_id INT PRIMARY KEY,
    restaurant_id INT,
    user_id INT,
    rating INT,
    review_date DATE,
    price_range VARCHAR(10),
    visit_type VARCHAR(50),
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id)
);

INSERT INTO reviews (review_id, restaurant_id, user_id, rating, review_date, price_range, visit_type) VALUES
(1, 1, 101, 4, '2023-08-11', '$$$$', 'Dinner'),
(2, 2, 102, 5, '2023-08-12', '$$$', 'Lunch'),
(3, 3, 103, 3, '2023-08-10', '$$', 'Takeout'),
(4, 2, 104, 4, '2023-08-12', '$$$$', 'Dinner'),
(5, 2, 105, 5, '2023-08-14', '$$$$', 'Special Occasion'),
(6, 4, 106, 4, '2023-08-15', '$$$', 'Dinner'),
(7, 4, 107, 5, '2023-08-16', '$$', 'Lunch'),
(8, 5, 108, 3, '2023-08-10', '$$', 'Dinner'),
(9, 5, 109, 4, '2023-08-12', '$$$', 'Special Occasion'),
(10, 6, 110, 5, '2023-08-15', '$$', 'Takeout'),
(11, 6, 111, 4, '2023-07-20', '$$', 'Dinner'),
(12, 7, 112, 3, '2023-07-15', '$$$', 'Lunch'),
(13, 8, 113, 5, '2023-08-20', '$$$$', 'Dinner'),
(14, 8, 114, 4, '2023-08-22', '$$$$', 'Lunch'),
(15, 9, 115, 4, '2023-08-25', '$$', 'Takeout'),
(16, 10, 116, 5, '2023-08-25', '$$$', 'Dinner'),
(17, 10, 117, 3, '2023-08-26', '$$$', 'Lunch'),
(18, 11, 118, 4, '2023-09-01', '$$', 'Takeout'),
(19, 12, 119, 5, '2023-09-05', '$$$', 'Dinner'),
(20, 13, 120, 5, '2023-08-10', '$$', 'Lunch'),
(21, 13, 121, 4, '2023-08-15', '$$$', 'Special Occasion'),
(22, 14, 122, 3, '2023-08-12', '$$', 'Dinner');
```


---

## Questions + Difficulty

### a. Easy

Which countries has the most number of restaurants that opened in 2023?

#### Solution Query

```sql
SELECT   country, COUNT(restaurant_id) as restaurants_opened_in_2023
FROM     restaurants 
WHERE    EXTRACT(YEAR FROM opening_date) = '2023'
GROUP BY 1
```

---


### b. Intermediate

Calculate the average rating for each cuisine type.

#### Solution Query

```sql
SELECT   r.cuisine, ROUND(AVG(rating), 2) as avg_rating
FROM     restaurants r JOIN reviews rv USING(restaurant_id)
GROUP BY 1
ORDER BY 2 DESC
```

---


### c. Advanced

For each city, find the “top rated restaurant” with the highest average rating each month. How often do we see the the “top rated restaurant” change month-over-month?

#### Solution Query

```sql
WITH monthly_avg_ratings as (
    SELECT   r.city,
             r.name,
             TO_CHAR(RV.review_date, 'YYYY-MM') as year_month,
             AVG(rv.rating) as avg_rating
    FROM     restaurants r JOIN reviews rv USING(restaurant_id)
    GROUP BY 1, 2, 3
)
,top_rated_cte AS (
    SELECT *, RANK() OVER(PARTITION BY city, year_month ORDER BY avg_rating DESC) as rank
    FROM   monthly_avg_ratings
)
SELECT   city, year_month, name as top_restaurant, ROUND(avg_rating, 2)
FROM     top_rated_cte
WHERE    rank = 1
ORDER BY 1, 2
```

---

### d. Expert

Identify emerging food trends and recommend cities for new restaurant openings based on cuisine popularity, rating trends, and market saturation.


#### Solution Query

```sql
-- 1. Identify which cuisines are popular in different cities

SELECT   city, cuisine, COUNT(*) AS restaurant_count
FROM     restaurants
GROUP BY 1, 2
ORDER BY 1, 3 DESC


-- 2. Examine the average ratings for different cuisines in each city over time.

SELECT   city, 
         cuisine, 
         TO_CHAR(rv.review_date, 'YYYY-MM') AS year_month,              
         ROUND(AVG(rv.rating), 2) AS avg_rating
FROM     restaurants r JOIN reviews rv USING(restaurant_id)
GROUP BY 1, 2, 3
ORDER BY 1, 3


-- 3. Understand how many restaurants already offer a particular cuisine in a given city, and whether there is room for more based on demand.

SELECT   city, 
         cuisine, 
         COUNT(*) AS restaurant_count,
         ROUND(AVG(rv.rating), 2) AS avg_rating
FROM     restaurants r JOIN reviews rv USING(restaurant_id)
GROUP BY 1, 2
ORDER BY 1, 3 DESC
```

### **Business Recommendations**: 

- **Identify cities with growing popularity** for specific cuisines but low market saturation.

- **Recommend new restaurant openings** for cuisines that are trending upward and have few existing competitors.
---