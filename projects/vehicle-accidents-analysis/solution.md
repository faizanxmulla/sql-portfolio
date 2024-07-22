## Solutions

### 1. How many accidents have occurred in urban areas versus rural areas?

```sql
SELECT   area, COUNT(accidentindex) AS total_accidents
FROM     accident
GROUP BY 1
```

**Result Set:**

area | total_accidents |
--|--|
Urban |	58533 |
Rural |	21999 |

---

### 2. Which day of the week has the highest number of accidents?

```sql
SELECT   Day, COUNT(accidentindex) AS total_accidents
FROM     accident
GROUP BY 1
ORDER BY 2 DESC
```

**Result Set:**

day | total_accidents |
--|--|
Friday |	12937 |
Thursday |	12431 |
Wednesday |	12358 |
Tuesday |	12302 |
Monday |	11401 |
Saturday |	10388 |
Sunday |	8715 |

---

### 3. What is the average age of vehicles involved in accidents based on their type?

```sql
SELECT   vehicletype, COUNT(accidentindex) AS total_accidents,  ROUND(AVG(agevehicle), 2) AS average_age
FROM     vehicle
WHERE    agevehicle IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
```

**Result Set:**


| VehicleType                               | total_accidents | average_age |
|-------------------------------------------|-----------------|-------------|
| Car                                       | 137379          | 8.27        |
| Van / Goods 3.5 tonnes mgw or under       | 9803            | 6.27        |
| Motorcycle 125cc and under                | 6669            | 6.09        |
| Motorcycle over 500cc                     | 5604            | 10.46       |
| Taxi/Private hire car                     | 4228            | 6.35        |
| Bus or coach (17 or more pass seats)      | 4174            | 7.14        |
| Goods 7.5 tonnes mgw and over             | 2967            | 5.29        |
| Motorcycle 50cc and under                 | 1631            | 6.5         |
| Motorcycle over 125cc and up to 500cc     | 1545            | 10.38       |
| Goods over 3.5t. and under 7.5t           | 763             | 6.56        |
| Other vehicle                             | 373             | 7.82        |
| Goods vehicle - unknown weight            | 315             | 6.63        |
| Agricultural vehicle                      | 304             | 7.9         |
| Minibus (8 - 16 passenger seats)          | 193             | 7.75        |
| Motorcycle - unknown cc                   | 120             | 8.58        |
| Mobility scooter                          | 6               | 2.5         |
| Data missing or out of range              | 1               | 4.0         |

---

### 4. Can we identify any trends in accidents based on the age of vehicles involved?

```sql
WITH CTE AS (
	SELECT  accidentindex,
			agevehicle,
			CASE
				WHEN agevehicle BETWEEN 0 AND 5 THEN 'New'
				WHEN agevehicle BETWEEN 6 AND 10 THEN 'Regular'
				ELSE 'Old'
			END AS agegroup
	FROM    vehicle
)
SELECT   agegroup, COUNT(accidentindex) AS total_accidents,  ROUND(AVG(agevehicle), 2) AS average_age
FROM     CTE
GROUP BY 1
```


**Result Set:**

agegroup |	total_accidents |	average_age |
--|--|--|
New |	61658 |	2.83 |
Old |	137141 |	13.73 |
Regular |	59046 |	8.06 |


---

### 5. Are there any specific weather conditions that contribute to severe accidents?

```sql
SELECT   weatherconditions, COUNT(severity) AS total_accidents
FROM     accident
WHERE    severity = 'Fatal'
GROUP BY 1
ORDER BY 2 DESC
```

**Result Set:**

WeatherConditions |	total_accidents |
--|--|
Fine no high winds |	668 |
Raining no high winds |	84 |
Fine + high winds |	18 |
Unknown |	17 |
Raining + high winds |	17 |
Other |	7 |
Fog or mist |	5 |
Snowing no high winds |	1 |

---

### 6. Do accidents often involve impacts on the left-hand side of vehicles?

```sql
SELECT   lefthand, COUNT(accidentindex) AS total_accidents
FROM     vehicle
GROUP BY 1
HAVING   lefthand IS NOT NULL
```

**Result Set:**

LeftHand |	total_accidents |
--|--|
Data missing or out of range |	1019 |
No |	255480 |
Yes |	1346 |

---

### 7. Are there any relationships between journey purposes and the severity of accidents?

```sql
SELECT   journeypurpose, 
	     COUNT(severity) AS 'Total Accident',
	     CASE 
		     WHEN COUNT(severity) BETWEEN 0 AND 1000 THEN 'Low'
		     WHEN COUNT(severity) BETWEEN 1001 AND 3000 THEN 'Moderate'
		     ELSE 'High'
	     END AS 'Level'
FROM     accident a JOIN vehicle v USING(accidentindex)
GROUP BY 1
ORDER BY 2 DESC
```

**Result Set:**

JourneyPurpose |	Total Accident |	Level |
--|--|--|
Not known |	186046 |	High |
Journey as part of work |	39785 |	High |
Commuting to/from work |	26966 |	High |
Taking pupil to/from school |	2634 |	Moderate |
Other |	1573 |	Moderate |
Pupil riding to/from school |	817 |	Low |
Data missing or out of range |	24 |	Low |

---

### 8. Calculate the average age of vehicles involved in accidents , considering Day light and point of impact

```sql
SELECT   lightconditions, pointimpact, ROUND(AVG(agevehicle), 2) AS avg_vehicle_age
FROM     accident a JOIN vehicle v USING(accidentindex)
GROUP BY 1, 2
```

**Result Set:**

LightConditions |	PointImpact |	avg_vehicle_age |
--|--|--|
Darkness |	Back |	7.73 |
Darkness |	Did not impact |	6.8 |
Darkness |	Front |	8.22 |
Darkness |	Nearside |	7.75 |
Darkness |	Offside |	7.83 |
Daylight |	Back |	7.57 |
Daylight |	Data missing or out of range |	8.3 |
Daylight |	Did not impact |	7.51 |
Daylight |	Front |	8.31 |
Daylight |	Nearside |	7.91 |
Daylight |	Offside |	7.92 |

---