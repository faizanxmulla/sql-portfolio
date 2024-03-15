-- Write an SQL query to find the best-selling product in each product category. If there are two or more products with the same sales quantity, go by whichever product which has the higher review rating.

-- Return the category name and product name in alphabetical order of the category.



with cte as (
    select *, rank() over(PARTITION BY category_name ORDER BY sales_quantity desc, rating desc)
    from   products p JOIN product_sales ps USING(product_id)
)
select   category_name, product_name
from     cte 
where    rank=1
order by 1, 2



-- remarks: initially was using "rating desc" separately and not as part of the window function.