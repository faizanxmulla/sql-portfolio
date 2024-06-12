WITH CTE AS (
    SELECT *,
           2 *(ROW_NUMBER() OVER(ORDER BY page_number) - 1) AS left_page,
           2 *(ROW_NUMBER() OVER(ORDER BY page_number) - 1) + 1 AS right_page
    FROM   cookbook_titles
)
SELECT c.left_page, ct1.title, ct2.title
FROM   CTE c LEFT JOIN cookbook_titles ct1 ON c.left_page = ct1.page_number 
             LEFT JOIN cookbook_titles ct2 ON c.right_page = ct2.page_number


-- NOTE: couldnt solve on my own; mainly because wasnt able to understand the question fully.