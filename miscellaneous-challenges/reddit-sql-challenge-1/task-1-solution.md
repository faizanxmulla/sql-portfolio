### Approach:

**1. Identify Overlapping Bookings:**

- For each customer, check if they have multiple bookings.

- If a newer booking (Booking B) overlaps with an older booking (Booking A), consider Booking A as cancelled.

- Overlapping --> Booking A’s return date is after Booking B’s start date and Booking B’s return date is after Booking A’s start date.


**2. Calculate Charges for Canceled Bookings:**


- For each cancelled booking, calculate the rental amount using this formula:

        Rental amount = (number of days * daily rate) + discount


**3. List of Canceled Bookings:**

- Create a list of all bookings that should be considered cancelled due to overlaps.

- Include booking details: booking ID, customer name, car brand and model, start date, return date, and amount.


### Solution Query: 

```sql
WITH total_extra_amount AS (
    SELECT   booking_id, SUM(amount) AS amount
    FROM     extras
    WHERE    booking_id IS NOT NULL
    GROUP BY 1
	ORDER BY 1
),
overlapping_bookings AS (
	SELECT   b1.booking_id AS old_booking_id,
			 b2.booking_id AS new_booking_id,
			 c.name AS customer_name,
		     CONCAT(car.brand, ' ', car.model) AS car_brand_model,
		     b1.out_date,
		     b1.ret_date,
		     (EXTRACT(EPOCH FROM b1.ret_date::timestamp - b1.out_date::timestamp) / 86400
 * dr.daily_rate + b1.discount + COALESCE(ext.amount, 0)) AS amount
	FROM     bookings b1 JOIN bookings b2      USING(customer_id, car_id)
		                 JOIN customers c      USING(customer_id)
		                 JOIN cars car         USING(car_id)
		                 JOIN default_rates dr USING(rate_id)
						 LEFT JOIN total_extra_amount AS ext ON ext.booking_id=b1.booking_id
	WHERE    b2.booking_id > b1.booking_id AND b1.out_date < b2.ret_date
										   AND b2.out_date < b1.ret_date
										   AND b1.is_cancelled = FALSE
										   AND b2.is_cancelled = FALSE
	ORDER BY 1, 5
)
SELECT DISTINCT old_booking_id AS booking_id,
       customer_name,
       car_brand_model,
       out_date,
       ret_date,
       amount
FROM   overlapping_bookings


-- NOTE: not 100% sure about the solution.
```


### **Corresponding Result Set:**

booking_id |	customer_name |	car_brand_model |	out_date |	ret_date |	amount |
--|--|--|--|--|--|
1 |	Erwin Biegel |	Mercedes GLS63 |	2/4/2020 |	2/17/2020 |	4140 |
2 |	Georg Becker |	Chevrolet Corvette |	2/28/2020 |	3/7/2020 |	2340 |
3 |	Günther Claudius |	Mercedes GLS63 |	3/20/2020 |	4/6/2020 |	5120 |
4 |	Erwin Biegel |	Mercedes GLS63 |	2/4/2020 |	2/17/2020 |	3840 |
5 |	Georg Becker |	Chevrolet Corvette |	2/28/2020 |	3/7/2020 |	2430 |
6 |	Günther Claudius |	Mercedes GLS63 |	3/20/2020 |	4/6/2020 |	5120 |
15 |	Georg Becker |	BMW M3 |	7/8/2020 |	7/23/2020 |	6720 |
