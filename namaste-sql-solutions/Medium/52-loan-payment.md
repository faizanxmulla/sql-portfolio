![image](https://github.com/user-attachments/assets/24592c74-33a0-4694-8f99-316fadb920bb)


### Solution Query

```sql
SELECT   l.loan_id,
         l.loan_amount, 
         l.due_date,
         CASE WHEN loan_amount=SUM(amount_paid) THEN 1 ELSE 0 END as fully_paid_flag,
         CASE WHEN loan_amount=SUM(CASE WHEN p.payment_date <= l.due_date THEN amount_paid END) THEN 1 ELSE 0 END as on_time_flag
FROM     loans l LEFT JOIN payments p USING(loan_id)
GROUP BY 1, 2, 3
ORDER BY 1


-- remarks: in the second flag, earlier i was doing "AND" and then the date inequality; hence getting wrong answer.
```