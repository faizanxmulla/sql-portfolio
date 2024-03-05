-- If the End_Date of the tasks are consecutive, then they are part of the same project. Samantha is interested in finding the total number of different projects completed.

-- Write a query to output the start and end dates of projects listed by the number of days it took to complete the project in ascending order. 

-- If there is more than one project that have the same number of completion days, then order by the start date of the project.



select min(x.start_date), max(x.end_date) 
from (
    select start_date,
           end_date,
           end_date-row_number() over (order by end_date) as rn
    from projects) x 
group by x.rn
order by max(x.end_date) - min(x.start_date)


