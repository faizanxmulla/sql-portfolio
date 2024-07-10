### Problem Statement

Which website received the most visits as reflected by the clicks between '2022-01-01' and '2022-06-01'?

Output the website URL and click count based on the descending order of the click count.

### Schema setup

```sql
CREATE TABLE google_search_websites (
    website_id INT,
    url VARCHAR(255),
    type VARCHAR(50)
);

INSERT INTO google_search_websites (website_id, url, type) VALUES
(1, 'www.reddit.com', 'forum'),
(2, 'www.selling247.com', 'business'),
(3, 'www.who.gov', 'government'),
(4, 'www.jones.com', 'blog');


CREATE TABLE google_search_activity (
    event_id INT,
    session_id INT,
    website_id INT,
    creation_dt DATETIME,
    event_type VARCHAR(50)
);

INSERT INTO google_search_activity (event_id, session_id, website_id, creation_dt, event_type) VALUES
(1, 1, 1, '2022-08-14 17:44:50', 'viewed'),
(2, 1, 1, '2022-04-14 13:44:50', 'clicked'),
(3, 2, 2, '2022-03-11 17:54:13', 'converted'),
(4, 2, 2, '2022-04-14 13:44:50', 'clicked');
```

### Solution Query

```sql
-- my approach:

SELECT   url, COUNT(*) as click_count
FROM     google_search_websites w JOIN google_search_activity a USING(website_id)
WHERE    creation_dt BETWEEN '2022-01-01' and '2022-06-01' and event_type='clicked'
GROUP BY 1
ORDER BY 2 DESC


-- solution using CTE: more clear

WITH website_clicked AS (
    SELECT   website_id, COUNT(*) click_count
    FROM     google_search_activity
    WHERE    event_type = 'clicked' AND DATE(creation_dt) BETWEEN '2022-01-01' AND '2022-06-01'
    GROUP BY 1
)
SELECT   url, click_count
FROM     google_search_websites JOIN website_clicked USING(website_id)
ORDER BY 2 DESC;
```
