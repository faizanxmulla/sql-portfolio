### Approach:

1. **Filter Events for a Specific Owner**:

    - Use a WITH clause (common table expression, CTE) to select events for a specific owner. This helps to keep the data manageable and focused on the owner of interest.


2. **Identify Contained Events**:

    - Within the contained_events CTE, use a self-join to identify events that are fully contained within the duration of another event. These events will be excluded in the next step to avoid redundant or unnecessary adjustments.


3. **Adjust Overlapping and Abutting Events**:

    - Use another CTE (adjusted_events) to adjust the end_date of events. This includes:

    - Abutting Events: When an event's end_date is exactly the start_date of another event, subtract one day from the end_date.

    - Non-Contained Events: Exclude events identified as contained in the previous step.


4. **Finalize Selection and Sorting**:

    - Select distinct events based on owner_id, start_date, and end_date to ensure unique records.

    - Ensure that the start_date is not after the end_date by applying a filter.

    - Order the results by owner_id, start_date, end_date, and event_id in descending order for consistent and correct results.

### Solution Query: 

```SQL
INSERT INTO clean_events

-- Implement Requirement 1: Identify contained events.
WITH contained_events AS (
    SELECT se.event_id
    FROM   raw_events se JOIN raw_events le USING(owner_id)
    WHERE  se.start_date >= le.start_date AND 
           se.end_date <= le.end_date AND 
           se.event_id != le.event_id
),
-- Implement Requirements 2 and 3.
adjusted_events AS (
    SELECT e1.owner_id,
           e1.event_id,
           e1.start_date,
           CASE 
	            -- Adjust abutting events
	            WHEN e1.end_date = e2.start_date THEN e1.end_date - INTERVAL '1 day'
	            ELSE e1.end_date
           END AS end_date
    FROM   owner_events e1 LEFT JOIN owner_events e2 ON e1.owner_id = e2.owner_id AND
											             e1.end_date = e2.start_date AND
        											     e1.event_id < e2.event_id
    WHERE  e1.event_id NOT IN (SELECT event_id FROM contained_events)
)
-- Final selection and implementation of Requirements 4 and 5
SELECT   DISTINCT ON (owner_id, start_date, end_date)
         owner_id,
         event_id,
         start_date,
         end_date::date  -- Cast back to date for the final output
FROM     adjusted_events
WHERE    start_date <= end_date  -- Implement Requirement 4: Ensure start_date is not after end_date
ORDER BY 1, 3, 4, 2 DESC;  -- Implement Requirement 5: Higher event_id for same dates
```