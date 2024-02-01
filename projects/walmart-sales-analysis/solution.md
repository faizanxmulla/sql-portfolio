## List of Questions + Solutions

### `A. Generic Questions`

1. How many unique cities does the data have?

```sql
SELECT DISTINCT city
FROM   wm_sales_data 
```
**Result Set :** 

| city_name |
|-----------|
|  Yangon   |
|  Naypyitaw|
|  Mandalay |

<br>

2. In which city is each branch?

```sql
SELECT DISTINCT city, branch
FROM   wm_sales_data 
```

**Result Set :** 
|  city 	|  branch 	|
|---	|---	|
|  Yangon   | A|
|  Naypyitaw| C|
|  Mandalay | B 	|


<br>

### `B. Product-related questions`

1. How many unique product lines does the data have?

```sql
SELECT COUNT(DISTINCT product_line) as count
FROM   wm_sales_data 
```

**Result Set :** 

|  count 	|
|---|
|  6   |


<br>


2. What is the most common payment method?

```sql
SELECT   payment_method,
         Count(payment_method) as count
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC 
LIMIT    1
```
**Result Set :** 

| payment_method	|  count 	|
|-----------|-----------|
|  EWallet      |       6   |


<br>


3. What is the most selling product line?

```sql
SELECT   product_line,
         Count(product_line)
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC 
```

**Result Set :** 

| product_line	|  count 	|
|-----------|-----------|
|  Fashion accessories      |       148   |

<br>

4. What is the total revenue by month?

```sql
SELECT   month_name,
         SUM(total) AS total_sum
FROM     wm_sales_data
GROUP BY 1
ORDER BY 1 DESC; 
```

**Result Set :** 
| month_name | total_sum |
| ----------| ---------|
| March	 | 109455.5070 | 
| January	 | 116291.8680 | 
| February |	97219.3740 | 

<br>


5. What month had the largest COGS?

```sql
SELECT   month_name AS month,
         SUM(cogs)  AS total_cogs
FROM     wm_sales_data
GROUP BY 1
ORDER BY 1 DESC
LIMIT    1; 
```

**Result Set :** 
month | total_cogs
|----| ----|
March | 	104243.34 | 


<br>


6. What product line had the largest revenue?

```sql
SELECT   product_line,
         SUM(total) AS total_revenue
FROM     wm_sales_data
GROUP BY product_line
ORDER BY total_revenue DESC
LIMIT    1;
```

**Result Set :** 
product_line | total_revenue
|----| ----|
Food and beverages | 	56144.8440


<br>



7. What is the city with the largest revenue?

```sql
SELECT   city,
         SUM(total) AS total_revenue
FROM     wm_sales_data
GROUP BY city
ORDER BY total_revenue DESC
LIMIT    1;
```

**Result Set :** 

city | total_revenue
|----| ----|
Naypyitaw | 	110568.7065


<br>



8. What product line had the largest VAT?

```sql
SELECT   product_line,
         ROUND(SUM(VAT), 2) AS total_VAT
FROM     wm_sales_data
GROUP BY product_line
ORDER BY total_VAT DESC
LIMIT    1;
```

**Result Set :** 

product_line | total_VAT
|----| ----|
Food and beverages	| 2673.56

<br>



9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if it's greater than average sales.

```sql
SELECT DISTINCT product_line,
                total AS sales,
                CASE
                  WHEN total > Avg(total)THEN 'Good'
                  ELSE 'Bad'
                END   AS sales_category
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC; 
```

**Result Set :** 
product_line | sales | sales_category
|------| -------| ---- |
Electronic accessories | 	486.4440 | 	Good | 
Food and beverages | 	336.5565 | 	Good | 
Sports and travel | 	132.5625 | 	Bad | 
Health and beauty | 	131.9220 | 	Bad | 
Home and lifestyle | 	93.1140 | 	Bad | 
Fashion accessories | 	45.1080 | 	Bad | 

<br>



10. Which branch sold more products than average products sold?

```sql
SELECT   branch,
         Sum(quantity) AS total_qty
FROM     wm_sales_data
GROUP BY 1
HAVING   Sum(quantity) > Avg(quantity); 
```


11. What is the most common product line by gender?

```sql
WITH CTE
     AS (SELECT   product_line,
                  gender,
                  Count(*) AS line_count
         FROM     sales
         GROUP BY 1, 2)

SELECT gender,
       product_line,
       line_count
FROM   (SELECT gender,
               product_line,
               line_count,
               Row_number()
                 OVER (
                   partition BY gender
                   ORDER BY 3 DESC) AS rn
        FROM   CTE) AS ranked
WHERE  rn = 1; 
```

**Result Set :** 
gender | product_line | count | 
| --| --| --| 
Female | 	Fashion accessories | 	96 | 
Male | 	Health and beauty | 	88 | 


<br>


12. What is the average rating of each product line?

```sql
SELECT   product_line,
         ROUND(AVG(rating), 2) AS avg_rating
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC;
```

**Result Set :** 
product_line | avg_rating | 
|--|--| 
Food and beverages | 	7.11 | 
Fashion accessories | 	7.03 | 
Health and beauty | 	7 | 
Sports and travel | 	6.92 | 
Electronic accessories | 	6.92 | 
Home and lifestyle | 	6.84 | 


<br>


### `C. Customer-related questions`

1. How many unique customer types does the data have?

```sql
SELECT DISTINCT (customer_type)
FROM            wm_sales_data; 
```

**Result Set :** 

customer_type |
|---|
|Normal | 
|Member |


<br>


2. How many unique payment methods does the data have?

```sql
SELECT DISTINCT (payement_method)
FROM             wm_sales_data; 
```

**Result Set :** 

payment_method |
|---|
|Credit card|
|Ewallet|
|Cash|


<br>

3. What is the most common customer type?

```sql
SELECT   customer_type,
         Count(*) AS count
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```

**Result Set :** 
customer_type | count |
|---| ---|
|Member | 501 | 


<br>


4. Which customer type buys the most?

```sql
SELECT   customer_type,
         Round(Sum(total), 2) AS total
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1;
```

**Result Set :** 
customer_type | total |
|---| ---|
|Member | 164223.44 |


<br>


5. What is the gender of most of the customers?

```sql
SELECT   gender,
         Count(*) AS gender_count
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC; 
```

**Result Set :** 
gender | gender_count
|--|--|
Female | 	501 | 
Male | 	499 | 


<br>


6. What is the gender distribution per branch?

```sql
SELECT   gender,
         branch,
         Count(*) AS gender_count
FROM     wm_sales_data
GROUP BY 1,
         2; 
```

**Result Set :** 
branch | gender | branch_count | 
| --| --| --| 
A | 	Female | 	161 | 
A | 	Male | 	179 | 
B | 	Female | 	162 | 
B | 	Male | 	170 | 
C | 	Female | 	178 | 
C |	Male |	150 |

<br>


7. Which time of the day do customers give most ratings?

```sql
SELECT   time_of_day,
         ROUND(AVG(rating), 2) avg_rating
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC; 
```

**Result Set :** 
time_of_day | avg_rating |
|--|--| 
Afternoon |	7.03 |
Morning |	6.96 |
Evening |	6.93 |


<br>


8. Which time of the day do customers give most ratings per branch?

Approach 1:

```sql
SELECT   time_of_day,
         branch,
         ROUND(AVG(rating), 2) avg_rating
FROM     wm_sales_data
GROUP BY 1, 2
ORDER BY 2, 3 DESC; 
```

**Result Set :** 

time_of_day | branch | avg_rating |
--| --| --|
Afternoon |	A |	7.19 |
Morning |	A |	7.01 |
Evening |	A |	6.89 |
Morning |	B |	6.89 |
Afternoon |	B |	6.84 |
Evening |	B |	6.77 |
Evening |	C |	7.12 |
Afternoon |	C |	7.07 |
Morning |	C |	6.97 |


Approach 2:

```sql 
WITH cte
     AS (SELECT   branch,
                  time_of_day,
                  Round(Avg(rating), 2) AS average_rating,
                  Row_number()
                   OVER (
                     partition BY branch
                     ORDER BY Avg(rating) DESC) AS rn
         FROM     wm_sales_data
         GROUP BY branch,
                  time_of_day)
SELECT branch,
       time_of_day,
       average_rating
FROM   cte
WHERE  rn = 1; 
``` 


- **`Grouping and Averaging`**:

    - Use GROUP BY on branch and time_of_day.
    - Calculate the average rating for each group.

- **`Ranking`**: Utilize ROW_NUMBER() to assign a rank based on descending average ratings within each branch.

- **`Filtering`**: Select only the rows with rank 1, representing the highest average rating for each branch.



**Result Set :** 

branch | time_of_day | average_rating | 
--|--|--|
A | 	Afternoon | 	7.19 | 
B | 	Morning | 	6.89 | 
C | 	Evening | 	7.12 | 


<br>


9. Which day of the week has the best average ratings?

```sql
SELECT   day_name,
         Round(Avg(rating), 2) AS avg_rating
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC; 
```

**Result Set :** 
day_name | avg_rating | 
--|--|
Monday |	7.15 |
Friday |	7.08 |
Sunday |	7.01 |
Tuesday |	7 |
Saturday |	6.9 |
Thursday |	6.89 |
Wednesday |	6.81 |


<br>


10. Which day of the week has the best average ratings per branch?

```sql
SELECT   day_name,
         branch,
         Round(Avg(rating), 2) AS avg_rating
FROM     wm_sales_data
GROUP BY 1, 2
ORDER BY 2, 3 DESC; 
```

**Result Set :** 
day_name | branch |avg_rating | 
--|--|--|
Friday |	A |	7.31
Monday |	A |	7.1
Sunday |	A |	7.08
Tuesday |	A |	7.06
Thursday |	A |	6.96
Wednesday |	A |	6.92
Saturday |	A |	6.75
Monday |	B |	7.34
Tuesday |	B |	7
Sunday |	B |	6.89
Thursday |	B |	6.75
Saturday |	B |	6.74
Friday |	B |	6.69
Wednesday |	B |	6.45
Friday |	C |	7.28
Saturday |	C |	7.23
Wednesday |	C |	7.06
Monday |	C |	7.04
Sunday |	C |	7.03
Thursday |	C |	6.95
Tuesday |	C |	6.95

<!-- ```sql
WITH CTE AS (
    SELECT
        branch,
        DAYNAME(date_column) AS day_of_week,
        AVG(rating) AS average_rating,
        ROW_NUMBER() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rn
    FROM
        wm_sales_data
    GROUP BY
        branch, day_of_week
)
SELECT
    branch,
    day_of_week,
    average_rating
FROM
    CTE
WHERE
    rn = 1;
``` -->


<br>



`D. Sales-related questions`

1. Number of sales made in each time of the day per weekday.

```sql
SELECT   day_name,
         time_of_day,
         Count(*) AS sales_count
FROM     wm_sales_data
GROUP BY 1,
         2
ORDER BY 2,
         3; 
```

**Result Set :** 

day_name | time_of_day | sales_count |
--|--|--|
Monday |	Afternoon |	48
Thursday |	Afternoon |	49
Tuesday |	Afternoon |	53
Sunday |	Afternoon |	53
Saturday |	Afternoon |	55
Friday |	Afternoon |	58
Wednesday |	Afternoon |	61
Friday |	Evening |	52
Monday |	Evening |	56
Thursday |	Evening |	56
Sunday |	Evening |	58
Wednesday |	Evening |	60
Tuesday |	Evening |	69
Saturday |	Evening |	81
Monday |	Morning |	21
Wednesday |	Morning |	22
Sunday |	Morning |	22
Saturday |	Morning |	28
Friday |	Morning |	29
Thursday |	Morning |	33
Tuesday |	Morning |	36

<br>


2. Which of the customer types brings the most revenue?

```sql
SELECT   customer_type,
         Round (Sum(total), 2) AS total_revenue
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC; 
```

**Result Set :** 
customer_type | total_revenue |
--|--|
Member |	164223.44 |
Normal |	158743.31 |


<br>


3. Which city has the largest tax percent/VAT (Value Added Tax)?

```sql
SELECT   city,
         Round(Avg(vat), 2) AS value_added_tax
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC;
```

**Result Set :** 
city | value_added_tax |
--|--|
Naypyitaw |	16.05 |
Mandalay |	15.23 |
Yangon |	14.87 |


<br>


4. Which customer type pays the most in VAT?

```sql
SELECT   customer_type,
         Round(Avg(vat), 2) AS value_added_tax
FROM     wm_sales_data
GROUP BY 1
ORDER BY 2 DESC;
```

**Result Set :** 
customer_type | value_added_tax |
--|--|
Member |	15.61 |
Normal |	15.15 |



<br>

