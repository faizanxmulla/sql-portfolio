WITH CTE AS (
	SELECT user_id,
		   date,
		   downloads,
           RANK() OVER (PARTITION BY date ORDER BY downloads DESC) AS daily_rank
	FROM   download_facts
)
SELECT   daily_rank, user_id, date, downloads
FROM     CTE
WHERE    daily_rank <= 3 
ORDER BY 3, 1


-- NOTE: classic rank() problem; solved in first attempt