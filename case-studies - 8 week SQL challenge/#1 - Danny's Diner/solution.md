## Case Study Questions

1. What is the total amount each customer spent at the restaurant?

2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

<br>

**BONUS questions** :

i. Join all the things

ii. Rank all the things

---


## Solutions:

Let's collaborate on running the queries using PostgreSQL on [DB Fiddle](https://www.db-fiddle.com/f/4hUAAf83SKPApsRxxyK7d/5). It'll be fantastic to team up and tackle the questions together!!

---

### 1. What is the total amount each customer spent at the restaurant?

```sql
SELECT   customer_id,
         sum(price) AS total_sales
FROM     dannys_diner.menu INNER JOIN dannys_diner.sales USING(prodcut_id)
GROUP BY 1
ORDER BY 1
```

#### Result set:

| customer_id | total_sales |
| ----------- | ----------- |
| A           | 76          |
| B           | 74          |
| C           | 36          |

---

### 2. How many days has each customer visited the restaurant?

```sql
SELECT   customer_id,
         count(DISTINCT order_date) AS visit_count
FROM     dannys_diner.sales
GROUP BY 1
ORDER BY 1
```

#### Result set:

| customer_id | visit_count |
| ----------- | ----------- |
| A           | 4           |
| B           | 6           |
| C           | 2           |

---

### 3. What was the first item from the menu purchased by each customer?

```sql
with ranked_orders as (
  SELECT *, dense_rank() over(partition by s.customer_id order by s.order_date) as rank
  FROM   dannys_diner.sales s JOIN dannys_diner.menu m USING(product_id)
)
SELECT   customer_id, product_name
FROM     ranked_orders
WHERE    rank=1
GROUP BY 1, 2
```

#### Result set:

| customer_id | product_name |
| ----------- | ------------ |
| A           | curry        |
| A           | sushi        |
| B           | curry        |
| C           | ramen        |

---

### 4. What is the most purchased item on the menu and how many times was it purchased by all customers?

```sql
SELECT   product_name AS most_purchased_item,
         count(s.product_id) AS order_count
FROM     dannys_diner.menu m JOIN dannys_diner.sales s USING(product_id)
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1
```

#### Result set:

| most_purchased_item | order_count |
| ------------------- | ----------- |
| ramen               | 8           |

---

### 5. Which item was the most popular for each customer?

```sql
WITH ranked_orders AS(
   SELECT   product_name,
  			customer_id,
            count(product_name) AS order_count,
            rank() over(PARTITION BY customer_id
                        ORDER BY count(product_name) DESC) AS rank
   FROM     dannys_diner.menu m JOIN dannys_diner.sales s USING(product_id)
   GROUP BY 1, 2)
SELECT customer_id,
       product_name,
       order_count
FROM   ranked_orders
WHERE  rank=1
```

#### Result set:

| customer_id | product_name | order_count |
| ----------- | ------------ | ----------- |
| A           | ramen        | 3           |
| B           | ramen        | 2           |
| B           | curry        | 2           |
| B           | sushi        | 2           |
| C           | ramen        | 3           |

---

### 6. Which item was purchased first by the customer after they became a member?

```sql
WITH diner_info AS
  (SELECT product_name,
          s.customer_id,
          order_date,
          join_date,
          m.product_id,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date) as rank
   FROM   dannys_diner.menu m INNER JOIN dannys_diner.sales s USING(product_id)
                              INNER JOIN dannys_diner.members mem USING(customer_id)
   WHERE  order_date >= join_date )
SELECT customer_id,
       product_name,
       order_date,
       join_date
FROM   diner_info
WHERE  rank=1
```

#### Result set:

| customer_id | product_name | order_date               | join_date                |
| ----------- | ------------ | ------------------------ | ------------------------ |
| A           | curry        | 2021-01-07T00:00:00.000Z | 2021-01-07T00:00:00.000Z |
| B           | sushi        | 2021-01-11T00:00:00.000Z | 2021-01-09T00:00:00.000Z |

---

### 7. Which item was purchased just before the customer became a member?

```sql
WITH diner_info AS
  (SELECT product_name,
          s.customer_id,
          order_date,
          join_date,
          m.product_id,
          DENSE_RANK() OVER(PARTITION BY s.customer_id
                            ORDER BY s.order_date desc) as rank
   FROM   dannys_diner.menu m INNER JOIN dannys_diner.sales s USING(product_id)
                              INNER JOIN dannys_diner.members mem USING(customer_id)
   WHERE  order_date < join_date )
SELECT customer_id,
       product_name,
       order_date,
       join_date
FROM   diner_info
WHERE  rank=1
```

#### Result set:

| customer_id | product_name | order_date               | join_date                |
| ----------- | ------------ | ------------------------ | ------------------------ |
| A           | sushi        | 2021-01-01T00:00:00.000Z | 2021-01-07T00:00:00.000Z |
| A           | curry        | 2021-01-01T00:00:00.000Z | 2021-01-07T00:00:00.000Z |
| B           | sushi        | 2021-01-04T00:00:00.000Z | 2021-01-09T00:00:00.000Z |

---

### 8. What is the total items and amount spent for each member before they became a member?

```sql
SELECT   customer_id,
         count(product_name) AS total_items,
         SUM(price) AS amount_spent
FROM     dannys_diner.menu m INNER JOIN dannys_diner.sales s USING(product_id)
                             INNER JOIN dannys_diner.members mem USING(customer_id)
WHERE    order_date < join_date
GROUP BY 1
ORDER BY 1
```

#### Result set:

| customer_id | total_items | amount_spent |
| ----------- | ----------- | ------------ |
| A           | 2           | 25           |
| B           | 3           | 40           |

---

### 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

```sql
SELECT   customer_id,
         SUM(CASE
                 WHEN product_name = 'sushi' THEN price*20
                 ELSE price*10
             END) AS customer_points
FROM     dannys_diner.menu AS m INNER JOIN dannys_diner.sales AS s USING(product_id)
GROUP BY 1
ORDER BY 1
```

#### Result set:

| customer_id | customer_points |
| ----------- | --------------- |
| A           | 860             |
| B           | 940             |
| C           | 360             |

---

### 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January

```sql
WITH cte AS (
  SELECT join_date,
         Date_add(join_date, interval 6 day) AS program_last_date,
         customer_id
  FROM   dannys_diner.members)
SELECT s.customer_id,
       SUM(CASE
             WHEN order_date BETWEEN join_date AND program_last_date THEN
             price * 10 * 2
             WHEN order_date NOT BETWEEN join_date AND program_last_date
                  AND product_name = 'sushi' THEN price * 10 * 2
             WHEN order_date NOT BETWEEN join_date AND program_last_date
                  AND product_name != 'sushi' THEN price * 10
           END) AS customer_points
FROM   dannys_diner.menu AS m join dannys_diner.sales s USING(product_id)
                              join cte USING(customer_id) AND order_date <= '2021-01-31' AND order_date >= join_date
GROUP BY 1
ORDER BY 1



-- remarks: also can use the "SUM IF" clause instead.
```

#### Result set:

| customer_id | customer_points |
| ----------- | --------------- |
| A           | 1020            |
| B           | 320             |

---

### **Bonus Questions**

#### i. Join All The Things

Create basic data tables that Danny and his team can use to quickly derive insights without needing to join the underlying tables using SQL. Fill Member column as 'N' if the purchase was made before becoming a member and 'Y' if the after is amde after joining the membership.

```sql
SELECT   customer_id,
         order_date,
         product_name,
         price,
         CASE WHEN order_date >= join_date THEN 'Y' ELSE 'N' END AS member
FROM     dannys_diner.members RIGHT JOIN dannys_diner.sales USING (customer_id)
                              INNER JOIN dannys_diner.menu USING (product_id)
ORDER BY 1, 2
```

#### Result set:

| customer_id | order_date | product_name | price | member |
| ----------- | ---------- | ------------ | ----- | ------ |
| A           | 2021-01-01 | sushi        | 10    | N      |
| A           | 2021-01-01 | curry        | 15    | N      |
| A           | 2021-01-07 | curry        | 15    | Y      |
| A           | 2021-01-10 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| A           | 2021-01-11 | ramen        | 12    | Y      |
| B           | 2021-01-01 | curry        | 15    | N      |
| B           | 2021-01-02 | curry        | 15    | N      |
| B           | 2021-01-04 | sushi        | 10    | N      |
| B           | 2021-01-11 | sushi        | 10    | Y      |
| B           | 2021-01-16 | ramen        | 12    | Y      |
| B           | 2021-02-01 | ramen        | 12    | Y      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-01 | ramen        | 12    | N      |
| C           | 2021-01-07 | ramen        | 12    | N      |

---

#### ii. Rank All The Things

Danny also requires further information about the ranking of customer products, but he purposely does not need the ranking for non-member purchases so he expects null ranking values for the records when customers are not yet part of the loyalty program.

```sql
with cte as (
 	SELECT    customer_id,
              order_date,
              product_name,
              price,
              CASE WHEN order_date >= join_date THEN 'Y' ELSE 'N' END AS member
     FROM     dannys_diner.members RIGHT JOIN dannys_diner.sales USING (customer_id)
                                   INNER JOIN dannys_diner.menu USING (product_id)
     ORDER BY 1, 2
)
SELECT *,
	   CASE WHEN member = 'N' THEN NULL ELSE DENSE_RANK() OVER (PARTITION BY customer_id, member ORDER BY order_date) END AS ranking
FROM   cte


-- remarks: use the previous question's query to make a CTE; and then apply a CASE statment to rank.
```

#### Result set:

| customer_id | order_date | product_name | price | member | ranking |
| ----------- | ---------- | ------------ | ----- | ------ | ------- |
| A           | 2021-01-01 | sushi        | 10    | N      | NULL    |
| A           | 2021-01-01 | curry        | 15    | N      | NULL    |
| A           | 2021-01-07 | curry        | 15    | Y      | 1       |
| A           | 2021-01-10 | ramen        | 12    | Y      | 2       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| A           | 2021-01-11 | ramen        | 12    | Y      | 3       |
| B           | 2021-01-01 | curry        | 15    | N      | NULL    |
| B           | 2021-01-02 | curry        | 15    | N      | NULL    |
| B           | 2021-01-04 | sushi        | 10    | N      | NULL    |
| B           | 2021-01-11 | sushi        | 10    | Y      | 1       |
| B           | 2021-01-16 | ramen        | 12    | Y      | 2       |
| B           | 2021-02-01 | ramen        | 12    | Y      | 3       |
| C           | 2021-01-01 | ramen        | 12    | N      | NULL    |
| C           | 2021-01-01 | ramen        | 12    | N      | NULL    |
| C           | 2021-01-07 | ramen        | 12    | N      | NULL    |

---
