-- Tesla is investigating production bottlenecks and they need your help to extract the relevant data. Write a query to determine which parts have begun the assembly process but are not yet finished.

-- Assumptions:

-- 1. parts_assembly table contains all parts currently in production, each at varying stages of the assembly process.
-- 2. An unfinished part is one that lacks a finish_date.


-- Solution (as well as first approach): 
SELECT part, assembly_step
FROM   parts_assembly
WHERE  finish_date IS NULL;

