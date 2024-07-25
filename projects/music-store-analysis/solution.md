## Solutions

### A. Easy Questions

#### 1. Who is the senior most employee based on job title?

```sql
SELECT   title, last_name, first_name 
FROM     employee
ORDER BY levels DESC
LIMIT    1
```

**Result Set:**


title | first_name | last_name |
--|--|--|
Senior General Manager | Madan | Mohan

---

#### 2. Which countries have the most Invoices?

```sql
SELECT   billing_country, COUNT(*) as invoice_count
FROM     invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT    10
```

**Result Set:**

billing_country	 |invoice_count |
--|--|
USA |	131 |
Canada |	76 |
Brazil |	61 |
France |	50 |
Germany |	41 |
Czech Republic |	30 |
Portugal |	29 |
United Kingdom |	28 |
India |	21 |
Chile |	13 |


---

#### 3. What are top 3 values of total invoice?

```sql
SELECT   total 
FROM     invoice
ORDER BY 1 DESC
LIMIT    3
```

**Result Set:**

total |
--|
23.759999999999998 |
19.8 |
19.8 |

---

#### 4. Which city has the best customers?

We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals.

```sql
SELECT   billing_city, SUM(total) AS invoice_total
FROM     invoice
GROUP BY 1
ORDER BY 2 DESC
LIMIT    1
```

**Result Set:**

billing_city |	invoice_total |
--|--|
Prague |	273.24000000000007 |

---

#### 5. Who is the best customer?

The customer who has spent the most money will be declared the best customer. Write a query that returns the person who has spent the most money.

```sql
SELECT   c.customer_id, first_name, last_name, SUM(total) AS total_spending
FROM     customer c JOIN invoice i USING(customer_id)
GROUP BY 1
ORDER BY 4 DESC
LIMIT    1
```

**Result Set:**

customer_id |	first_name |	last_name |	total_spending |
--|--|--|--|
5 | R |  Madhav  | 144.54000000000002 |

---

### B. Moderate Questions

#### 1. Write query to return the email, first name, last name, & Genre of all Rock Music listeners.

Return your list ordered alphabetically by email starting with A.


```sql
-- Solution 1:

SELECT DISTINCT email, first_name, last_name
FROM   customer JOIN invoice USING(customer_id)
                JOIN invoiceline USING(invoice_id)
WHERE  track_id IN (
    SELECT track_id 
    FROM   track JOIN genre USING(genre_id)
    WHERE  genre.name LIKE 'Rock'
)
ORDER BY 1


-- Solution 2:

SELECT   DISTINCT email, first_name, last_name, genre.name AS genre
FROM     customer JOIN invoice i USING(customer_id)
                  JOIN invoiceline il USING(invoice_id)
                  JOIN track t USING(track_id)
                  JOIN genre g USING(genre_id)
WHERE    g.name LIKE 'Rock'
ORDER BY 1
```

**Result Set:**

*displaying only first 10 rows out of 59*


| email                          | first_name | last_name  | genre |
|--------------------------------|------------|------------|-------|
| aaronmitchell@yahoo.ca         | Aaron      | Mitchell   | Rock  |
| alero@uol.com.br               | Alexandre  | Rocha      | Rock  |
| astrid.gruber@apple.at         | Astrid     | Gruber     | Rock  |
| bjorn.hansen@yahoo.no          | Bjørn      | Hansen     | Rock  |
| camille.bernard@yahoo.fr       | Camille    | Bernard    | Rock  |
| daan_peeters@apple.be          | Daan       | Peeters    | Rock  |
| diego.gutierrez@yahoo.ar       | Diego      | Gutiérrez  | Rock  |
| dmiller@comcast.com            | Dan        | Miller     | Rock  |
| dominiquelefebvre@gmail.com    | Dominique  | Lefebvre   | Rock  |
| edfrancis@yachoo.ca            | Edward     | Francis    | Rock  |



---

#### 2. Let's invite the artists who have written the most rock music in our dataset.

Write a query that returns the Artist name and total track count of the top 10 rock bands.

```sql
SELECT   a.artist_id, a.name, COUNT(a.artist_id) AS number_of_songs
FROM     track JOIN album al USING(album_id)
               JOIN artist a USING(artist_id)
               JOIN genre g USING(genre_id)
WHERE    g.name LIKE 'Rock'
GROUP BY a.artist_id
ORDER BY 3 DESC
LIMIT    10
```

**Result Set:**

| artist_id | name                          | number_of_songs |
|-----------|-------------------------------|-----------------|
| 22        | Led Zeppelin                  | 114             |
| 150       | U2                            | 112             |
| 58        | Deep Purple                   | 92              |
| 90        | Iron Maiden                   | 81              |
| 118       | Pearl Jam                     | 54              |
| 152       | Van Halen                     | 52              |
| 51        | Queen                         | 45              |
| 142       | The Rolling Stones            | 41              |
| 76        | Creedence Clearwater Revival  | 40              |
| 52        | Kiss                          | 35              |


---

#### 3. Return all the track names that have a song length longer than the average song length.

Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.

```sql
SELECT name, milliseconds
FROM   track
WHERE  milliseconds > (
         SELECT AVG(milliseconds)
         FROM   track
    )
ORDER BY 2 DESC
-- LIMIT 10
```

**Result Set:**

*displaying only first 10 rows out of 494*


| name                          | milliseconds |
|-------------------------------|--------------|
| Occupation / Precipice        | 5286953      |
| Through a Looking Glass       | 5088838      |
| Greetings from Earth, Pt. 1   | 2960293      |
| The Man With Nine Lives       | 2956998      |
| Battlestar Galactica, Pt. 2   | 2956081      |
| Battlestar Galactica, Pt. 1   | 2952702      |
| Murder On the Rising Star     | 2935894      |
| Battlestar Galactica, Pt. 3   | 2927802      |
| Take the Celestra             | 2927677      |
| Fire In Space                 | 2926593      |


---

### Advanced Questions

#### 1. Find how much amount spent by each customer on artists?

Write a query to return customer name, artist name and total spent.

```sql
WITH best_selling_artist AS (
    SELECT   a.artist_id AS artist_id, a.name AS artist_name, SUM(il.unit_price * il.quantity) AS total_sales
    FROM     invoice_line il JOIN track t USING(track_id)
                             JOIN album al USING(album_id)
                             JOIN artist a USING(artist_id)
    GROUP BY 1
    ORDER BY 3 DESC
    LIMIT    1
)
SELECT   CONCAT(c.first_name, ' ', c.last_name) AS customer_name, bsa.artist_name, ROUND(SUM(il.unit_price * il.quantity)::numeric, 2) AS amount_spent
FROM     invoice i JOIN customer c USING(customer_id)
                   JOIN invoice_line il USING(invoice_id)
                   JOIN track t USING(track_id)
                   JOIN album alb USING(album_id)
                   JOIN best_selling_artist bsa USING(artist_id)
GROUP BY 1, 2
ORDER BY 3 DESC
```

**Result Set:**

*displaying only first 10 rows out of 43*


| name                          | artist_name | amount_spent |
|-------------------------------|-------------|--------------|
| Hugh O'Reilly                 | Queen       | 27.72        |
| Niklas Schröder               | Queen       | 18.81        |
| François Tremblay             | Queen       | 17.82        |
| João Fernandes                | Queen       | 16.83        |
| Phil Hughes                   | Queen       | 11.88        |
| Marc Dubois                   | Queen       | 11.88        |
| Lucas Mancini                 | Queen       | 10.89        |
| Ellie Sullivan                | Queen       | 10.89        |
| R Madhav                      | Queen       | 3.96         |
| Dan Miller                    | Queen       | 3.96         |


---

#### 2. We want to find out the most popular music Genre for each country.

We determine the most popular genre as the genre with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where the maximum number of purchases is shared return all Genres.



```sql
-- Solution 1:

WITH most_popular_genre AS (
    SELECT   c.country, 
             g.name AS genre, 
             g.genre_id, 
             COUNT(il.quantity) AS purchases_per_genre,
             ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS rn 
    FROM     invoice_line il JOIN invoice i USING(invoice_id)
                             JOIN customer c USING(customer_id)
                             JOIN track t USING(track_id)
                             JOIN genre g USING(genre_id)
    GROUP BY 1, 2, 3
    ORDER BY 4 DESC
)
SELECT country, genre, genre_id, purchases_per_genre
FROM   most_popular_genre 
WHERE  rn = 1



-- Solution 2:

WITH sales_per_country AS(
    SELECT c.country, g.name as genre, g.genre_id, COUNT(*) AS purchases_per_genre
    FROM   invoice_line il JOIN invoice USING(invoice_id)
                           JOIN customer c USING(customer_id)
                           JOIN track t USING(track_id)
                           JOIN genre g USING(genre_id)
    GROUP BY 1, 2, 3
    ORDER BY 4 DESC
),
max_genre_per_country AS (
    SELECT   country, MAX(purchases_per_genre) AS max_genre_number
    FROM     sales_per_country
    GROUP BY 1
    ORDER BY 2 DESC
)
SELECT spc.* 
FROM   sales_per_country spc JOIN max_genre_per_country mg USING(country)
WHERE  spc.purchases_per_genre = mg.max_genre_number
```

**Result Set:**

*displaying only first 10 rows out of 24*

| country          | genre | genre_id | purchases |
|------------------|-------|----------|-----------|
| USA              | Rock  | 1        | 561       |
| Canada           | Rock  | 1        | 333       |
| France           | Rock  | 1        | 211       |
| Brazil           | Rock  | 1        | 205       |
| Germany          | Rock  | 1        | 194       |
| United Kingdom   | Rock  | 1        | 166       |
| Czech Republic   | Rock  | 1        | 143       |
| Portugal         | Rock  | 1        | 108       |
| India            | Rock  | 1        | 102       |
| Ireland          | Rock  | 1        | 72        |


---

#### 3. Write a query that determines the customer that has spent the most on music for each country.

Write a query that returns the country along with the top customer and how much they spent. For countries where the top amount spent is shared, provide all customers who spent this amount.



```sql
-- Solution 1:

WITH customer_with_country AS (
        SELECT   c.customer_id, 
                 CONCAT(first_name, ' ', last_name) AS customer_name, 
                 billing_country, 
                 ROUND(SUM(total)::numeric, 2) AS total_spending,
                 ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS rn 
        FROM     invoice JOIN customer c USING(customer_id)
        GROUP BY 1, 2, 3
        ORDER BY 4 DESC
)
SELECT customer_name, billing_country, total_spending 
FROM   customer_with_country 
WHERE  rn = 1



-- Solution 2:

WITH customer_with_country AS (
        SELECT   c.customer_id, CONCAT(first_name, ' ', last_name) AS customer_name, billing_country, ROUND(SUM(total)::numeric, 2) AS total_spending
        FROM     invoice JOIN customer c USING(customer_id)
        GROUP BY 1, 2, 3
        ORDER BY 4 DESC
),
country_max_spending AS (
    SELECT   billing_country, MAX(total_spending) AS max_spending
    FROM     customer_with_country
    GROUP BY 1
)
SELECT customer_name, cc.billing_country, total_spending
FROM   customer_with_country cc JOIN country_max_spending ms USING(billing_country)
WHERE  cc.total_spending = ms.max_spending
```

**Result Set:**

*displaying only first 10 rows out of 24*

| customer_name                          | billing_country         | total_spending |
|-------------------------------|-----------------|--------------|
| R Madhav                      | Czech Republic  | 144.54       |
| Hugh O'Reilly                 | Ireland         | 114.84       |
| Manoj Pareek                  | India           | 111.87       |
| Luís Gonçalves                | Brazil          | 108.90       |
| João Fernandes                | Portugal        | 102.96       |
| Wyatt Girard                  | France          | 99.99        |
| François Tremblay             | Canada          | 99.99        |
| Enrique Muñoz                 | Spain           | 98.01        |
| Phil Hughes                   | United Kingdom  | 98.01        |
| Jack Smith                    | USA             | 98.01        |



---