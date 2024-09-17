### Problem Statement

We are given a dataset with the columns: `company_name`, `acceptance`, and `spent`

We needed to add a new column `updated_acceptance`. The rules are:

1. Identify the row with the highest spent amount for each company.

2. Update the acceptance value for all rows of that company to match the Acceptance of the highest spent.

3. If the highest spent row has an acceptance of “OPT,” update all rows to match the acceptance of the second-highest spent.

**Problem Source**: [Surbhi Walecha - Linkedin Post 17.09.2024](https://www.linkedin.com/posts/surbhi-walecha_sql-data-activity-7241635324034994176-3tT_?utm_source=share&utm_medium=member_desktop)


### Schema Setup

```sql
CREATE TABLE company_spending (
    company_name VARCHAR(50),
    acceptance_status VARCHAR(50),
    spent_amount INT
);

INSERT INTO company_spending (company_name, acceptance_status, spent_amount) VALUES
('Company A', 'Accepting', 500),
('Company A', 'Non Accepting', 300),
('Company A', 'OPT', 700),
('Company B', 'Non Accepting', 200),
('Company B', 'Accepting', 100),
('Company B', 'Accepting', 300),
('Company C', 'Accepting', 400),
('Company C', 'Non Accepting', 600),
('Company C', 'Non Accepting', 800);
```

### Expected Output

| company_name | acceptance     | spent | updated_acceptance |
|--------------|----------------|-------|--------------------|
| Company A    | Accepting      | 500   | Accepting          |
| Company A    | Non Accepting  | 300   | Accepting          |
| Company A    | OPT            | 700   | Accepting          |
| Company B    | Non Accepting  | 200   | Accepting          |
| Company B    | Accepting      | 100   | Accepting          |
| Company B    | Accepting      | 300   | Accepting          |
| Company C    | Accepting      | 400   | Non Accepting      |
| Company C    | Non Accepting  | 600   | Non Accepting      |
| Company C    | Non Accepting  | 800   | Non Accepting      |



### Solution Query

```sql  
WITH ranked_companies as (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY company_name ORDER BY spent_amount desc) as rn
    FROM   company_spending
),
top_2_companies as (
    SELECT   company_name, 
             MAX(CASE WHEN rn=1 THEN acceptance_status END) AS first_acceptance,
             MAX(CASE WHEN rn=2 THEN acceptance_status END) AS second_acceptance
    FROM     ranked_companies
    GROUP BY 1
)
SELECT company_name, 
       acceptance_status,
       spent_amount,
       CASE WHEN first_acceptance='OPT' THEN second_acceptance ELSE first_acceptance END as updated_acceptance
FROM   top_2_companies tc JOIN ranked_companies rs USING(company_name)



-- NOTE: 

-- was making this mistake and got stuck: CASE WHEN acceptance_status='OPT'
```