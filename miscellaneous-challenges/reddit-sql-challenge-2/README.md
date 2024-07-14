## Reddit SQL challenge - 2 | [Solution](solution.md)


An owner (a person) can only be assigned to one event (an activity) at a time. There are tens of thousands of owners and millions of events, and owners are independent of one another. Currently, events for an owner may overlap, abut, or be completely contained within another.

The requirements are as follows:

1. If an owner's shorter event is completely within a longer one, the shorter event should not be included in the output.

2. If two events for an owner abut (one ends the same day another begins), the earlier event should end one day earlier.

3. If two events for an owner overlap, the earlier event should be cut shorter until they neither overlap nor abut.

4. Events can start and end on the same date, but one event cannot end before it begins.

5. If two events for an owner have the same start and end date, return the one with the higher event_id.

**How can you populate clean_events from raw_events to satisfy these requirements?**

You may use intermediate tables, common table expressions, subqueries, window functions, etc., but avoid user-defined functions. Provide the SQL query or queries necessary to achieve this.

---

### References / Links

- [Original Reddit Post](https://old.reddit.com/r/SQL/comments/vlavlp/sql_challenge_i_made_for_you_guys_2_medium/)

- [Original Fiddle Link](https://www.db-fiddle.com/f/vC73NfDBV6ePn4tH5CGDb2/1)