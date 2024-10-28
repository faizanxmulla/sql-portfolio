### Problem Statement | [Analyst Builder Link](https://www.analystbuilder.com/questions/bankruptcy-SLjGw)

A Dating company’s revenue has decreased by 20% each year for the last three years.

The company’s total operating income is $1,000,000.

Write a query to calculate how many years it will take for the company to no longer make a profit, assuming the trend of a 20% decrease in revenue per year continues. The operating expenses are assumed to remain constant.

The output should include the year and profit until the profit reaches a negative number. It should include the year and the number it goes negative.

Order on the year from smallest to largest.



### Schema setup

```sql
CREATE TABLE financials (
    year INT,
    revenue BIGINT,
    operating_income BIGINT,
    profit BIGINT
);

INSERT INTO financials (year, revenue, operating_income, profit) VALUES
(2022, 2953125, 1000000, 1953125),
(2023, 2362500, 1000000, 1362500),
(2024, 1890000, 1000000, 890000);
```

### Solution Query

```sql
WITH RECURSIVE CTE AS (
    SELECT year,
           revenue,
           operating_income,
           (revenue - operating_income) AS profit
    FROM   financials
    WHERE  year = (SELECT MIN(year) FROM financials)
    UNION ALL
    SELECT year + 1 AS year,
           ROUND(revenue * 0.8)::bigint AS revenue,
           operating_income,
           (ROUND(revenue * 0.8) - operating_income)::bigint AS profit
    FROM   CTE
    WHERE  profit >= 0
)
SELECT   year, profit
FROM     CTE
ORDER BY year
```


### Output

| year | profit   |
|------|----------|
| 2022 | 1953125  |
| 2023 | 1362500  |
| 2024 | 890000   |
| 2025 | 512000   |
| 2026 | 209600   |
| 2027 | -32320   |