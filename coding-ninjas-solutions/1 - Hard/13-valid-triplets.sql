-- There is a country with three schools, where each student is enrolled in exactly one school. The country is joining a competition and wants to select one student from each school to represent the country such that:

--  - member_A is selected from SchoolA,
--  - member_B is selected from SchoolB,
--  - member_C is selected from SchoolC, and
--  - The selected students' names and IDs are pairwise distinct (i.e. no two students share the same name, and no two students share the same ID).

-- Write an SQL query to find all the possible triplets representing the country under the given constraints.
-- Return the result table in any order.




-- Solution 1: brute force way (feel like there exists a more optimized solution)

SELECT a.student_name AS member_A,
       b.student_name AS member_B,
       c.student_name AS member_C
FROM   SchoolA a 
       CROSS JOIN SchoolB b 
       CROSS JOIN SchoolC c
WHERE  a.student_id <> b.student_id AND
       a.student_id <> c.student_id AND
       b.student_id <> c.student_id AND
       a.student_name <> b.student_name AND
       b.student_name <> c.student_name AND
       a.student_name <> c.student_name