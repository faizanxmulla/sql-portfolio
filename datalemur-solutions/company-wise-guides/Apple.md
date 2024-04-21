## 10 Apple SQL Interview Questions


### 1. Identify Apple's In-App Power Purchasers

Apple maintains a database of its customers who have made purchases from their App Store. A power user, as defined by Apple, is a customer who has at least made 10 in-app purchases each month in the last year.

The task is to identify the power users of the App Store.

The 'purchases' table logs each purchase. Some example data is as follows:

`purchases` Example Input:

The 'users' table logs each user's details. Some example data is:

| purchase_id | user_id | purchase_date       | amount |
| ----------- | ------- | ------------------- | ------ |
| 1347        | 188     | 06/08/2022 00:00:00 | 1.99   |
| 2103        | 223     | 06/10/2022 00:00:00 | 0.99   |
| 1005        | 957     | 06/10/2022 00:00:00 | 2.99   |
| 1502        | 188     | 06/11/2022 00:00:00 | 0.99   |
| 1762        | 957     | 06/18/2022 00:00:00 | 1.99   |

`users` Example Input:

| user_id | join_date           | email                |
| ------- | ------------------- | -------------------- |
| 188     | 01/01/2021 00:00:00 | johndoe@icloud.com   |
| 223     | 02/15/2022 00:00:00 | janedoe@icloud.com   |
| 957     | 03/20/2022 00:00:00 | robertdoe@icloud.com |

#### `Solution`:

```sql
SELECT u.user_id, u.email
FROM users u JOIN (
    SELECT   p.user_id
    FROM     purchases p
    WHERE    p.purchase_date BETWEEN (CURRENT_DATE() - INTERVAL 1 YEAR) AND CURRENT_DATE()
    GROUP BY YEAR(p.purchase_date), MONTH(p.purchase_date), p.user_id
    HAVING   COUNT(p.purchase_id) >= 10
) AS monthly_purchases
ON u.user_id = monthly_purchases.user_id
GROUP BY u.user_id
HAVING   COUNT(monthly_purchases.user_id) = 12;
```

---

### 2. [Device Trade-In Payouts](https://datalemur.com/questions/trade-in-payouts)

Apple has a trade-in program where their customers can return the old iPhone device to Apple and Apple gives the customers the trade-in value (known as payout) of the device in cash.

For each store, write a SQL query of the total revenue from the trade-in. Order the result by the descending order.

`trade_in_transactions` Table:

| Column Name      | Type    |
| ---------------- | ------- |
| transaction_id   | integer |
| model_id         | integer |
| store_id         | integer |
| transaction_date | date    |

`trade_in_transactions` Example Input:

| transaction_id | model_id | store_id | transaction_date |
| -------------- | -------- | -------- | ---------------- |
| 1              | 112      | 512      | 01/01/2022       |
| 2              | 113      | 512      | 01/01/2022       |

`trade_in_payouts` Table:

| Column Name   | Type    |
| ------------- | ------- |
| model_id      | integer |
| model_name    | string  |
| payout_amount | integer |

`trade_in_payouts` Example Input:

| model_id | model_name        | payout_amount |
| -------- | ----------------- | ------------- |
| 111      | iPhone 11         | 200           |
| 112      | iPhone 12         | 350           |
| 113      | iPhone 13         | 450           |
| 114      | iPhone 13 Pro Max | 650           |

Example Output:

| store_id | payout_total |
| -------- | ------------ |
| 512      | 800          |

#### `Solution`:

```sql
SELECT   store_id, SUM(payout_amount) as payout_total
FROM     trade_in_transactions tt JOIN trade_in_payouts tp USING(model_id)
GROUP BY 1
ORDER BY 2 DESC
```

---

### 3. Analyzing Apple Product Performance based on Reviews

Given a `reviews` table containing data related to product reviews submitted by users over time, write a SQL query to calculate the monthly average rating for each Apple product. The `reviews` table has the following schema:

- `review_id`: An integer that uniquely identifies each review

- `user_id`: An integer that identifies the user who submitted the review
- `submit_date`: A datetime value that represents when the review was submitted
- `product_id`: An integer that identifies the product being reviewed
- `stars`: An integer that indicates the number of stars the product received in the review (from 1 to 5)

Please note that for the purposes of this problem, you can assume that the `product_id` corresponds to an Apple product, and the `submit_date` for each review is in the format "MM/DD/YYYY HH:MI:SS".

`reviews` Example Input:

| review_id | user_id | submit_date         | product_id | stars |
| --------- | ------- | ------------------- | ---------- | ----- |
| 617       | 11230   | 06/08/2022 00:00:00 | 5000       | 1     |
| 6780      | 22650   | 06/10/2022 00:00:00 | 6985       | 4     |
| 24529     | 33620   | 06/18/2022 00:00:00 | 5000       | 3     |
| 3635      | 21920   | 07/26/2022 00:00:00 | 6985       | 2     |
| 3451      | 79810   | 07/05/2022 00:00:00 | 6985       | 2     |

Example Output:

| mth | product | avg_stars |
| --- | ------- | --------- |
| 6   | 5000    | 3.5       |
| 6   | 6985    | 4.0       |
| 7   | 6985    | 2.5       |

#### `Solution`:

```sql
SELECT   EXTRACT(MONTH FROM submit_date) as mth, product_id as product, AVG(stars) as avg_stars
FROM     reviews
GROUP BY 1, 2
```

---

### 4. In database design, what do foreign keys do?

A **foreign key** is a column or group of columns in a table that refers to the **primary key** in another table. The foreign key constraint helps maintain referential integrity between the two tables.

For example, imagine you worked on Apple's People Analytics team, and wanted to analyze data from Apple's HR database:

`apple_employees`:

| employee_id | first_name | last_name | manager_id |
| ----------- | ---------- | --------- | ---------- |
| 1           | Aubrey     | Graham    | 3          |
| 2           | Marshal    | Mathers   | 3          |
| 3           | Dwayne     | Carter    | 4          |
| 4           | Shawn      | Carter    | 4          |

In this table, `employee_id` serves as the primary key and `manager_id` functions as a foreign key because it links to the `employee_id` of the employee's manager. This establishes a relationship between Apple employees and their managers, allowing for easy querying to find an employee's manager or see which employees report to a specific manager.

The `apple_employees` table may also have multiple foreign keys that reference primary keys in other tables. For example, `department_id` and `location_id` foreign keys could be used to connect each employee to their respective department and location.

---

### 5. Average Sales of Apple Products

As a data analyst at Apple, you need to understand the sales performance of different Apple products over time to make informed business decisions, but also to make make pretty charts like this:

You're given two tables: `products` and `sales`. In the `products` table, each row represents a different product, identified by `product_id`, sold by Apple. The `sales` table contains data about the sales of these products, including `quantity_sold` and `date_of_sale`.

**Write a SQL query to compute the average quantity of each product sold per month for the year 2021.**

Example Tables,

`products` table:

| product_id | product_name |
| ---------- | ------------ |
| 1          | iPhone 12    |
| 2          | Apple Watch  |
| 3          | MacBook Pro  |

`sales` table:

| sales_id | product_id | date_of_sale | quantity_sold |
| -------- | ---------- | ------------ | ------------- |
| 1        | 1          | 2021-01-10   | 100           |
| 2        | 1          | 2021-01-15   | 200           |
| 3        | 2          | 2021-01-20   | 50            |
| 4        | 2          | 2021-02-17   | 75            |
| 5        | 3          | 2021-02-10   | 20            |

#### `Solution`:

```sql
SELECT   product_id, product_name,  EXTRACT(MONTH FROM date_of_sale) as month, AVG(quantity_sold)
FROM     sales s JOIN products p USING(product_id)
WHERE    EXTRACT(YEAR FROM date_of_sale)='2021'
GROUP BY 1, 2, 3
```

---

### 6. What's a stored procedure?

Stored procedures are like functions in Python – they can accept input params and return values, and are used to encapsulate complex logic.

For example, if you worked as a Data Analyst in support of the Marketing Analytics team at Apple, a common task might be to find the conversion rate for your ads given a specific time-frame. Instead of having to write this query over-and-over again, you could write a stored procedure like the following:

```sql
CREATE FUNCTION get_conversion_rate(start_date DATE, end_date DATE, event_name TEXT)
RETURNS NUMERIC AS
$BODY$
BEGIN
  RETURN (SELECT COUNT(*) FROM events WHERE event_date BETWEEN start_date AND end_date AND event_name = 'conversion')
         / (SELECT COUNT(*) FROM events WHERE event_date BETWEEN start_date AND end_date AND event_name = 'impression');
END;
$BODY$
LANGUAGE 'plpgsql';
```

To call this stored procedure, you'd execute the following query:

```sql
SELECT get_conversion_rate('2023-01-01', '2023-01-31', 'conversion');
```


---- 

### 7. Calculate Add-to-Bag Conversion Rate for Apple Store

Suppose you are working as a Data Analyst on the Apple Store Digital team. Your focused on improving the conversion of people who clicked on a product to those who added it to their bag (shopping cart).

You are given the following two tables:

#### `clicks` Example Input:

| click_id | product_id | user_id | click_time |
|----------|------------|---------|------------|
| 1 | 5001 | 12306 | 06/08/2022 00:00:00 |
| 2 | 6001 | 4560 | 06/10/2022 00:00:00 |
| 3 | 5001 | 7890 | 06/18/2022 00:00:00 |
| 4 | 7001 | 3210 | 07/26/2022 00:00:00 |
| 5 | 5001 | 6540 | 07/05/2022 00:00:00 |

#### `bag_adds` Example Input:

| add_id | product_id | user_id | add_time |
|--------|------------|---------|----------|
| 1 | 5001 | 12306 | 06/08/2022 00:02:00 |
| 2 | 6001 | 4560 | 06/10/2022 00:01:00 |
| 3 | 5001 | 7890 | 06/18/2022 00:03:00 |
| 4 | 7001 | 3210 | 07/26/2022 00:04:00 |
| 5 | 5001 | 9850 | 07/05/2022 00:05:00 |

Your task is to write a SQL query that calculates the add-to-bag conversion rate, defined as the number of users who add a product to their bag (cart) after clicking on the product listing, divided by the total number of clicks on the product. Break down the result by product_id.

#### `Solution`:

```sql
SELECT   c.product_id, 
         SUM(CASE WHEN a.add_id IS NULL THEN 0 ELSE 1 END) / COUNT(c.click_id) as conversion_rate
FROM     clicks c JOIN bag_adds ba ON ba.product_id = c.product_id AND ba.user_id = c.user_id
GROUP BY 1
```

---


### 8. How is the `FOREIGN KEY` constraint used in a database?

A `FOREIGN KEY` is a field in a table that references the `PRIMARY KEY` of another table. It creates a link between the two tables and ensures that the data in the `FOREIGN KEY` field is valid.

Say for example you had sales analytics data from Apple's CRM (customer-relationship management) tool.

```sql
CREATE TABLE apple_accounts (
    account_id INTEGER PRIMARY KEY,
    account_name VARCHAR(255) NOT NULL,
    industry VARCHAR(255) NOT NULL
);

CREATE TABLE opportunities (
    opportunity_id INTEGER PRIMARY KEY,
    opportunity_name VARCHAR(255) NOT NULL,
    account_id INTEGER NOT NULL,
    FOREIGN KEY (account_id) REFERENCES apple_accounts(account_id)
);
```

The FOREIGN KEY constraint ensures that the data in the `account_id` field of the "opportunities" table is valid, and prevents the insertion of rows in the `opportunities` table that do not have corresponding entries in the `apple_accounts` table. It also helps to enforce the relationship between the two tables and can be used to ensure that data is not deleted from the accounts table if there are still references to it in the opportunities table.

----


### 9. [Follow-Up AirPod Percentage](https://datalemur.com/questions/follow-up-airpod-percentage)

The Apple Customer Retention Data Science team needs your help to investigate buying patterns related to AirPods and iPhones.

Write a SQL query to determine the percentage of buyers who bought AirPods directly after they bought iPhones. Round your answer to a percentage (i.e. 20 for 20%, 50 for 50) with no decimals.

`transactions` Table:

| Column Name | Type |
|--------------|------|
| transaction_id | integer |
| customer_id | integer |
| product_name | varchar |
| transaction_timestamp | datetime |

`transactions` Example Input:

| transaction_id | customer_id | product_name | transaction_timestamp |
|-----------------|--------------|---------------|------------------------|
| 1 | 101 | iPhone | 08/08/2022 00:00:00 |
| 2 | 101 | AirPods | 08/08/2022 00:00:00 |
| 5 | 301 | iPhone | 09/05/2022 00:00:00 |
| 6 | 301 | iPad | 09/06/2022 00:00:00 |
| 7 | 301 | AirPods | 09/07/2022 00:00:00 |

Example Output:

| follow_up_percentage |
|----------------------|
| 50 |

Of the two users, only user 101 bought AirPods after buying an iPhone. Note that we still count user 101, even though they bought both an iPhone and AirPods in the same transaction. We can't count customer 301 since they bought an iPad in between their iPhone and AirPods.

Therefore, 1 out of 2 users fit the problem's criteria. For this example, the follow-up percentage would be 50%.

#### `Solution`:

```sql
-- refer the HARD questions folder for the solution.
```

---

### 10. iCloud Storage Analysis

Write a SQL query to find all users who have more than one type of device (e.g., both an iPhone and a MacBook) and are using more than 50GB of total iCloud storage across all their devices.

The output should include the UserID, UserName, total number of devices, and total storage used. Order the results by the total storage used in descending order.

#### Tables You Have Access To:

**Users**

*   UserID (INT): Unique identifier for each user.

*   UserName (VARCHAR): Name of the user.
*   Email (VARCHAR): Email address of the user.
*   Country (VARCHAR): Country where the user is located.

**Devices**

*   DeviceID (INT): Unique identifier for each device.

*   UserID (INT): Identifier of the user to whom the device belongs.
*   DeviceType (VARCHAR): Type of the device (e.g., iPhone, iPad, MacBook).
*   PurchaseDate (DATE): Date when the device was purchased.

**StorageUsage**

*   DeviceID (INT): Identifier of the device.

*   StorageUsed (INT): Amount of iCloud storage used by the device (in GB).
*   LastUpdate (DATE): Date when the last update was made to the storage usage in iCloud


#### `Solution`:

```sql
SELECT   UserID, UserName, COUNT(DISTINCT DeviceType) AS num_of_devices, SUM(StorageUsed) AS total_storage_used
FROM     Users u JOIN Devices d USING(UserID) JOIN StorageUsage su USING(DeviceID)
GROUP BY 1, 2
HAVING   SUM(StorageUsed) > 50 and COUNT(DISTINCT DeviceType) > 1
ORDER BY 4 DESC
```

---