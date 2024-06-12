-- Find the best selling item for each month (no need to separate months by year) where the biggest total invoice was paid. 

-- The best selling item is calculated using the formula (unitprice * quantity). Output the month, the description of the item along with the amount paid.

-- Table: online_retail

-- invoiceno: varchar
-- stockcode: varchar
-- description: varchar
-- quantity: int
-- invoicedate: datetime
-- unitprice: float
-- customerid: float
-- country: varchar


WITH total_amount_cte AS (
    SELECT   TO_CHAR(invoicedate, 'YYYY-MM') AS year_month, 
            description,
            SUM(unit_price * quantity) AS amount_paid
    FROM     online_retail
    GROUP BY 1, 2
),
ranked_items AS (
    SELECT year_month, 
        description, 
        amount_paid, 
        DENSE_RANK() OVER(PARTITION BY month ORDER BY amount_paid DESC) AS dr
    FROM   total_amount_cte
)
SELECT month, description, amount_paid  
FROM   ranked_items
WHERE  dr=1