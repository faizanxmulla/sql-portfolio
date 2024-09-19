### Problem Statement 

The LinkedIn Creator team is looking for power creators who use their personal profile as a company or influencer page. If someone's LinkedIn page has more followers than the company they work for, we can safely assume that person is a power creator. 

Write a query to return the IDs of these LinkedIn power creators.

**Assumption:** A person can work at multiple companies.

**Link**: https://datalemur.com/questions/linkedin-power-creators-part2



### Schema Setup

```sql
CREATE TABLE personal_profiles (
    profile_id INT,
    name VARCHAR(50),
    followers INT
);

CREATE TABLE employee_company (
    personal_profile_id INT,
    company_id INT
);

CREATE TABLE company_pages (
    company_id INT,
    name VARCHAR(50),
    followers INT
);


INSERT INTO personal_profiles VALUES 
(1, 'Nick Singh', 92000),
(2, 'Zach Wilson', 199000),
(3, 'Daliana Liu', 171000),
(4, 'Ravit Jain', 107000),
(5, 'Vin Vashishta', 139000),
(6, 'Susan Wojcicki', 39000);

INSERT INTO employee_company VALUES 
(1, 4),
(1, 9),
(2, 2),
(3, 1),
(4, 3),
(5, 6),
(6, 5);

INSERT INTO company_pages VALUES 
(1, 'The Data Science Podcast', 8000),
(2, 'Airbnb', 700000),
(3, 'The Ravit Show', 6000),
(4, 'DataLemur', 200),
(5, 'YouTube', 16000000),
(6, 'DataScience.Vin', 4500),
(9, 'Ace The Data Science Interview', 4479);
```


### Expected Output

profile_id |	creator_name |
--|--|
1 |	Nick Singh |
3 |	Daliana Liu |
4 |	Ravit Jain |
5 |	Vin Vashishta |



### Solution Query


```sql
WITH power_creators as (
  SELECT pp.profile_id,
         pp.name as creator_name,
         pp.followers as creator_followers,
         cp.name as company_name,
         cp.followers as company_followers,
         CASE WHEN pp.followers > cp.followers THEN 1 ELSE 0 END as power_creator_flag
  FROM   employee_company as ec JOIN personal_profiles as pp ON ec.personal_profile_id = pp.profile_id                    
                                JOIN company_pages as cp ON ec.company_id = cp.company_id
)
SELECT   profile_id, creator_name
FROM     power_creators
GROUP BY 1, 2
HAVING   MIN(power_creator_flag) = 1
ORDER BY 1 



-- Solution 2: using MAX() aggregate function w/ window function.

WITH CTE as (
    SELECT pp.profile_id, 
           pp.name as creator_name, 
           pp.followers as personal_followers, 
           MAX(cp.followers) OVER(PARTITION BY pp.profile_id, pp.name) as max_company_followers
    FROM   personal_profiles pp JOIN employee_company ec ON pp.profile_id=ec.personal_profile_id 
                                JOIN company_pages cp USING(company_id)
)
SELECT   profile_id, creator_name
FROM     CTE
WHERE    personal_followers > max_company_followers
GROUP BY 1, 2
```