-- Assume that Salesforce customers pay on a per user basis (also referred to as per seat model). Given a table of contracts data, write a query to calculate the average annual revenue per Salesforce customer. Round your answer to 2 decimal places.

-- Assume each customer only has 1 contract and the yearly seat cost refers to cost per seat.


SELECT ROUND(SUM(num_seats * yearly_seat_cost)::decimal / COUNT(customer_id), 2) as average_deal_size
FROM   contracts



-- remarks: again didn't do --> SUM(num_seats * yearly_seat_cost) and also didn't cast to decimal. 