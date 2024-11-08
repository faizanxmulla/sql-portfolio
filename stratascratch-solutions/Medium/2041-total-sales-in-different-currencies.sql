SELECT   EXTRACT(QUARTER FROM r.date) as quarter,
         SUM(sales_amount * exchange_rate) as total_sales
FROM     sf_exchange_rate r JOIN sf_sales_amount a 
ON       r.source_currency=a.currency and r.date=a.sales_date
WHERE    r.date BETWEEN '2020-01-01' and '2020-06-01'
GROUP BY 1



-- NOTE: solved in first attempt