-- Solution 1: 

-- using GENERATE_SERIES() 
-- also my approach


WITH tasks_cte AS (
    SELECT task_id, generate_series(1, subtasks_count, 1) AS subtask_id
    FROM   tasks
)
SELECT   tc.task_id, tc.subtask_id
FROM     tasks_cte tc LEFT JOIN executed e USING(task_id, subtask_id)
WHERE    e.subtask_id IS NULL



-- Solution 2: 

-- using RECURSIVE CTE


WITH RECURSIVE all_tasks AS (
	SELECT 1 AS subtask_id
    UNION ALL 
    SELECT subtask_id + 1
    FROM   all_tasks
    WHERE  subtask_id < (
        SELECT MAX(subtasks_count)
        FROM   tasks
       )
 )
SELECT t.task_id, at.subtask_id
FROM   all_tasks at JOIN tasks t ON at.subtask_id <= t.subtasks_count
                    LEFT JOIN executed e ON t.task_id = e.task_id AND                                   at.subtask_id = e.subtask_id
WHERE  e.subtask_id IS NULL
