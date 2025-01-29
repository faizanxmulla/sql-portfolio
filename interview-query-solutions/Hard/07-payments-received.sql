SELECT COUNT(*) as num_customers
FROM (
    SELECT   u.id
    FROM     users u JOIN payments p ON u.id=p.sender_id or u.id=p.recipient_id
    WHERE    TO_CHAR(u.created_at, 'YYYY-MM') = '2020-01' and
             payment_state='success' and
             p.created_at BETWEEN u.created_at AND u.created_at + INTERVAL '30 day'
    GROUP BY 1
    HAVING   SUM(p.amount_cents) > 10000
) x



-- NOTE: 

-- earlier was using just the subquery --> it passed one test case and failed the other one.

-- also using OR in the join statement is not preferred: https://stackoverflow.com/questions/5901791/is-having-an-or-in-an-inner-join-condition-a-bad-idea