## 11 Tesla SQL Interview Questions

### 1. Analyzing Tesla Charging Stations Usage

Given a dataset of Tesla charging stations, we'd like to analyze the usage pattern. The dataset captures when a Tesla car starts charging, finishes charging, and the charging station used. 

**Calculate the total charging time on each station and compare it with the previous day.**

`charging_data` **Example Input:**

| charge_id | start_time | end_time | station_id | car_id |
|-----------|------------|-----------|------------|--------|
| 1001      | 07/01/2022 08:00:00 | 07/01/2022 09:00:00 | 2001 | 3001 |
| 1002      | 07/01/2022 12:00:00 | 07/01/2022 13:00:00 | 2001 | 3002 |
| 1003      | 07/02/2022 10:00:00 | 07/02/2022 11:00:00 | 2002 | 3003 |
| 1004      | 07/02/2022 11:30:00 | 07/02/2022 12:30:00 | 2001 | 3001 |

The start and end times are timestamps of when a charging session began and ended.

There are 3 cars (3001, 3002, 3003) and 2 charging stations (2001, 2002) in this data set.

**Answer:**

```sql
SELECT    station_id,
          DATE_TRUNC('day', start_time) AS charge_day,
          SUM(EXTRACT(EPOCH FROM (end_time - start_time)) / 3600) AS total_charge_hours,
            (SUM(EXTRACT(EPOCH FROM (end_time - start_time)) / 3600) - 
             LAG(SUM(EXTRACT(EPOCH FROM (end_time - start_time)) / 3600), 1, 0) 
                OVER (PARTITION BY station_id 
                      ORDER BY DATE_TRUNC('day', start_time) )
              ) AS diff_prev_day_hours
FROM     charging_data
GROUP BY 1, 2
ORDER BY 1, 2
```

---

### 2. Tesla Unfinished Parts

In this actual Tesla SQL Interview question, a Data Analyst was given the table called `parts_assembly` and told to "**Write a SQL query that determines which parts have begun the assembly process but are not yet finished**?".

The assumptions for this problem are that the `parts_assembly` table contains all parts currently in production, each at varying stages of the assembly process. 

The second assumption is that an unfinished part is one that lacks a `finish_date`.


**Answer:**

```sql
SELECT part, assembly_step
FROM   parts_assembly
WHERE  finish_date IS NULL;
```

---

### 3. How does the CHECK constraint function, and in what scenarios might it be useful?

The CHECK constraint is used to set a rule for the data in a column. If a row is inserted or updated and the data in the column does not follow the rule specified by the CHECK constraint, the operation will be unsuccessful. The CHECK constraint is often used in conjunction with other constraints, such as NOT NULL or UNIQUE.

You might consider implementing the CHECK constraint in your database if you want to ensure that certain data meets specific conditions. This can be helpful for maintaining the quality and reliability of your data.

For example, you might use a CHECK constraint to ensure that a column contains only positive numbers, or that a date is within a certain range.

```sql
CREATE TABLE tesla_employees (
  id INT PRIMARY KEY,
  salary INT CHECK (salary > 0),
  hire_date DATE CHECK (hire_date >= '1940-01-01')
);
```

---

### 4. Calculate Click-Through Conversion Rates for Tesla's Digital Ads & Products

Tesla is interested in understanding the click-through conversion rates from viewing a digital ad to adding a product (vehicle model) to the cart. 

**Calculate the click-through conversion rates for each ad-campaign and the respective product.**

For this scenario, let's work with two tables - one named "ad_clicks" that records data about the ad-campaign through which a user clicks across to the site and the product they viewed, and a second named "add_to_carts" that records data about whether the user added the product to the cart after clicking the ad.

`ad_clicks` **Example Input:**

| click_id | user_id | click_date | ad_campaign | product_model |
|----------|---------|------------|-------------|---------------|
| 1256     | 867     | 06/08/2022 00:00:00 | Campaign1 | Model S |
| 2453     | 345     | 06/08/2022 00:00:00 | Campaign2 | Model X |
| 4869     | 543     | 06/10/2022 00:00:00 | Campaign1 | Model 3 |
| 7853     | 543     | 06/18/2022 00:00:00 | Campaign3 | Model Y |
| 3248     | 865     | 07/26/2022 00:00:00 | Campaign2 | Model S |

`add_to_carts` **Example Input:**

| cart_id | user_id | add_date | product_model |
|---------|---------|----------|---------------|
| 1234    | 867     | 06/08/2022 00:00:00 | Model S |
| 7324    | 345     | 06/10/2022 00:00:00 | Model X |
| 6271    | 543     | 06/11/2022 00:00:00 | Model 3 |

**Answer:**

```sql
WITH clicks AS (
    SELECT   ad_campaign, product_model, COUNT(*) as num_clicks
    FROM     ad_clicks
    GROUP BY 1, 2
),
adds AS (
    SELECT   product_model, COUNT(*) as num_adds
    FROM     add_to_carts
    GROUP BY 1
)
SELECT c.ad_campaign, c.product_model, c.num_clicks, a.num_adds, 
       (a.num_adds::DECIMAL / c.num_clicks) * 100 AS conversion_rate
FROM   clicks c JOIN adds a USING(product_model);
```

---

### 5. What's a self-join, and when would you use one?

A self-join is a type of JOIN where a table is joined to itself. To execute a self-join, you must include the table name twice in the FROM clause and assign a different alias to each instance. You can then join the two copies of the table using a JOIN clause, and use a WHERE clause to specify the relationship between the rows.

For example, say you had website visitor data for Tesla, exported from the company's Google Analytics account. In support of the web-dev team, you had to analyze pairs of pages for UX or navigational issues. As part of that analysis, you wanted to wanted to generate all pairs of URLs, but needed to avoid pairs where both the URLs were the same since that's not a valid pair.

The self-join query woulld like the following:

```sql
SELECT page1.url AS page_url, page2.url AS referred_from
FROM   google_analytics AS page1
JOIN   google_analytics AS page2 ON page1.referrer_id = page2.id
WHERE  page1.id <> page2.id;
```

This query returns the url of each page (`page1.url`) along with the url of the page that referred to it (`page2.url`). The self-join is performed using the `referrer_id` field, which specifies the id of the page that referred the visitor to the current page, and avoids any pages that referred themself (aka data anomalies).


---

### 6. Average Selling Price Per Tesla Car Model

In the sales department at Tesla, there's constant monitoring of average selling price per model to analyze trends and inform decision making. Write a SQL query that shows the average selling price per Tesla car model for each year.

Here's some sample data to work with:

`sales` **Example Input:**

| sale_id | model_id | sale_date | price |
|---------|----------|-----------|-------|
| 1       | ModelS   | 2018-06-08 | 80000 |
| 2       | ModelS   | 2018-10-12 | 79000 |
| 3       | ModelX   | 2019-09-18 | 100000 |
| 4       | Model3   | 2020-07-26 | 38000 |
| 5       | Model3   | 2020-12-05 | 40000 |
| 6       | ModelY   | 2021-06-08 | 50000 |
| 7       | ModelY   | 2021-10-10 | 52000 |

The dates are in the format `YYYY-MM-DD`.

Here we're considering only tickets that have been closed, which are the ones that have a `close_date`.

**Example Output:**

| year | model | average_price |
|------|-------|---------------|
| 2018 | ModelS | 79500 |
| 2019 | ModelX | 100000 |
| 2020 | Model3 | 39000 |
| 2021 | ModelY | 51000 |

**Answer:**

```sql
SELECT   EXTRACT(YEAR FROM sale_date) as year, 
         model_id as model, 
         AVG(price) as avg_price
FROM     sales
GROUP BY 1, 2
```

---

### 7. What are the similarities and differences between a clustered index and non-clustered index?

Clustered indexes have a special characteristic in that the order of the rows in the database corresponds to the order of the rows in the index. This is why a table can only have one clustered index, but it can have multiple non-clustered indexes.

The main difference between clustered and non-clustered indexes is that the database tries to maintain the order of the data in the database to match the order of the corresponding keys in the clustered index. This can improve query performance as it provides a linear-access path to the data stored in the database.

---

### 8. Analyzing Tesla's Customer and Car Information

The Tesla company maintains two tables in their database, `Customers` and `Cars`. The `Customers` table contains information about the customers including: `customerID`, `name`, `email`, and `purchase_date`. The `Cars` table includes: `carID`, `model`, `color`, and `customerID`. 

**Write a SQL query that will join these two tables and return a list of customers who have bought cars, including their names, emails, the model of the car they bought, and its color.**

`Customers` **Example Input:**

| customerID | name | email | purchase_date |
|------------|------|-------|---------------|
| 1          | John Doe | johndoe@example.com | 2022-01-01 |
| 2          | Jane Smith | janesmith@example.com | 2022-04-12 |
| 3          | Mike Thomas | mikethomas@example.com | 2022-06-20 |

`Cars` **Example Input:**

| carID | model | color | customerID |
|-------|-------|-------|------------|
| 1     | Model S | Blue | 1 |
| 2     | Model X | White | 2 |
| 3     | Model 3 | Black | 3 |

**Answer:**

```sql
SELECT cu.name, cu.email, c.model, c.color
FROM   Customers cu JOIN Cars c USING(customerID);
```


---

### 9. Calculate the Battery Efficiency


As a data analyst at Tesla, one of your tasks is to evaluate the efficiency of newly developed batteries. You have been given a sample dataset with each row representing one test run for a battery. The dataset contains successful charge and discharge cycles, and the energy used in each of these actions (in kWh). Your task is to write a SQL script to compute the battery performance index of each run by using the following function:

`performance_index = ABS(CHARGE - DISCHARGE)/SQRT(DAYS)`

Where `CHARGE` is energy used to fully charge the battery, `DISCHARGE` is energy recovered from the battery, and `DAYS` is the runtime of each test in days. You've to round off the `performance_index` to two decimal places.

`battery_runs` **Sample Input:**

| run_id | battery_model | start_date | end_date | charge_energy | discharge_energy |
|--------|---------------|------------|----------|---------------|------------------|
| 1      | Model S       | 2021-07-31 | 2021-08-05 | 100 | 98 |
| 2      | Model S       | 2021-08-10 | 2021-08-12 | 102 | 99 |
| 3      | Model 3       | 2021-09-01 | 2021-09-04 | 105 | 103 |
| 4      | Model X       | 2021-10-01 | 2021-10-10 | 110 | 107 |
| 5      | Model 3       | 2021-11-01 | 2021-11-03 | 100 | 95 |

**Answer:**

```sql
SELECT run_id, 
       battery_model, 
       ROUND(ABS(charge_energy - discharge_energy) /  SQRT(end_date - start_date + 1), 2) AS performance_index
FROM   battery_runs
```


---

### 10 . Can you explain what SQL constraints are, and why they are useful?

**Answer:**

Constraints are just rules your DBMS has to follow when updating/inserting/deleting data.

Say you had a table of Tesla products and a table of Tesla customers. Here's some example SQL constraints you'd use:

`NOT NULL`: This constraint could be used to ensure that certain columns in the product and customer tables, such as the product name and customer email address, cannot contain NULL values.

`UNIQUE`: This constraint could be used to ensure that the product IDs and customer IDs are unique. This would prevent duplicate entries in the respective tables.

`PRIMARY KEY`: This constraint could be used to combine the NOT NULL and UNIQUE constraints to create a primary key for each table. The product ID or customer ID could serve as the primary key.

`FOREIGN KEY`: This constraint could be used to establish relationships between the Tesla product and customer tables. For example, you could use a foreign key to link the customer ID in the customer table to the customer ID in the product table to track which products each customer has purchased.

`CHECK`: This constraint could be used to ensure that certain data meets specific conditions. For example, you could use a CHECK constraint to ensure that Tesla product prices are always positive numbers.

`DEFAULT`: This constraint could be used to specify default values for certain columns. For example, you could use a DEFAULT constraint to set the customer registration date to the current date if no value is provided when a new customer is added to the database.

---

### 11. Tesla Fleet Efficiency Analysis

You are a data analyst at Tesla and the company is focused on improving the efficiency of its vehicle fleet. Based on service data, the Company would like to analyze the average distance driven and power consumed by each model of its vehicles across different years.

Tesla has two tables, `vehicles` and `service_data`.

The `vehicles` table has four columns: 

vehicle_id, model_name, manufacture_year and owner_id, where vehicle_id is a unique identifier for each vehicle.

`vehicles` **Example Input:**

vehicle_id |	model_name |	manufacture_year |	owner_id |
--|--|--|--|
001 |	Model S |	2018 |	1001 |
002 |	Model 3 |	2019 |	1002 |
003 |	Model X |	2020 |	1003 |
004 |	Model S |	2019 |	1004 |
005 |	Model 3 |	2018 |	1005 |


The `service_data` table has four columns: 

record_id, vehicle_id, distance_driven (in miles), and power_consumed (in kilowatt hour), where record_id is a unique identifier for each service record.

`service_data` **Example Input:**

record_id |	vehicle_id |	distance_driven |	power_consumed |
--|--|--|--|
a001 |	001 |	1200 |	400 |
a002 |	002 |	1000 |	250 |
a003 |	003 |	1500 |	500 |
a004 |	001 |	1300 |	450 |
a005 |	004 |	1100 |	420 |


**Write a query that produces a report summarizing the average distance driven and average power consumed by each model manufactured in each year.**


**Answer:**

```sql
SELECT   model_name,
         manufacture_year,
         AVG(distance_driven) AS avg_distance,
         AVG(power_consumed) AS avg_power
FROM     vehicles v JOIN service_data s USING(vehicle_id)
GROUP BY 1, 2
ORDER BY 1, 2
```

---