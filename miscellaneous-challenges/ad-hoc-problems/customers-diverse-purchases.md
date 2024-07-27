### Problem Statement

**Write a SQL query to identify the top 5 customers who have made purchases across the most diverse set of product categories.** 

Consider only transactions where the customer spent more than the 75th percentile amount for that category in a single transaction. Exclude categories where the customer's lifetime value is below the median for that category.

For each of these customers, list their ID, name, the number of qualifying categories, and a comma-separated list of their top 3 most frequently purchased products (by quantity). Also, calculate a "loyalty score" that takes into account their total spend, frequency of purchases, and the recency of their last purchase, all weighted equally.

Finally, include a column showing the percentage of total revenue these top 5 customers represent compared to the entire customer base. Order the result set by the calculated loyalty score in descending order.



### Schema setup

```sql
CREATE TABLE Customers (
    CustomerID INT,
    CustomerName VARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(255),
    CategoryID INT
);

CREATE TABLE Categories (
    CategoryID INT,
    CategoryName VARCHAR(255)
);

CREATE TABLE Transactions (
    TransactionID INT,
    CustomerID INT,
    ProductID INT,
    Quantity INT,
    TransactionDate DATE,
    TransactionAmount FLOAT
);

INSERT INTO Customers (CustomerID, CustomerName) VALUES
(1, 'Alice Johnson'),
(2, 'Bob Smith'),
(3, 'Charlie Brown'),
(4, 'Diana Prince');

INSERT INTO Categories (CategoryID, CategoryName) VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Books');

INSERT INTO Products (ProductID, ProductName, CategoryID) VALUES
(1, 'Laptop', 1),
(2, 'Smartphone', 1),
(3, 'T-shirt', 2),
(4, 'Jeans', 2),
(5, 'Novel', 3),
(6, 'Magazine', 3);

INSERT INTO Transactions (TransactionID, CustomerID, ProductID, Quantity, TransactionDate, TransactionAmount) VALUES
(1, 1, 1, 1, '2024-01-15', 1000.00),
(2, 1, 3, 2, '2024-02-10', 50.00),
(3, 2, 2, 1, '2024-03-05', 800.00),
(4, 2, 5, 1, '2024-04-12', 20.00),
(5, 3, 4, 1, '2024-05-20', 40.00),
(6, 3, 6, 3, '2024-06-15', 15.00),
(7, 4, 1, 2, '2024-07-01', 2000.00),
(8, 4, 5, 4, '2024-07-25', 80.00);
```

### Solution Query

```sql
WITH get_lifetime_values AS (
	SELECT   categoryid, customerid, SUM(transactionamount) AS lifetime_value
	FROM     transactions t JOIN products p USING(productid)   
	GROUP BY 1, 2
),
get_75th_category_percentile AS (
	SELECT   categoryid, 
	         PERCENTILE_CONT(0.75) WITHIN GROUP(ORDER BY transactionamount) as "75th_percentile"          
	FROM     transactions t JOIN products p USING(productid)
	GROUP BY 1
),
get_median_category_percentile AS (
	SELECT   categoryid, 
	         PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY lifetime_value) as "50th_percentile"
	FROM     get_lifetime_values
	GROUP BY 1
),
get_qualifying_categories AS (
	SELECT   categoryid, t.customerid
	FROM     transactions t JOIN products p USING(productid)
				JOIN get_75th_category_percentile cp USING(categoryid) 
				JOIN get_median_category_percentile mcp USING(categoryid)
				JOIN get_lifetime_values glv USING(customerid, categoryid)
	WHERE    lifetime_value > "50th_percentile" AND transactionamount > "75th_percentile"
	ORDER BY 1, 2
),
get_categories_count AS (
	SELECT   customerid, COUNT(categoryid) as qualified_categories_count
	FROM     get_qualifying_categories
	GROUP BY 1
),
get_total_quantity AS (
	SELECT   customerid, 
	         productname, 
	         SUM(quantity) AS total_quantity,
	         ROW_NUMBER() OVER(PARTITION BY customerid ORDER BY SUM(quantity) DESC) AS rn
	FROM     transactions t JOIN products p USING(productid)
	GROUP BY 1, 2
	ORDER BY 1, 3 DESC
),
get_top_products AS (
	SELECT   customerid, STRING_AGG(productname, ', ') as top_3_products
	FROM     get_total_quantity
	WHERE    rn < 4
	GROUP BY 1
),
get_customer_metrics AS (
	SELECT   customerid, 
		 SUM(transactionamount) as total_spend, 
		 COUNT(DISTINCT transactiondate) as purchase_frequency,
		 MAX(transactiondate) as last_purchase_date  
	FROM     transactions
	GROUP BY 1
),
get_loyalty_score AS (
	SELECT customerid, 
	       ( 
                    PERCENT_RANK() OVER(ORDER BY total_spend) +
                    PERCENT_RANK() OVER(ORDER BY purchase_frequency) +
	            PERCENT_RANK() OVER(ORDER BY last_purchase_date)
	        ) / 3 * 100 AS loyalty_score
	FROM   get_customer_metrics
),
get_revenue_contribution AS (
	SELECT   customerid, 
                 SUM(transactionamount) / SUM(SUM(transactionamount)) OVER() as revenue_contribution_percentage  
	FROM     transactions
	GROUP BY 1
)
SELECT   c.customerid,
         c.customername,
         qualified_categories_count,
         top_3_products,
         ROUND(loyalty_score::numeric, 2) AS loyalty_score,
         ROUND(revenue_contribution_percentage::numeric * 100, 2) AS revenue_contribution_percentage
FROM     customers c JOIN get_categories_count gcc USING(customerid)
                     JOIN get_top_products gtp USING(customerid)   
                     JOIN get_loyalty_score gls USING(customerid)
                     JOIN get_revenue_contribution grc USING(customerid)
ORDER BY 5 DESC
LIMIT    5
```

### Output:

customerid | customername |	qualified_categories_count |	top_3_products |	loyalty_score |	revenue_contribution_percentage |
--|--|--|--|--|--|
4 |	Diana Prince |	2 |	Novel, Laptop |	66.67 |	51.94 |
1 |	Alice Johnson |	1 |	T-shirt, Laptop |	22.22 |	26.22 |
