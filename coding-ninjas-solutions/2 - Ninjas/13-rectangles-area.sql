-- Write an SQL query to report all possible axis-aligned rectangles with non-zero area that can be formed by any two points in the Points table.


SELECT   a.id as p1, b.id as p2, ABS(b.x_value - a.x_value) * ABS(b.y_value - a.y_value) as area
FROM     Points a JOIN Points b ON a.id < b.id
WHERE    a<>b and ABS(b.x_value - a.x_value) * ABS(b.y_value - a.y_value) > 0
ORDER BY 3 DESC, 1, 2


-- remarks: didnt read the question properly for this condition --> a.id < b.id 