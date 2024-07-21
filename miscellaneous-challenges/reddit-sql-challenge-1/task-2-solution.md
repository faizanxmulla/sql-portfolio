### Approach

**1. Combine Billable Items (Bookings, Extras, and Cancellations)**:

- Bookings:

    - Select booking details, customer information, transaction date (out_date), description, and amount.

    - Calculate the rental amount using the formula: ((ret_date - out_date) + 1) * daily_rate + discount.

- Extras:

    - Select extra details, customer information (using COALESCE to handle NULL values), transaction date (trans_date), description, and amount.

    - Join with bookings to ensure all relevant customer information is included.


- Cancellations:

    - Select booking details, customer information, transaction date (out_date), and a fixed amount for cancellation fee.

    - Include only those bookings which are cancelled.


**2. Assign Invoice and Line Numbers:**

- Generate unique line numbers (line_id) for each invoice line item, partitioned by the customer and month.

- Generate unique invoice numbers (invoice_id) for each customer and month combination.


**3. Insert into Invoices Table:**

- Insert the combined and processed billable items into the invoices table.

- The invoice_date is set to the last day of the month for each transaction date.


**4. Verify the Results:**

Select all entries from the invoices table to ensure the data has been correctly inserted and ordered.



### Solution Query:


```sql
-- Step 1: Create a CTE for all billable items (bookings and extras)
WITH billable_items AS (
    -- Bookings
    SELECT b.booking_id,
           NULL AS extra_id,
           b.customer_id,
           c.name AS customer_name,
           b.out_date AS trans_date,
           CONCAT('Rental: ', ca.brand, ' ', ca.model) AS description,
	       ((b.ret_date - b.out_date) + 1) * dr.daily_rate + b.discount AS amount
    FROM   bookings b JOIN customers c USING(customer_id)
                      JOIN cars ca USING(car_id)
                      JOIN default_rates dr USING(rate_id)
    WHERE  NOT b.is_cancelled

    UNION ALL

    -- Extras
    SELECT e.booking_id,
           e.extra_id,
           COALESCE(e.customer_id, b.customer_id) AS customer_id,
           c.name AS customer_name,
           e.trans_date,
           e.description,
           e.amount
    FROM   extras e LEFT JOIN bookings b USING(booking_id)
                         JOIN customers c ON COALESCE(e.customer_id, b.customer_id) = c.customer_id

    UNION ALL

    -- Cancellations
    SELECT b.booking_id,
           NULL AS extra_id,
           b.customer_id,
           c.name AS customer_name,
           b.out_date AS trans_date,
           'Cancellation fee' AS description,
           100.00 AS amount
    FROM   bookings b JOIN customers c USING(customer_id)
    WHERE  b.is_cancelled
),
-- Step 2: Generate invoice numbers
numbered_items AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('month', trans_date), customer_id 
                              ORDER BY trans_date, booking_id, extra_id) AS line_id,
           ROW_NUMBER() OVER (ORDER BY DATE_TRUNC('month', trans_date), customer_id) AS invoice_id
    FROM   billable_items
)
-- Step 3: Insert into invoices table
INSERT INTO invoices (
    invoice_id, line_id, invoice_date, customer_id, customer_name,
    booking_id, extra_id, line_descr, amount
)
SELECT   invoice_id,
    	 line_id,
    	 DATE_TRUNC('month', trans_date) + INTERVAL '1 month' - INTERVAL '1 day' AS invoice_date,
    	 customer_id,
    	 customer_name,
    	 booking_id,
    	 extra_id,
    	 description AS line_descr,
    	 amount
FROM     numbered_items
ORDER BY 1, 2

-- Verify the results
SELECT   * 
FROM     invoices
ORDER BY invoice_id, line_id;
```


### Result Set: 

*only the first 10 out of 57 total rows*

![image](https://github.com/user-attachments/assets/0cd286ed-f34f-4647-859c-a3fae4865429)
