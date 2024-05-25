-- Write a query to recommend a page to a user. A recommendation is based on a page liked by user friends.

-- Assume you have two tables: a two-column table of users and their friends, and a two-column table of users and the pages they liked.

-- Assumptions:

-- Only recommend the top page to the user, and do not recommend pages that were already liked by the user.
-- Top page is defined as the page with the highest number of followers.
-- Output the user id and page recommended. Order the result in ascending order by user id.


-- friendship Table:

-- Column Name	Type
-- id	integer
-- user_id	string
-- friend_id	string


-- friendship Example Input:

-- id	user_id	friend_id
-- 1	alice	bob
-- 2	alice	charles
-- 3	alice	david


-- page_following Table:

-- Column Name	Type
-- id	integer
-- user_id	string
-- page_id	string


-- page_following Example Input:

-- id	user_id	page_id
-- 1	alice	google
-- 2	alice	facebook
-- 3	bob	google
-- 4	bob	linkedin
-- 5	bob	facebook

-- Example Output:

-- user_id	recommended_pages
-- alice	linkedin

-- Alice's friend Bob is following Google, Linkedin, and Facebook pages. 
-- However, since Alice is already following Google and Facebook, the only page that can be recommended to her is Linkedin.



WITH friend_pages AS (
    SELECT user_id AS user_id,
           page_id AS page_id
    FROM   friendship f JOIN page_following pf ON f.friend_id = pf.user_id
),
filtered_pages AS (
    SELECT fp.user_id, fp.page_id
    FROM   friend_pages fp LEFT JOIN page_following pf USING(user_id, page_id)
    WHERE  pf.page_id IS NULL
),
follower_page_count AS (
    SELECT   fp.user_id,
             fp.page_id,
             COUNT(DISTINCT pf.user_id) AS follower_count
    FROM     filtered_pages fp JOIN page_following pf USING(page_id)
    GROUP BY 1, 2
),
ranked_pages AS (
    SELECT user_id,
           page_id,
           ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY follower_count DESC) AS rank
    FROM   follower_page_count
)
SELECT   user_id,
         page_id AS recommended_pages
FROM     ranked_pages
WHERE    rank = 1
ORDER BY q

