## Sequential Project Pairs

### Problem Statement 

Write a query to return pairs of projects where the end date of one project matches the start date of another project.

### Schema setup 

```sql
CREATE TABLE projects (
    id INTEGER PRIMARY KEY,
    title VARCHAR(100),
    start_date DATETIME,
    end_date DATETIME,
    budget FLOAT
);

INSERT INTO projects (id, title, start_date, end_date, budget) VALUES
(1, 'Website Redesign', '2024-01-01', '2024-02-15', 50000),
(2, 'Mobile App Phase 1', '2024-02-15', '2024-04-01', 75000),
(3, 'Database Migration', '2024-04-01', '2024-05-15', 60000),
(4, 'Cloud Integration', '2024-03-01', '2024-04-15', 45000),
(5, 'Security Audit', '2024-05-15', '2024-06-30', 30000);
```

### Expected Output 

project_title_end |	project_title_start |	date |
--|--|--|
Website Redesign |	Mobile App Phase 1 |	2024-02-15 |
Mobile App Phase 1 |	Database Migration |	2024-04-01 |
Database Migration |	Security Audit |	2024-05-15 |


### Solution Query 

```sql
SELECT a.title as project_title_end,
       b.title as project_title_start,
       a.end_date as date
FROM   projects a JOIN projects b ON a.end_date=b.start_date
```