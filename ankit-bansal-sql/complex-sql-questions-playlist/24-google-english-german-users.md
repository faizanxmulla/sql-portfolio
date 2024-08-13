### Problem Statement

Find the companies who have atleast 2 users who speak both English and German.

### Schema Setup

```sql
CREATE TABLE company_users (
    company_id INT,
    user_id    INT,
    language   VARCHAR(20)
);

INSERT INTO company_users (company_id, user_id, language) VALUES 
    (1, 1, 'English'),
    (1, 1, 'German'),
    (1, 2, 'English'),
    (1, 3, 'German'),
    (1, 3, 'English'),
    (1, 4, 'English'),
    (2, 5, 'English'),
    (2, 5, 'German'),
    (2, 5, 'Spanish'),
    (2, 6, 'German'),
    (2, 6, 'Spanish'),
    (2, 7, 'English');
```

### Expected Output

company_id |
--|
1 |
2 |

### Solution Query

```sql
WITH CTE AS (
    SELECT   company_id, user_id
    FROM     company_users
    WHERE    language IN ('English', 'German')
    GROUP BY 1, 2
    HAVING   COUNT(DISTINCT language) = 2
)
SELECT   company_id
FROM     CTE
GROUP BY 1
HAVING   COUNT(user_id) >= 2
```