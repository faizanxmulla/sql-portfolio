## Customer Demographics Analysis

### 1. Total Customers in each state

```sql
SELECT   state,
	     COUNT(consumer_id) as total_customers
FROM 	 customer_details
GROUP BY 1
ORDER BY 2 DESC
```	

**Result Set** :

state | total_customers | 
--|--|
Tamaulipas |	25 |
San Luis Potosi |	86 |
Morelos |	27 |



---

	
### 2. Total Customers in each city

```sql
SELECT   city,
	     COUNT(consumer_id) as total_customers
FROM 	 customer_details
GROUP BY 1
ORDER BY 2 DESC;	
```

**Result Set** :

city | total_customers |
--|--|
San Luis Potosi |	86 |
Ciudad Victoria |	25 |
Cuernavaca |	22 |
Jiutepec |	5 |



---

### 3. Budget level of customers

```sql
SELECT   budget,
	     COUNT(consumer_id) as total_customers
FROM 	 customer_details
WHERE 	 budget is not null
GROUP BY 1
```

**Result Set** :

budget | total_customers |
--|--|
| Medium |	91 |
| Low |	35 |
|    | 7 |
| High |	5 |



---

### 4. Total Smokers by Occupation

```sql
SELECT   occupation,
	     COUNT(consumer_id) as smokers
FROM 	 customer_details
WHERE 	 smoker = 'Yes'
GROUP BY 1
```

**Result Set** :

occupation | smokers | 
--|--|
Student |	23 |
Employed |	3 |



---

### 5. Drinking level of students

```sql
SELECT   drink_level,
	 	 COUNT(consumer_id) as student_count
FROM 	 customer_details
WHERE 	 occupation = 'Student' and occupation is not null
GROUP BY 1
```

**Result Set** :

drink_level | student_count |
--|--|
Abstemious |	35 |
Social Drinker |	35 |
Casual Drinker |	43 |


---


### 6. Transportation methods of customers

```sql
SELECT   transportation_method,
	 	 COUNT(consumer_id) as total_customers
FROM 	 customer_details
WHERE 	 transportation_method is not null	
GROUP BY 1
ORDER BY 2 DESC
```

**Result Set** :

transportation_method | total_customers |
--|--|
|Public |	82 |
|Car |	35 |
|On Foot |	14 |
|	| 7 |



---

### 7. Adding Age Bucket Column 

```sql
ALTER TABLE customer_details 
ADD COLUMN  age_bucket Varchar(50)
```


---


### 8. Updating the Age Bucket column with case when condition

```sql
UPDATE customer_details
SET age_bucket = 
		 CASE WHEN age > 60 then '61 and Above'
		      WHEN age > 40 then '41 - 60'	
		      WHEN age > 25 then '26 - 40'
		      WHEN age >= 18 then '18 - 25'
		    END
WHERE age_bucket is null					  
```	


---
	
### 9. Total customers in each age bucket

```sql
SELECT   age_bucket,
	     COUNT(consumer_id) as total_customers 
FROM 	 customer_details
GROUP BY 1
ORDER BY 1
```	

**Result Set** :

age_bucket | total_customers |
--|--|
18 - 25 |	110 |
26 - 40 |	16 |
41 - 60 |	3 |
61 and Above |	9 |



---

### 10. Total customers COUNT & smokers COUNT in each age percent 

```sql
SELECT   age_bucket,
	     COUNT(consumer_id) as total,
	     COUNT(CASE WHEN smoker = 'Yes' THEN consumer_id END) as smokers_count
FROM 	 customer_details
GROUP BY 1
ORDER BY 1
```

**Result Set** :

age_bucket | total | smokers_count | 
--|--|--|
18 - 25 |	110 |	21 |
26 - 40 |	16 |	2 |
41 - 60 |	3 |	2 |
61 and Above |	9 |	1 |


---

### 11. Top 10 preferred cuisines

```sql
SELECT   preferred_cuisine,
	 	 COUNT(consumer_id) AS total_customers
FROM 	 customer_preference	
GROUP BY 1
ORDER BY 2 DESC
LIMIT    10
```

**Result Set** :

preferred_cuisine | total_customers | 
--|--|
Mexican |	97 |
American |	11 |
Pizzeria |	9 |
Cafeteria |	9 |
Coffee Shop |	8 |
Family |	8 |
Italian |	7 |
Japanese |	7 |
Chinese |	6 |
Hot Dogs |	6 |


---

### 12. Preferred cuisines of each customer

```sql
SELECT   consumer_id,
		 COUNT(preferred_cuisine) AS total_cuisines,
	     STRING_AGG(preferred_cuisine, ',') as cuisines
FROM 	 customer_preference
GROUP BY 1
ORDER BY 2 DESC
```

**Result Set** :

*only displaying first 5 records for convenience*

consumer_id | total_cuisines | cuisines |
--|--|--|
U1135 |	103 |	Organic,,Steaks,,Middle Eastern,,Mediterranean,,British,,Austrian,,Israeli,,Doughnuts,,Pizzeria,,Seafood,,Fast Food,,Moroccan,,Hot Dogs,,Russian,,Malaysian,,Burgers,,Fusion,,Korean,,Japanese,,Vegetarian,,Turkish,,Peruvian,,Juice,,Tapas,,Eclectic,,African... |
U1108 |	18 |	Coffee Shop,,Sushi,,Latin American,,Deli,,Mexican,,Hot Dogs,,American,,Fast Food,,Burgers,,Asian,,Pizzeria,,Chinese,,Ice Cream,,Cafeteria,,Japanese,,Game,,Family,,Seafood, |
U1101 |	15 |	Chinese,,Italian,,Doughnuts,,Afghan,,Mexican,,Burgers,,Latin American,,Contemporary,,Coffee Shop,,Family,,Cafeteria,,Bar,,Australian,,Hot Dogs,,Diner, |
U1016 |	14 |	Coffee Shop,,Contemporary,,Regional,,Fusion,,Japanese,,Portuguese,,American,,Indian,,Eastern European,,Lebanese,,Moroccan,,Barbecue,,Polynesian,,Polish, |
U1060 |	13 |	Burgers,,Cafeteria,,Pizzeria,,Juice,,American,,Tex Mex,,Spanish,,Mexican,,Fast Food,,Coffee Shop,,Soup,,Hot Dogs,,Italian, |



---

### 13. Customer Budget analysis for each cuisine


```sql
SELECT   b.preferred_cuisine,
		 SUM(CASE WHEN a.budget = 'High' Then 1 Else 0 END) AS High,
		 SUM(CASE WHEN a.budget = 'Medium' Then 1 Else 0 END) AS Medium,
		 SUM(CASE WHEN a.budget = 'Low' Then 1 Else 0 END) AS Low
FROM 	 customer_details a JOIN customer_preference b USING(customer_id)
GROUP BY 1
ORDER BY 1
```

---

### 14. Finding out number of preferred cuisine in each state

```sql
SELECT   a.state,
	     COUNT(b.preferred_cuisine) AS count
FROM 	 customer_details a JOIN customer_preference b USING(consumer_id)
GROUP BY 1
ORDER BY 2 DESC;
```

**Result Set** :

state | count | 
--|--|
San Luis Potosi |	254 |
Tamaulipas |	41 |
Morelos |	35 |

---

