WITH get_metrics as (
    SELECT * 
    FROM (
            SELECT AVG(price) as mean_1, COUNT(*) as n1, VAR_SAMP(price) as var_1 
            FROM   products 
            WHERE  category_id  = 9 
        ) x
	    JOIN (
            SELECT AVG(price) as mean_2, COUNT(*) as n2, VAR_SAMP(price) as var_2 
            FROM   products 
            WHERE  category_id <> 9 
        ) y
        ON 1 = 1
   )
,get_denominators as (
    SELECT *, 
           POWER(var_1, 2) / n1 as x1, 
           POWER(var_2, 2) / n2 as x2  
    FROM   get_metrics
)
SELECT CAST((mean_1 - mean_2) / SQRT((var_1 / n1)+(var_2 / n2)) as DECIMAL(10, 5)) as t_value, 
       FLOOR((POWER((x1 + x2), 2))/((POWER(x1, 2)) / (n1-1) + (POWER(x2, 2))/(n2-1))) as d_o_f
FROM   get_denominators



-- refer this for formula : https://www.statology.org/welchs-t-test/