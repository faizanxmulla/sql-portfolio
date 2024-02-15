-- Write a SQL Query to find the name of all reviewers who have rated their ratings with a NULL value.


SELECT reviewer_name
FROM   reviewers rv JOIN ratings r USING(reviewer_id)
WHERE  reviewer_stars IS NULL