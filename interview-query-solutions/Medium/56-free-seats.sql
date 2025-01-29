WITH seats_cte as (
    SELECT   flight_id, COUNT(seat_id) as occupied_seats
    FROM     flight_purchases 
    GROUP BY flight_id
)
SELECT f.id as flight_id, p.number_of_seats - sc.occupied_seats as free_seats
FROM   seats_cte sc JOIN flights f ON sc.flight_id=f.id
                    JOIN planes p ON f.plane_id=p.id



-- NOTE: correct idea; wasn't using CTE to solve initially.