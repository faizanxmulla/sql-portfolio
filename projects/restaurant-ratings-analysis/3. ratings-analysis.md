## Rating Analysis

### 1. Ratings given by customer for restaurants

```sql
SELECT   b.consumer_id,
	     a.name,
	     b.overall_rating,
	     b.food_rating,
	     b.service_rating
FROM     restaurants as a JOIN customer_ratings as b USING(restaurant_id)
ORDER BY b.restaurant_id;
```	

**Result Set** :

*displaying only first 5 entries*

consumer_id | name | overall_rating | food_rating | service_rating |
--|--|--|--|--|
U1082 |	Pollo Frito Buenos Aires |	0 |	0 |	0 |
U1070 |	Pollo Frito Buenos Aires |	1 |	1 |	1 |
U1043 |	Carnitas Mata |	1 |	1 |	1 |
U1028 |	Carnitas Mata |	2 |	2 |	2 |
U1123 |	Carnitas Mata |	1 |	2 |	1 |


---

	
### 2.  Average ratings of each restaurant including its cuisine type

```sql
SELECT   a.name,
	     ROUND(AVG(b.overall_rating),2)as overall_Rating,
	     ROUND(AVG(b.food_rating),2)as food_rating,
	     ROUND(AVG(b.service_rating),2)as service_rating,
	     c.cuisine
FROM     restaurants as a JOIN customer_ratings as b USING(restaurant_id) 
				          JOIN restaurant_cuisines AS c USING(restaurant_id)
GROUP BY 1, 5
ORDER BY 1;
```

**Result Set** :

*displaying only first 5 entries*


name | overall_rating | food_rating | service_rating | cuisine |
--|--|--|--|--|
Abondance Restaurante Bar |	0.50 |	0.50 |	0.75 |	Bar |
Cabana Huasteca |	1.46 |	1.46 |	1.31 |	Mexican |
Cafe Chaires |	1.00 |	1.00 |	0.93 |	Cafeteria |
Cafe Punta Del Cielo |	1.83 |	1.50 |	1.83 |	Cafeteria |
Cafeteria Cenidet |	1.00 |	1.17 |	1.00 |	Cafeteria |


---

### 3. Creating new columns for sentiment analysis

```sql
ALTER TABLE customer_ratings ADD COLUMN overall_senti Varchar(50);
ALTER TABLE customer_ratings ADD COLUMN food_senti Varchar(50);
ALTER TABLE customer_ratings ADD COLUMN service_senti Varchar(50);
```

---

### 4. Updating the new columns with the sentiments 

```sql
UPDATE customer_ratings
SET overall_sentiment = 
		CASE WHEN overall_rating = 0 then 'Negative'
			 WHEN overall_rating = 1 then 'Neutral'	
			 WHEN overall_rating = 2 then 'Positive'
		  END
WHERE overall_sentiment is null;
```

```sql
UPDATE customer_ratings
SET food_sentiment = 
		CASE WHEN food_rating = 0 then 'Negative'
		     WHEN food_rating = 1 then 'Neutral'	
		     WHEN food_rating = 2 then 'Positive'
		  END
WHERE food_sentiment is null;
```

```sql
UPDATE customer_ratings
SET service_sentiment = 
		CASE WHEN service_rating = 0 then 'Negative'
			 WHEN service_rating = 1 then 'Neutral'	
			 WHEN service_rating = 2 then 'Positive'
		  END
WHERE service_sentiment is null;
```

```sql
SELECT * 
FROM   customer_ratings
```


**Result Set** :

*displaying sample 3 entries*

consumer_id | restaurant_id | overall_rating | food_rating | service_rating | overall_sentiment | food_sentiment | service_sentiment |
--|--|--|--|--|--|--|--|
U1077 |	135085 |	2 |	2 |	2 |	Positive |	Positive |	Positive |
U1077 |	135038 |	2 |	2 |	1 |	Positive |	Positive |	Neutral |
U1077 |	132825 |	2 |	2 |	2 |	Positive |	Positive |	Positive |



---

### 5. Conduct a sentimental analysis of total count of customers

```sql
CREATE VIEW overall AS
	SELECT   overall_sentiment, COUNT(consumer_id) AS total_customers
	FROM     customer_ratings
	GROUP BY 1;


CREATE VIEW food AS 
	SELECT   food_sentiment,
			 count(consumer_id) as total_customers
	FROM 	 customer_ratings
	GROUP BY 1;


CREATE VIEW service AS 
	SELECT   service_sentiment,
			 count(consumer_id) as total_customers
	FROM 	 customer_ratings
	GROUP BY 1;
```

```sql
SELECT a.overall_sentiment as sentiment,
	   a.total_customers as overall_Rating,
	   b.total_customers as food_Rating,
	   c.total_customers as service_Rating
FROM   overall as a JOIN food as b ON a.overall_sentiment = b.food_sentiment
					JOIN service as c ON a.overall_sentiment = c.service_sentiment
```


**Result Set** :

sentiment | overall_rating | food_rating | service_rating |
--|--|--|--|
Positive |	486 |	516 |	420 |
Neutral |	421 |	379 |	426 |
Negative |	254 |	266 |	315 |


---


### 6. List of Customers visiting local or outside restaurants

```sql
SELECT a.consumer_id,
	   b.city as customer_city,
	   c.name,
	   c.city as restaurant_city,
	   a.overall_sentiment,
	   a.food_sentiment,
	   a.service_sentiment,
	   CASE WHEN b.city = c.city THEN 'Local' ELSE 'Outside' END as location_preference
FROM   customer_ratings as a JOIN customer_details as b USING(consumer_id)
							 JOIN restaurants as c USING(restaurant_id);
```

**Result Set** :

*displaying first 3 entries*

consumer_id | customer_city | name | restaurant_city | overall_sentiment | food_sentiment | service_sentiment | location_preference |
--|--|--|--|--|--|--|--|
U1003 |	San Luis Potosi |	Koye Sushi |	San Luis Potosi |	Positive |	Positive |	Positive |	Local |
U1003 |	San Luis Potosi |	Los Toneles |	San Luis Potosi |	Positive |	Neutral |	Positive |	Local |
U1003 |	San Luis Potosi |	La Estrella De Dimas |	San Luis Potosi |	Positive |	Positive |	Neutral |	Local |

---

### 7. Count of customers visiting local and outside restaurants

```sql
SELECT location_preference,
	   COUNT(*) as total_customers,
	   COUNT(DISTINCT id) as distinct_customers
FROM 	(    
	SELECT a.consumer_id as id,
		   b.city as customer_city,
		   c.name,
		   c.city as restaurant_city,
		   a.overall_sentiment,
		   a.food_sentiment,
		   a.service_sentiment,
		   CASE WHEN b.city = c.city THEN 'Local' ELSE 'Outside' END as Location_preference
	FROM   customer_ratings as a JOIN customer_details as b USING(consumer_id)
		  						 JOIN restaurants as c USING(restaurant_id)
		) as cte
GROUP BY 1				
```

**Result Set** :

location_preference | total_customers | distinct_customers |
--|--|--|
Local |	1073 |	131 |
Outside |	88 |	14 |


---


### 8. Trend of customers visiting outside restaurants

```sql
SELECT customer_id,
	   customer_city,
	   restaurant_city,
	   concat_ws(' - ',customer_city , restaurant_city) as direction,
	   restaurant_name		
FROM 	( 
	SELECT a.consumer_id as customer_id,
		   b.city as customer_city,
		   c.name as restaurant_name,
		   c.city as restaurant_city,
	       a.overall_sentiment,
	       a.food_sentiment,
	       a.service_sentiment,
	  	   CASE WHEN b.city = c.city THEN 'Local' ELSE 'Outside' END as location_preference
	FROM   customer_ratings as a JOIN customer_details as b USING(consumer_id)
								 JOIN restaurants as c USING(restaurant_id)
		) as cte
WHERE  location_preference = 'Outside'		  
```	


**Result Set** :

*displaying first 3 entries*

customer_id | customer_city | restaurant_city | direction | restaurant_name |
--|--|--|--|--|
U1004 |	Cuernavaca |	San Luis Potosi |	Cuernavaca - San Luis Potosi |	Tacos Los Volcanes |
U1004 |	Cuernavaca |	San Luis Potosi |	Cuernavaca - San Luis Potosi |	Emilianos |
U1004 |	Cuernavaca |	San Luis Potosi |	Cuernavaca - San Luis Potosi |	La Parroquia |


---
	
### 9. Count of direction trend from above query

```sql
SELECT direction,
	   COUNT(customer_id) as total_customers

FROM  (  
	SELECT customer_id,
		   customer_city,
		   restaurant_city,
		   concat_ws(' - ',customer_city , restaurant_city) as direction,
		   restaurant_name
		
	FROM  (  
		SELECT a.consumer_id as customer_id,
			   b.city as customer_city,
			   c.name as restaurant_name,
			   c.city as restaurant_city,
			   a.overall_sentiment,
			   a.food_sentiment,
			   a.service_sentiment,
			   CASE WHEN  b.city = c.city THEN 'Local' ELSE 'Outside' END as Location_preference
		FROM   customer_ratings as a JOIN customer_details as b USING(consumer_id)
									 JOIN restaurants as c USING(restaurant_id)
									 
			) as cte
	WHERE  Location_preference = 'Outside' ) cte2
GROUP BY 1;
```	

**Result Set** :

direction | total_customers | 
--|--|
Cuernavaca - San Luis Potosi |	26 |
Ciudad Victoria - San Luis Potosi |	19 |
Cuernavaca - Jiutepec |	8 |
Jiutepec - San Luis Potosi |	19 |
Jiutepec - Cuernavaca |	16 |



---

### 10. Cuisine preferences vs cuisine consumed

```sql
SELECT  a.consumer_id,
	    GROUP_CONCAT(b.preferred_cuisine,',') as customer_preferences,
	    d.name,
		c.cuisine as restaurant_cuisine
FROM    customer_ratings as a JOIN customer_preference as b USING(consumer_id)
							  JOIN restaurant_cuisines as c USING(restaurant_id)
							  JOIN restaurants as d USING(restaurant_id)
GROUP BY 1, 3, 4
```

**Result Set** :

*displaying first 3 entries*

consumer_id | customer_preferences | name | restaurant_cuisine |
--|--|--|--|
U1001 |	American, |	El Rincon De San Francisco |	Mexican |
U1001 |	American, |	Puesto De Tacos |	Mexican |
U1001 |	American, |	Restaurant De Mariscos De Picon |	Seafood |


---


### 11. Best restaurants for each cuisines by different ratings

```sql
CREATE VIEW average_analysis as 
	SELECT   a.name,
			 ROUND(AVG(b.overall_rating), 2) as overall_Rating,
			 ROUND(AVG(b.food_rating), 2) as food_rating,
			 ROUND(AVG(b.service_rating), 2) as service_rating,
			 c.cuisine
	FROM     restaurants as a JOIN customer_ratings as b USING(restaurant_id)
							  JOIN restaurant_cuisines AS c USING(restaurant_id)
	GROUP BY 1, 5
	ORDER BY 5;

	
CREATE VIEW best  as 
	SELECT cuisine,
		   first_value(name) OVER(partition by cuisine ORDER BY overall_rating desc) as best_overall,
		   first_value(name) OVER(partition by cuisine ORDER BY food_rating desc) as best_for_food,
		   first_value(name) OVER(partition by cuisine ORDER BY service_rating desc) as best_for_service
	FROM   average_analysis;
```

```sql
SELECT   *
FROM     best
GROUP BY cuisine, best_overall, best_for_food, best_for_service
ORDER BY cuisine
```

**Result Set** :

*displaying first 5 entries*

cuisine | best_overall | best_for_food | best_for_service |
--|--|--|--|
American |	Tacos Los Volcanes |	Tacos Los Volcanes |	Tacos Los Volcanes |
Armenian	Little Pizza Emilio Portes Gil |	Little Pizza Emilio Portes Gil |	Little Pizza Emilio Portes Gil |
Bakery |	Chaires |	Chaires |	Chaires |
Bar |	Restaurant Bar Hacienda Los Martinez |	Restaurante Bar El Gallinero |	La Cantina |
Breakfast |	La Parroquia |	La Parroquia |	La Parroquia |


---


### 12. Worst restaurants for each cuisines by different ratings

```sql
CREATE VIEW count_cuisines as 
	SELECT   cuisine,
			 COUNT(cuisine)	as count
	FROM     average_analysis
	GROUP BY 1;

		
CREATE VIEW worst as 
	SELECT cuisine,
		   first_value(name) OVER(PARTITION BY cuisine ORDER BY overall_rating) as worst_overall,
		   first_value(name) OVER(PARTITION BY cuisine ORDER BY food_rating) as worst_for_food,
		   first_value(name) OVER(PARTITION BY cuisine ORDER BY service_rating) as worst_for_service	
	FROM    ( 	
			SELECT   a.name,
				     ROUND(AVG(a.overall_rating), 2)as overall_Rating,
				     ROUND(AVG(a.food_rating), 2)as food_rating,
				     ROUND(AVG(a.service_rating), 2)as service_rating,
				     a.cuisine,
				     cc.count
			FROM     average_analysis as a JOIN count_cuisines as cc USING(cuisine)
			WHERE    cc.count > 1	
			GROUP BY 1, 5, 6
			ORDER BY 5
		) as least;
```

```sql
SELECT   *
FROM     worst
GROUP BY cuisine, worst_overall, worst_for_food, worst_for_service
ORDER BY cuisine
```

**Result Set** :

*displaying first 5 entries*

cuisine | worst_overall | worst_for_food | worst_for_service |
--|--|--|--|
American |	Pizzeria Julios |	Vips |	Vips |
Bar |	Abondance Restaurante Bar |	Abondance Restaurante Bar |	Abondance Restaurante Bar |
Brewery |	Restaurant And Bar And Clothesline Carlos N Charlies |	Restaurante La Cantina |	Restaurante La Cantina |
Burgers |	Tortas Y Hamburguesas El Gordo |	McDonalds Parque Tangamanga |	Tortas Y Hamburguesas El Gordo |
Cafeteria |	Hamburguesas Saul |	Hamburguesas Saul |	Hamburguesas Saul |


---


### 13. Total customers with highest ratings in all different criteria


```sql
SELECT COUNT(consumer_id) as total_customers
FROM   customer_ratings
WHERE  overall_rating = 2 and food_rating = 2 and service_rating = 2;
```

**Result Set** :

total_customers |
--|
293 |



---
