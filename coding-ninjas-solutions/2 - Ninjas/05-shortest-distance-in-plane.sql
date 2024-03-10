-- Table point_2d holds the coordinates (x,y) of some unique points (more than two) in a plane.

-- Write a query to find the shortest distance between these points rounded to 2 decimals.


SELECT   MIN(ABS(b.x - a.x) + ABS(b.y - a.y)) as shortest
FROM     point_2d a, point_2d b
WHERE    a <> b



-- my attempt: 

SELECT   a.x, a.y, b.x, b.y, ABS(b.x - a.x) + ABS(b.y - a.y) as manhattan_dist
FROM     point_2d a, point_2d b
GROUP BY 1, 2, 3, 4


-- remarks:  
-- 1. manhattan distance: |x2 - x1| + |y2 - y1|
-- 2. forgot a<> b condition. 