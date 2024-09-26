### Problem Statement

Find the words which are repeating more than once considering all the rows of the content column.

### Schema Setup

```sql
CREATE TABLE namaste_python (
    file_name VARCHAR(25),
    content VARCHAR(200)
);

DELETE FROM namaste_python;

INSERT INTO namaste_python VALUES 
('python bootcamp1.txt', 'python for data analytics 0 to hero bootcamp starting on Jan 6th'),
('python bootcamp2.txt', 'classes will be held on weekends from 11am to 1 pm for 5-6 weeks'),
('python bootcamp3.txt', 'use code NY2024 to get 33 percent off. You can register from namaste sql website. Link in pinned comment');
```


### Expected Output

| corpus_words | occurrence_count |
|--------------|------------------|
| to           | 3                |
| for          | 2                |
| on           | 2                |
| from         | 2                |



### Solution

```sql
SELECT   REGEXP_SPLIT_TO_TABLE(content, ' ') as corpus_words, COUNT(*) as occurence_count
FROM     namaste_python
GROUP BY 1
HAVING   COUNT(*) > 1
ORDER BY 2 DESC
```



