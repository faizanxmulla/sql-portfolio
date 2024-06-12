SELECT seat_left, ts.seat_number
FROM   theater_seatmap ts JOIN theater_availability ta1 ON ts.seat_left = ta1.seat_number
                          JOIN theater_availability ta2 ON ts.seat_number = ta2.seat_number
WHERE  ta1.is_available='True' AND ta2.is_available='True'


-- REMARKS: figuring out join condition was the important part of the question.