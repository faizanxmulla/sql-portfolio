SELECT a1.machine_id, ROUND(AVG(a2.timestamp - a1.timestamp),3) as processing_time
FROM Activity a1 INNER JOIN Activity a2 USING(machine_id, process_id)
WHERE a1.activity_type = 'start' and a2.activity_type = 'end'
GROUP BY 1


# ON a1.process_id=a2.process_id and a1.machine_id=a2.machine_id

# APPROACH (from one of the solutions)--> 

# To solve this problem, we use a SQL query with the following steps:

# 1. We join the "Activity" table with itself using the "machine_id" column. This allows us to pair the start and end activities for each machine.

# 2. We filter the rows to include only the start activities for the first occurrence and the end activities for the second occurrence. This ensures we have matched start and end activities for each machine.

# 3. We calculate the time difference between the start and end activities for each machine by subtracting the start timestamp from the end timestamp.

# 4. We use the AVG function to calculate the average processing time for each machine.

# 5. We round the average processing time to three decimal places using the ROUND function.

# 6. Finally, we group the results by "machine_id" to get the average processing time for each machine.