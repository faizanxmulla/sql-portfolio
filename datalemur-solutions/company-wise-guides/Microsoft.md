## 9 Microsoft SQL Interview Questions

### 1. Who are the top-tier users based on software purchase frequency at Microsoft?

You are a data scientist at Microsoft, and your task is to identify the power users who contribute significantly to the business by purchasing software products frequently. 

**Write a SQL query to identify users with the highest frequency of software purchases**. Top-tier or VIP users are those who have made more than 10 purchases in the last month.

Here's sample data for the problem.

`purchases` **Example Input:**

| purchase_id | user_id | purchase_date       | product_name | product_price |
|-------------|---------|----------------------|--------------|---------------|
| 8731        | 105     | 08/02/2022 00:00:00 | Windows 11   | $100.00       |
| 7865        | 265     | 08/04/2022 00:00:00 | Office 365   | $79.99        |
| 7254        | 678     | 08/08/2022 00:00:00 | Visual Studio| $199.99       |
| 8274        | 105     | 08/12/2022 00:00:00 | Office 365   | $79.99        |
| 9381        | 451     | 08/14/2022 00:00:00 | Windows 11   | $100.00       |
| 8303        | 105     | 08/20/2022 00:00:00 | Visual Studio| $199.99       |
| 9382        | 678     | 08/22/2022 00:00:00 | Office 365   | $79.99        |
| 9303        | 678     | 08/25/2022 00:00:00 | Windows 11   | $100.00       |
| 8844        | 451     | 08/27/2022 00:00:00 | Office 365   | $79.99        |
| 9754        | 678     | 08/30/2022 00:00:00 | Visual Studio| $199.99       |
| 9881        | 105     | 08/31/2022 00:00:00 | Windows 11   | $100.00       |

**Answer:**

```sql
SELECT   user_id, COUNT(*) as purchase_count
FROM     purchases
WHERE    MONTH(purchase_date) = 8
GROUP BY 1
HAVING   COUNT(*) > 10
ORDER BY 2 DESC;
```



---

### 2. Calculate Monthly Average of Product Ratings With Window Function
Suppose that Microsoft wants to understand customer satisfaction with various products. As part of this analysis, you have been tasked to calculate a monthly average of product ratings provided by customers.

You have been given access to a ProductReviews table in Microsoft's SQL Server Database, with the following schema:

`ProductReviews` **Example Input:**

| review_id | user_id | submit_date | product_id | stars |
|-----------|---------|-------------|------------|-------|
| 6171      | 123     | 2022-06-08  | 1001       | 4     |
| 7802      | 265     | 2022-06-10  | 1002       | 4     |
| 5293      | 362     | 2022-06-18  | 1001       | 3     |
| 6352      | 192     | 2022-07-26  | 1002       | 3     |
| 4517      | 981     | 2022-07-05  | 1002       | 2     |

The submit_date column is in 'YYYY-MM-DD' format. 

**Write a SQL query that calculates the monthly average star rating for each product.**


**Example Output:**

| month | product_id | avg_stars |
|-------|------------|-----------|
| 6     | 1001       | 3.50      |
| 6     | 1002       | 4.00      |
| 7     | 1002       | 2.50      |

**Answer:**


```sql
SELECT   MONTH(submit_date) AS month, 
         product_id,
         AVG(stars) OVER(PARTITION BY MONTH(submit_date), product_id) AS avg_stars 
FROM     ProductReviews 
ORDER BY 1, 2
```


---

### 3. What's denormalization, and when does it make sense to do it?
Imagine you've got giant AF jigsaw puzzle with thousands of pieces, and each piece represents a piece of data in your database. You've spent hours organizing the puzzle into neat little piles, with each pile representing a table in your database. This process is called normalization, and it's a great way to make your database efficient, flexible, and easy to maintain.

But what if you want to solve the puzzle faster (aka make your queries run faster?)?

That's where denormalization comes in – Denormalization is like the puzzle-solving equivalent of taking a shortcut!

Instead of putting all the pieces in separate piles, you might decide to clone some of the pieces, and then have that one puzzle piece be put into multiple piles. Clearly, we are breaking the rules of physics, but that's just like de-normalization because it breaks the normal rules of normalization (1st, 2nd, 3rd normal forms).

By adding redundant puzzle pieces, it can be easier to find the pieces you need, but it also means that you have to be extra careful when you're moving pieces around or adding new ones (aka INSERT/UPDATE commands become more complex).

On the plus side, denormalization can improve the performance of your database and make it easier to use. On the downside, it can make your database more prone to errors and inconsistencies, and it can be harder to update and maintain. In short, denormalization can be a helpful tool, but it's important to use it wisely!

Pro Tip: Window functions are a frequent SQL interview topic, so practice every window function problem on [DataLemur](https://datalemur.com/questions/sql-practice).

---

### 4. Data Storage for Microsoft's Computer Hardware Production Details
Suppose you are working as an SQL Developer at Microsoft and you are tasked with designing a database to store information related to the company's computer hardware production. This data includes details about each hardware's type, production dates, unit cost, and the region where it was produced.

To model this scenario, we can suggest three tables: `hardware`, `production`, and `region`.

`hardware` table specifies the properties of each hardware.

`hardware` **Example Input:**

| hardware_id | type          | unit_cost |
|-------------|---------------|-----------|
| 1001        | Surface Laptop| 1000.00   |
| 1002        | Surface Pro   | 1500.00
| 1003        | Surface Studio| 2500.00   |
| 1004        | Surface Mouse | 50.00     |
| 1005        | Surface Keyboard| 75.00   |

`production` table holds the data of the hardware production including production date and the quantity of hardware produced.

`production` **Example Input:**

| production_id | hardware_id | production_date    | quantity |
|---------------|-------------|---------------------|----------|
| 2001          | 1001        | 06/08/2022 00:00:00| 200      |
| 2002          | 1002        | 06/10/2022 00:00:00| 150      |
| 2003          | 1003        | 06/14/2022 00:00:00| 100      |
| 2004          | 1004        | 06/12/2022 00:00:00| 500      |
| 2005          | 1005        | 06/20/2022 00:00:00| 400      |

`region` table records where each hardware was specifically produced.

`region` **Example Input:**

| region_id | production_id | region_name    |
|-----------|----------------|-----------------|
| 3001      | 2001          | United States  |
| 3002      | 2002          | China          |
| 3003      | 2003          | Germany        |
| 3004      | 2004          | India          |
| 3005      | 2005          | Brazil         |

Now, the company wants to **calculate the total cost of hardware products produced in each region in June 2022.**

**Answer:**

```sql
SELECT   r.region_name, SUM(h.unit_cost * p.quantity) AS total_cost
FROM     hardware h JOIN production p USING(hardware_id)
                    JOIN region r USING(production_id)
WHERE    MONTH(p.production_date) = 6 AND YEAR(p.production_date) = 2022
GROUP BY 1
```




---

### 5. What's the difference between window functions RANK() and DENSE_RANK()?

As the name implies, the RANK() window function ranks each row within your window/partition. If two rows have the same rank, the next number in the ranking will be the previous rank plus the number of duplicates. For example, if you've got three records tied for 5th place, they'll get the values 5, 6, and 7, and the next row after this 3-way tie will have a rank of 8.

The DENSE_RANK() function assigns a distinct rank to each row within a partition based on the provided column value with no gaps. This function will assign the same rank to two rows if they have the same rank, and give the next row the next rank number. To make this more concrete, imagine you had three records at rank 5 – then, the next rank would be 6.

RANK vs. DENSE_RANK details tutorial here: https://datalemur.com/sql-tutorial/sql-rank-dense_rank-row_number-window-function


---

### 6. Filtering Customer Records for Sales Analysis

As a Data Analyst at Microsoft, you are tasked with analyzing the sales performance of different software products over the years. The analysis requires you to filter out records from the 'Sales' database where the 'product_type' is 'software', the 'sales_year' is greater than 2015, and the 'sales_region' is not 'Europe'.

`sales` **Example Input:**

| sales_id | customer_id | product_id | product_type | sales_year | sales_region   | units_sold |
|----------|-------------|------------|--------------|------------|-----------------|------------|
| 1        | AB123       | S1001      | Software     | 2022       | North America  | 150        |
| 2        | AD768       | S1002      | Hardware     | 2021       | Europe         | 65         |
| 3        | AB123       | S1003      | Software     | 2020       | Asia           | 200        |
| 4        | BD672       | S1001      | Software     | 2016       | Europe         | 100        |
| 5        | CD980       | S1003      | Software     | 2015       | North America  | 80         |
| 6        | AB123       | S1002      | Software     | 2022       | Europe         | 120        |
| 7        | AD768       | S1001      | Software     | 2019       | Asia           | 85         |

**Example Output:**

| sales_id | customer_id | product_id | product_type | sales_year | sales_region   | units_sold |
|----------|-------------|------------|--------------|------------|-----------------|------------|
| 1        | AB123       | S1001      | Software     | 2022       | North America  | 150        |
| 3        | AB123       | S1003      | Software     | 2020       | Asia           | 200        |
| 7        | AD768       | S1001      | Software     | 2019       | Asia           | 85         |

**Answer:**

```sql
SELECT *
FROM   Sales
WHERE  product_type = 'Software' AND 
       sales_year > 2015 AND NOT 
       sales_region = 'Europe';
```



---

### 7. What's a primary key?

A primary key is a column or set of columns in a table that uniquely identifies each row in the table. The primary key is used to enforce the uniqueness and non-nullability of the rows in the table.

In a SQL database, a primary key is defined using the PRIMARY KEY constraint. For example, say you had a table of microsoft_employees:

```sql
CREATE TABLE microsoft_employees (
    EmployeeID INTEGER PRIMARY KEY,
    LastName VARCHAR(255),
    FirstName VARCHAR(255),
    Age INTEGER,
    Salary DECIMAL(8,2)
);
```

In this example, the EmployeeID column is the primary key of the Microsoft employees table. It is defined as an integer and is marked as the primary key using the PRIMARY KEY constraint.

A table can have only one primary key, but the primary key can consist of multiple columns. For example, say you had a table of Microsoft customer transactions:

```sql
CREATE TABLE transactions (
    TransactionID INTEGER,
    ProductID INTEGER,
    Quantity INTEGER,
    PRIMARY KEY (TransactionID, ProductID)
);
```

In the above example, the primary key of the Orders table consists of two columns: TransactionID and ProductID. This means that the combination of OrderID and ProductID must be unique for every row in the table.

---

### 8. Analyzing Click-Through and Conversion Rates for Microsoft Digital Products

Microsoft wants to analyze the click-through rates of their digital ads and the conversion rates from viewing a product page to adding the product to the shopping cart, across different product categories. They are specifically interested in their popular categories: 'Software', 'Games', 'Hardware', and 'Services'.

To accomplish this, they provided you with two tables, 'clicks' and 'conversions', containing the following data:

`clicks` **Example Input:**

| click_id | user_id | click_date          | product_id | product_category |
|----------|---------|----------------------|------------|------------------|
| 1        | 101     | 06/01/2022 00:00:00 | 001        | Software         |
| 2        | 102     | 06/02/2022 00:00:00 | 002        | Games            |
| 3        | 103     | 06/03/2022 00:00:00 | 003        | Hardware         |
| 4        | 101     | 06/04/2022 00:00:00 | 004        | Services         |
| 5        | 102     | 06/05/2022 00:00:00 | 005        | Services         |

`conversions` **Example Input:**

| conversion_id | user_id | conversion_date     | product_id |
|---------------|---------|----------------------|------------|
| 901           | 101     | 06/01/2022 00:00:00 | 001        |
| 902           | 102     | 06/02/2022 00:00:00 | 002        |
| 903           | 101     | 06/01/2022 00:00:00 | 001        |
| 904           | 101     | 06/04/2022 00:00:00 | 004        |

**Write a SQL query to calculate both the click-through rates** (ratio of clicks to total unique users) **and conversion rates** (ratio of users who add the product to the shopping cart to total unique users viewed the product) **for each product category, for the month of June 2022.**

**Answer:**

```sql
WITH Click_Rates AS (
    SELECT   product_category, COUNT(DISTINCT user_id) AS unique_clicks
    FROM     clicks
    WHERE    DATE(click_date) BETWEEN '2022-06-01' AND '2022-06-30'
    GROUP BY 1),

Conversion_Rates AS (
    SELECT   c.product_category, COUNT(DISTINCT v.user_id) AS unique_conversions
    FROM     conversions v JOIN clicks c USING(product_id, user_id) 
    WHERE    DATE(conversion_date) BETWEEN '2022-06-01' AND '2022-06-30'
    GROUP BY 1)

SELECT cr.product_category,
       unique_clicks,
       COALESCE(unique_conversions, 0) AS unique_conversions,
       (unique_clicks * 1.0 / (
            SELECT COUNT(DISTINCT user_id) 
            FROM   clicks 
            WHERE  DATE(click_date) BETWEEN '2022-06-01' AND '2022-06-30')) AS click_through_rate,
      (COALESCE(unique_conversions, 0) * 1.0 / unique_clicks) AS conversion_rate
FROM Click_Rates clr LEFT JOIN Conversion_Rates cor USING(product_category)
```



---

### 9. Filter customer records matching specific pattern

Microsoft HR team often tracks the progress and performance of its employees. Each employee is classified into different departments based on their job description. 

However, recently a lot of employees have joined departments that are related to Artificial Intelligence. As a database officer, you are asked to **filter the employee records for any department that includes the word 'AI' in its description**.

`employees` **Example Input:**

| emp_id | first_name | last_name | email                   | job_description        |
|--------|------------|------------|-----------------------|------------------------|
| 3521   | John       | Smith     | johnsmith@microsoft.com| Software Engineer - AI |
| 4678   | Jane       | Doe       | janedoe@microsoft.com  | Product Manager - AI   |
| 5732   | Mike       | Jones     | mikejones@microsoft.com| Data Analyst           |
| 8391   | Emma       | Williams  | emmawilliams@microsoft.com| AI Research Scientist  |
| 5347   | Bob        | Johnson   | bobjohnson@microsoft.com| Network Engineer       |

`departments` **Example Output:**

| emp_id | first_name | last_name | email                   | job_description        |
|--------|------------|------------|-------------------------|------------------------|
| 3521   | John       | Smith     | johnsmith@microsoft.com | Software Engineer - AI |
| 4678   | Jane       | Doe       | janedoe@microsoft.com   | Product Manager - AI   |
| 8391   | Emma       | Williams  | emmawilliams@microsoft.com | AI Research Scientist  |

**Answer:**

```sql
SELECT *
FROM   employees
WHERE  job_description LIKE '%AI%';
```
--- 