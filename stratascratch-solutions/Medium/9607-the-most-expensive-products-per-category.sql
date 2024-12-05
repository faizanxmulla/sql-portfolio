WITH ranked_prices as (
    SELECT product_category, 
           product_name, 
           CAST(SUBSTRING(price, 2) as float) as modified_price, 
           RANK() OVER(PARTITION BY product_category ORDER BY CAST(SUBSTRING(price, 2) as float) DESC) as rn
    FROM   innerwear_amazon_com
)
SELECT product_category, product_name, modified_price
FROM   ranked_prices
WHERE  rn=1



-- NOTE: couldn't figure out the 'modified_price' part.