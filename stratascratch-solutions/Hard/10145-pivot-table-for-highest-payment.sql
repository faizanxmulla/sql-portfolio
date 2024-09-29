SELECT   employeename, 
         MAX(case when year = 2011 then totalpay else 0 end ) as pay_2011,
         MAX(case when year = 2012 then totalpay else 0 end ) as pay_2012,
         MAX(case when year = 2013 then totalpay else 0 end ) as pay_2013,
         MAX(case when year = 2014 then totalpay else 0 end ) as pay_2014
FROM     sf_public_salaries
GROUP BY 1
ORDER BY 1