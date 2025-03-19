### Problem Statement

#### A. **Medium Level**

Find out Delivery Partner-wise delayed orders count (delay means - the order which took more than the predicted time to deliver).

**Write an SQL query to calculate the number of delayed orders for each delivery partner.**

An order is considered delayed if the actual delivery time exceeds the predicted delivery time.

Table contains: order_details: `order_id`, `cust_id`, `city`, `date`, `del_partner`, `order_time`, `deliver_time`, `predicted_time`, `aov`

**Note**: If a partner has no delayed orders, then the result should show the partner with 0 as the count.

---

#### B. **Advanced Level**

On which date did the 3rd highest sale of product 4 take place in terms of value?
(Sale: `qty sold`; Value: `qty sold * price of product`)

### Schema Setup

```sql
-- 1. Medium Level

CREATE TABLE swiggy_orders (
    order_id INT PRIMARY KEY,
    cust_id INT,
    city VARCHAR(50),
    del_partner VARCHAR(50),
    order_time DATETIME,
    deliver_time DATETIME,
    predicted_time INT -- Predicted delivery time in minutes
);

INSERT INTO swiggy_orders (order_id, cust_id, city, del_partner, order_time, deliver_time, predicted_time)VALUES

-- Delivery Partner A
(1, 101, 'Mumbai', 'Partner A', '2024-12-18 10:00:00', '2024-12-18 11:30:00', 60),
(2, 102, 'Delhi', 'Partner A', '2024-12-18 09:00:00', '2024-12-18 10:00:00', 45),
(3, 103, 'Pune', 'Partner A', '2024-12-18 15:00:00', '2024-12-18 15:30:00', 30),
(4, 104, 'Mumbai', 'Partner A', '2024-12-18 14:00:00', '2024-12-18 14:50:00', 45),

-- Delivery Partner B
(5, 105, 'Bangalore', 'Partner B', '2024-12-18 08:00:00', '2024-12-18 08:29:00', 30),
(6, 106, 'Hyderabad', 'Partner B', '2024-12-18 13:00:00', '2024-12-18 14:00:00', 70),
(7, 107, 'Kolkata', 'Partner B', '2024-12-18 10:00:00', '2024-12-18 10:40:00', 45),
(8, 108, 'Delhi', 'Partner B', '2024-12-18 18:00:00', '2024-12-18 18:30:00', 40),

-- Delivery Partner C
(9, 109, 'Chennai', 'Partner C', '2024-12-18 07:00:00', '2024-12-18 07:40:00', 30),
(10, 110, 'Mumbai', 'Partner C', '2024-12-18 12:00:00', '2024-12-18 13:00:00', 50),
(11, 111, 'Delhi', 'Partner C', '2024-12-18 09:00:00', '2024-12-18 09:35:00', 30),
(12, 112, 'Hyderabad', 'Partner C', '2024-12-18 16:00:00', '2024-12-18 16:45:00', 30);
```

---

```sql
-- 2. Advanced Level

CREATE TABLE sales_data (
    order_date DATE,
    customer_id INT,
    store_id INT,
    product_id INT,
    sale INT,
    order_value INT
);

INSERT INTO sales_data (order_date, customer_id, store_id, product_id, sale, order_value) VALUES
('2024-12-01', 109, 1, 3, 2, 700),
('2024-12-02', 110, 2, 2, 1, 300),
('2024-12-03', 111, 1, 5, 3, 900),
('2024-12-04', 112, 3, 1, 2, 500),
('2024-12-05', 113, 3, 4, 4, 1200), 
('2024-12-05', 114, 3, 4, 2, 400),
('2024-12-05', 115, 3, 4, 1, 300),
('2024-12-01', 101, 1, 4, 2, 500),
('2024-12-01', 102, 1, 4, 1, 300),
('2024-12-02', 103, 2, 4, 3, 900),
('2024-12-02', 104, 2, 4, 1, 400),
('2024-12-03', 105, 1, 4, 2, 600),
('2024-12-03', 106, 1, 4, 3, 800),
('2024-12-04', 107, 3, 4, 1, 200),
('2024-12-04', 108, 3, 4, 2, 500);
```

### Expected Output

A. **Medium Level**



---

B. **Advanced Level**

order_date
2024-12-03



### Solution

A. **Medium Level**

```sql
SELECT   del_partner, 
         SUM(CASE WHEN EXTRACT(MINUTE FROM AGE(deliver_time, order_time)) > predicted_time THEN 1 ELSE 0 END) as delayed_orders_count
FROM     swiggy_orders
-- WHERE EXTRACT(MINUTE FROM AGE(deliver_time, order_time)) > predicted_time
GROUP BY del_partner
```

---

B. **Advanced Level**

```sql
SELECT order_date, SUM(order_value) as total_value
FROM sales_data
WHERE product_id = 4
GROUP BY order_date
ORDER BY total_value desc
LIMIT 1 OFFSET 2


-- OR simply use any ranking window function.
```