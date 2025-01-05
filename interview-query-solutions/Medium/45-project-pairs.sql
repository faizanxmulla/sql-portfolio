SELECT p1.start_date as date,
       p2.title as project_title_end,
       p1.title as project_title_start
FROM   projects p1 JOIN projects p2 ON p1.start_date=p2.end_date and p1.id <> p2.id



-- NOTE: solved on first attempt; rare easy question in the Medium section