WITH ranked_facilities AS (
    SELECT   owner_name, 
             facility_address,
             RANK() OVER(PARTITION BY owner_name ORDER BY AVG(score) DESC, facility_address) AS    rn
    FROM     los_angeles_restaurant_health_inspections
    GROUP BY 1, 2
),
top1_facilities AS (
    SELECT owner_name, facility_address
    FROM   ranked_facilities
    WHERE  rn=1
),
top2_facilities AS (
    SELECT owner_name, facility_address
    FROM   ranked_facilities
    WHERE  rn=2
),
top3_facilities AS (
    SELECT owner_name, facility_address
    FROM   ranked_facilities
    WHERE  rn=3
)
SELECT owner_name, t1.facility_address, t2.facility_address, t3.facility_address
FROM   top1_facilities t1 JOIN top2_facilities t2 USING(owner_name)
                          JOIN top3_facilities t3 USING(owner_name)
