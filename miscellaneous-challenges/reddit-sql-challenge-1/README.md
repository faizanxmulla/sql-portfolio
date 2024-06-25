## Reddit SQL challenge - 1

### **Introduction:**

Lord Johnson, owner of a collection of luxury vehicles, has been renting them out.
Unfortunately, his love of vehicles did not extend to databases.

Details have been well recorded, so you don't need to clean the data.

"Just get it done" says Johnson, heading to his yacht with his latest mistress.
"But I only have select and insert permissions!" You exclaim, too late

---

### **Task 1** | [Solution](task-1-solution.md)

Normally, a customer will remember to cancel a booking if they want to cancel or it.
Unfortunately, this has been handled manually and imperfectly.

Georg Becker complained he was charged for booking id 15, which was superceded by #16.

A customer cannot rent more than one car at once or double rent one car, as per usual, nobody bothered to design in cancellation checks, so it's fallen to you.

When a newer booking overlaps with an older one, the older is considered cancelled.
Affected customers will need a grovelling apology where the booking was not cancelled!

**Required result set** |
--|
booking id |
customer name |
car brand & model |
start date |
return date |
amount  |     

**NOTE:**

- booking_id should be considered cancelled

- rentals = duration * rate + discount (discount is negative)

- extra: amount

- cancellations: 100.00

- Remember you can happily return a car in the morning and rent another one that afternoon

---

### **Task 2** | [Solution](task-2-solution.md)

A stern letter with red print from the tax man sits on your desk, demanding ALL INVOICES.

You eye the large stack of handwritten "invoices" and think "perhaps not"
There exists already an invoices table, but it sits empty.

Invoices are dated for the end of the month and cover all charges in that month.

Column name | Description |
--|--|
invoice_id    |  sequential, increasing with date, customer_id|
line_id       |  sequential per invoice, with one charge per line|
invoice_date  |  the end of the month in question|
customer_id   |  because the accountant wants to check|
customer_name |  because the postal service needs it|
booking_id    |  in case the customer wants to check|
extra_id      |  as booking_id, but helps with tracing things back|
line_descr    |  rental, tolls, cancellation... for rentals include brand & model |
amount        |  logic as above|

**NOTE:**

- It is OK to have a cancellation be the only line on an invoice

- Check all the extras are coming through, extras are tied to customers or bookings

---

### References / Links

- [Original Reddit Post](https://old.reddit.com/r/SQL/comments/uafw29/sql_challenge_i_made_for_you_guys_medium_advanced/)

- [Original Fiddle Link](https://www.db-fiddle.com/f/pDcD13Grye9Rycb2Pissei/4)